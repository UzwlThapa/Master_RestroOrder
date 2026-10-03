// ASMX-parity invoker for the verbatim-ported web services.
// Legacy contract: every method returns a JSON *string* written either as the method return value
// or via Context.Response.Write; parameter binding is case-insensitive from query string / form /
// raw-JSON body; unparseable values fall back to type defaults (exactly like System.Web.Services).
#pragma warning disable
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace DiningApp.Api {
    public static class AsmxInvoker {
        const int DefaultTimeoutMs = 120_000; // legacy SP calls use CommandTimeout=0; guard requests anyway

        class TimeoutError : Exception { public TimeoutError(string m) : base(m) { } }

        // Program.cs maps each discovered WebMethod to its own route at startup (fast, no per-request
        // reflection lookup). This helper keeps the legacy "one URL per service + method param" shape:
        // POST/GET <basePath>/<MethodName> is handled by resolving MethodName on the service type.
        public static async Task<bool> InvokeAsync(object service, string methodName, HttpContext http) {
            // Legacy ASMX surfaced unhandled WebMethod exceptions as SOAP faults (HTTP 500). Clients
            // treat any non-2xx as a network error and show a friendly retry message, so faults stay
            // structured JSON with non-200 status. Returns false if the response was already started.
            try {
                return await RunWebMethodAsync(service, service.GetType(), methodName, http);
            } catch (TimeoutError tex) {
                await WriteFaultAsync(http, 504, "Request timed out on the server. Please retry.");
                return false;
            } catch (Exception ex) {
                await WriteFaultAsync(http, 500, "Internal server error: " + ex.Message);
                return false;
            }
        }

        // Legacy parity: an unhandled exception in an ASMX WebMethod returned HTTP 500. The Android client
        // maps every non-2xx to a friendly network error, so faults MUST stay non-200 (a JSON fault body on
        // 200 would be parsed as a successful empty response by Gson and silently corrupt UI state).
        public static async Task WriteFaultAsync(HttpContext http, int status, string message) {
            if (http.Response.HasStarted) return;
            // shim-free: clear our buffered state, then reset the real Kestrel response
            System.Web.Services.WebService.ClearCurrentContext();
            http.Response.Clear();
            http.Response.StatusCode = status;
            http.Response.ContentType = "application/json; charset=utf-8";
            var esc = (message ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " ");
            var bytes = Encoding.UTF8.GetBytes("{\"statusCode\":" + status + ",\"message\":\"" + esc + "\",\"data\":null}");
            await http.Response.Body.WriteAsync(bytes, 0, bytes.Length);
        }

        // Runs one ported WebMethod with full legacy request semantics:
        //  * AsyncLocal HttpContext binding for Context.Response / Server.MapPath
        //  * case-insensitive lenient parameter binding (query/form/raw-JSON body)
        //  * hard timeout (legacy SP calls could hang; we surface 504 instead of tying up Kestrel)
        // Returns true when the response was written. Exceptions propagate to the caller's handler.
        public static async Task<bool> RunWebMethodAsync(object service, Type serviceType, string methodName, HttpContext http) {
            var m = serviceType.GetMethods(BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly)
                .FirstOrDefault(x => string.Equals(x.Name, methodName, StringComparison.OrdinalIgnoreCase)
                                  && x.GetCustomAttributes(typeof(System.Web.Services.WebMethodAttribute), true).Length > 0);
            if (m == null) { await WriteFaultAsync(http, 404, "Method '" + methodName + "' not found on " + serviceType.Name); return false; }

            var ctx = new System.Web.HttpContextBase();
            var xff = http.Request.Headers["X-Forwarded-For"].ToString();
            ctx.Request.UserHostAddress = !string.IsNullOrEmpty(xff)
                ? xff.Split(',')[0].Trim()
                : (http.Connection.RemoteIpAddress?.ToString() ?? "");
            ctx.Request.UserAgent = http.Request.Headers["User-Agent"].ToString();
            System.Web.Services.WebService.SetCurrentContext(ctx);
            try {
                object[] args = await BindArgumentsAsync(m, http);
                object result;
                var run = Task.Run(() => {
                    try { return m.Invoke(service, args); }
                    catch (TargetInvocationException tie) { throw tie.InnerException ?? tie; }
                });
                var done = await Task.WhenAny(run, Task.Delay(DefaultTimeoutMs));
                if (done != run)
                    throw new TimeoutError(m.Name + " exceeded " + DefaultTimeoutMs + "ms");
                result = await run;

                string returned = result as string;
                string written = ctx.Response.GetWritten();
                // PROD-BUGFIX: legacy ASMX gives the *written* response precedence over the return
                // value whenever anything was written — including an empty-string write (the LoggedOut
                // pattern writes "" explicitly). Using IsNullOrEmpty here silently swapped in a stale
                // return value for deliberately-empty bodies. Distinguish "nothing written" (null)
                // from "empty body written" ("").
                string body = written != null ? written : (returned ?? "");

                string ct = ctx.Response.ContentType;
                if (string.IsNullOrWhiteSpace(ct))
                    ct = LooksLikeJson(body) ? "application/json; charset=utf-8" : "text/plain; charset=utf-8";
                else if (ct.Equals("application/json", StringComparison.OrdinalIgnoreCase))
                    ct = "application/json; charset=utf-8";

                http.Response.StatusCode = 200;
                http.Response.ContentType = ct;
                var bytes = Encoding.UTF8.GetBytes(body);
                await http.Response.Body.WriteAsync(bytes, 0, bytes.Length);
                // PROD-BUGFIX: body is now on the wire. Mark the shim buffer flushed so any late
                // Response.Clear()/Write() inside the WebMethod becomes a no-op instead of blanking
                // or appending to an already-sent response (matches real ASMX flush semantics).
                System.Web.Services.WebService.MarkFlushed(ctx);
                return true;
            } finally {
                System.Web.Services.WebService.ClearCurrentContext();
            }
        }

        static bool LooksLikeJson(string s) {
            if (string.IsNullOrWhiteSpace(s)) return false;
            var t = s.TrimStart();
            return t.StartsWith("{") || t.StartsWith("[") || t.StartsWith("\"");
        }

        static async Task<object[]> BindArgumentsAsync(MethodInfo m, HttpContext http) {
            var ps = m.GetParameters();
            var args = new object[ps.Length];
            Dictionary<string, JToken> bodyJson = null;

            // Prefer structured sources over the raw body (legacy pages send form/query params).
            IFormCollection form = null;
            if (http.Request.HasFormContentType) {
                try { form = await http.Request.ReadFormAsync(); } catch { form = null; }
            }

            for (int i = 0; i < ps.Length; i++) {
                var p = ps[i];
                string name = p.Name;
                string raw = null;
                bool hasRaw = false;

                if (form != null && form.TryGetValue(name, out var fv)) { raw = fv.ToString(); hasRaw = true; }
                if (!hasRaw && http.Request.Query.TryGetValue(name, out var qv)) { raw = qv.ToString(); hasRaw = true; }
                if (!hasRaw) {
                    // whole-body convenience: single string param takes the raw JSON body
                    if (p.ParameterType == typeof(string) && ps.Length == 1) {
                        http.Request.EnableBuffering();
                        using (var sr = new StreamReader(http.Request.Body, Encoding.UTF8, false, 4096, true)) {
                            raw = await sr.ReadToEndAsync();
                        }
                        http.Request.Body.Position = 0;
                        hasRaw = !string.IsNullOrWhiteSpace(raw);
                    } else {
                        // complex/multiple params: match body JSON properties case-insensitively
                        if (bodyJson == null) bodyJson = await ReadBodyAsJsonAsync(http);
                        if (bodyJson != null && TryGet(bodyJson, name, out var tok)) {
                            args[i] = TokToValue(tok, p.ParameterType);
                            continue;
                        }
                    }
                }
                args[i] = hasRaw ? StringToValue(raw, p.ParameterType) : (p.HasDefaultValue ? p.DefaultValue : DefaultValue(p.ParameterType));
            }
            return args;
        }

        static async Task<Dictionary<string, JToken>> ReadBodyAsJsonAsync(HttpContext http) {
            try {
                http.Request.EnableBuffering();
                string body;
                using (var sr = new StreamReader(http.Request.Body, Encoding.UTF8, false, 4096, true))
                    body = await sr.ReadToEndAsync();
                http.Request.Body.Position = 0;
                if (string.IsNullOrWhiteSpace(body)) return null;
                var tk = JToken.Parse(body);
                if (tk is JObject o) return o.Properties().ToDictionary(p => p.Name, p => p.Value, StringComparer.OrdinalIgnoreCase);
                return null;
            } catch { return null; }
        }

        static bool TryGet(Dictionary<string, JToken> d, string name, out JToken tok) {
            if (d.TryGetValue(name, out tok)) return true;
            // legacy JS serializers sometimes send camelCase for PascalCase params
            var alt = d.Keys.FirstOrDefault(k => string.Equals(k, name, StringComparison.OrdinalIgnoreCase));
            if (alt != null) { tok = d[alt]; return true; }
            tok = null; return false;
        }

        static object TokToValue(JToken tok, Type t) {
            if (tok == null || tok.Type == JTokenType.Null) return DefaultValue(t);
            try {
                if (t == typeof(string)) return tok.Type == JTokenType.String ? tok.Value<string>() : tok.ToString(Formatting.None);
                if (t == typeof(int)) return (int?)tok ?? 0;
                if (t == typeof(long)) return (long?)tok ?? 0L;
                if (t == typeof(bool)) return (bool?)tok ?? false;
                if (t == typeof(decimal)) return (decimal?)tok ?? 0m;
                if (t == typeof(double)) return (double?)tok ?? 0d;
                if (t == typeof(DateTime)) return (DateTime?)tok ?? default;
                if (t.IsEnum) return Enum.Parse(t, tok.ToString(), true);
                return tok.ToObject(t);
            } catch { return DefaultValue(t); }
        }

        static object StringToValue(string raw, Type t) {
            try {
                if (t == typeof(string)) return raw;
                if (raw == null) return DefaultValue(t);
                var s = raw.Trim();
                // Legacy ASMX coerces JSON-encoded scalars too: old web pages send quoted values
                // ("\"7\"", "\"true\"") in query/form params. Strip one layer of surrounding quotes
                // before numeric/bool parsing so int.TryParse doesn't silently fall back to 0.
                if (s.Length >= 2 && s[0] == '"' && s[s.Length - 1] == '"')
                    s = s.Substring(1, s.Length - 2);
                if (t == typeof(int)) return int.TryParse(s, NumberStyles.Integer, CultureInfo.InvariantCulture, out var iv) ? iv : 0;
                if (t == typeof(long)) return long.TryParse(s, NumberStyles.Integer, CultureInfo.InvariantCulture, out var lv) ? lv : 0L;
                if (t == typeof(bool)) return bool.TryParse(s, out var bv) ? bv : (s == "1");
                if (t == typeof(decimal)) return decimal.TryParse(s, NumberStyles.Any, CultureInfo.InvariantCulture, out var dv) ? dv : 0m;
                if (t == typeof(double)) return double.TryParse(s, NumberStyles.Any, CultureInfo.InvariantCulture, out var vv) ? vv : 0d;
                if (t == typeof(DateTime)) return DateTime.TryParse(s, CultureInfo.InvariantCulture, DateTimeStyles.None, out var dt) ? dt : default;
                if (typeof(System.Collections.IEnumerable).IsAssignableFrom(t) && t != typeof(string) && (s.StartsWith("[") || s.StartsWith("{")))
                    return JsonConvert.DeserializeObject(s, t);
                if (t.IsClass || t.IsInterface) {
                    if (s.StartsWith("{") || s.StartsWith("[")) return JsonConvert.DeserializeObject(s, t);
                    return DefaultValue(t);
                }
                return Convert.ChangeType(s, t, CultureInfo.InvariantCulture);
            } catch { return DefaultValue(t); }
        }

        static object DefaultValue(Type t) => t.IsValueType ? Activator.CreateInstance(t) : null;
    }
}
