// Minimal .NET-8 replacements for the System.Web / legacy surface used by the ported code.
#pragma warning disable
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;

// NOTE: System.Web.Services / .Description / .Script.Services / .Protocols attribute types and the
// WebService base class now live in WebServiceShim.cs (single source of truth).
namespace System.Web.Caching {
    public class Cache {
        private static readonly Dictionary<string, object> _items = new();
        public object this[string k] { get => _items.TryGetValue(k, out var v) ? v : null; set => _items[k] = value; }
        public void Insert(string k, object v) { _items[k] = v; }
        public void Remove(string k) { _items.Remove(k); }
    }
}
namespace System.Web.SessionState {
    public class HttpSessionState {
        private readonly Dictionary<string, object> _s = new();
        public object this[string k] { get => _s.TryGetValue(k, out var v) ? v : null; set => _s[k] = value; }
        public void Abandon() { _s.Clear(); }
    }
}
namespace System.Web {
    public class HttpResponseWrapper {
        public string ContentType { get; set; }
        private readonly StringWriter _w = new();
        // PROD-BUGFIX: track whether anything was ever written. StringWriter.ToString() returns ""
        // when untouched, which the invoker can't distinguish from a deliberate Write("") (the
        // LoggedOut pattern). Without this flag, return-value methods that never write got their
        // return values dropped in favor of an empty body.
        internal bool HasWritten = false;
        // Set by AsmxInvoker once the buffered body has been flushed to the wire. After that, Clear()
        // is a no-op — matching real ASMX, where Response.Clear() after a flush throws/does nothing
        // rather than blanking an already-sent body (legacy LoggedOut writes "" then Clears).
        // internal (not public): WebService.MarkFlushed is the only external writer; keeping the
        // setter surface minimal prevents ported code from flipping flush state mid-method.
        internal bool Flushed = false;
        // PROD-BUGFIX: legacy ASMX Response.Clear() discards everything buffered so far. Several ported
        // methods write a payload and then call Clear() before writing the real body (e.g. UpdateOrder's
        // empty-table branch). A no-op Clear() would leak that stale content into the response.
        public void Clear() {
            if (Flushed) return;
            _w.Flush(); ((System.Text.StringBuilder)_w.GetStringBuilder()).Clear();
        }
        public void Write(string s) { if (s != null && !Flushed) { HasWritten = true; _w.Write(s); } }
        // Legacy .asmx code sometimes passes object/dynamic (JsonConvert results) to Response.Write.
        public void Write(object o) { if (o != null && !Flushed) { HasWritten = true; _w.Write(o.ToString()); } }
        // public (not internal): consumed by DiningApp.Api's AsmxInvoker to capture Context.Response.Write output.
        // Returns null when NOTHING was ever written (so the invoker falls back to the method's return
        // value), and "" when an empty body was deliberately written (LoggedOut parity).
        public string GetWritten() => HasWritten ? _w.ToString() : null;
    }
    public class HttpRequestWrapper {
        public string UserHostAddress { get; set; } = "";
        public string UserAgent { get; set; } = "";
        public string[] AllKeys => new string[0];
        public string this[string k] => null;
    }
    public class HttpServerUtilityWrapper {
        // Legacy web-root relative paths (e.g. "/Modules/ROPurchaseOrder/Foo.Json"). The old ASMX wrote
        // these debug snapshot files into the web app; several ported methods still do. We map them to
        // a writable per-app folder and make writes best-effort: a read-only or missing directory must
        // never fail an order request for a file nobody consumes.
        static readonly ConcurrentDictionary<string, SemaphoreSlim> Locks = new();
        public string MapPath(string p) {
            var rel = NormalizeRel(p);
            var full = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "upload", rel));
            // PROD-BUGFIX: defense-in-depth against path traversal via crafted legacy paths ("../../..").
            // Result MUST stay under <base>/upload regardless of what was passed in.
            var root = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "upload"));
            if (!full.StartsWith(root + Path.DirectorySeparatorChar, StringComparison.Ordinal) && full != root)
                full = Path.Combine(root, Path.GetFileName(full));
            var dir = Path.GetDirectoryName(full);
            try { if (dir != null && !Directory.Exists(dir)) Directory.CreateDirectory(dir); } catch { }
            return full;
        }
        static string NormalizeRel(string p) {
            // strip NULs first: Path.GetFullPath throws on '\0' and MapPath runs BEFORE the
            // best-effort try/catch in WriteMapPathFile — garbage input must never crash a request.
            var rel = (p ?? "").Replace("\0", "").Replace('\\', '/').TrimStart('~', '/');
            // strip any '..' segments outright — snapshot files are flat by nature
            var parts = rel.Split('/').Where(s => s.Length > 0 && s != "." && s != "..").ToList();
            return parts.Count == 0 ? "index" : string.Join("/", parts);
        }
        public void WriteMapPathFile(string path, string contents) {
            var full = MapPath(path);
            var sem = Locks.GetOrAdd(full, _ => new SemaphoreSlim(1, 1));
            try {
                sem.Wait();
                File.WriteAllText(full, contents ?? "");
            } catch { /* parity-critical response already returned; snapshot file is optional */ }
            finally { sem.Release(); }
        }
    }
    // Per-request context handed to WebService.Context (AsyncLocal in WebServiceShim.cs).
    public class HttpContextBase {
        public System.Web.SessionState.HttpSessionState Session { get; } = new();
        public HttpResponseWrapper Response { get; } = new();
        public HttpRequestWrapper Request { get; } = new();
        public HttpServerUtilityWrapper Server { get; } = new();
    }
    public class HttpContext {
        [ThreadStatic] public static HttpContext Current;
        public System.Web.SessionState.HttpSessionState Session = new();
        public HttpResponseWrapper Response = new();
        public HttpRequestWrapper Request = new();
        public HttpServerUtilityWrapper Server = new();
        public static System.Web.Caching.Cache CacheInstance = new();
        public static System.Web.Caching.Cache Cache { get => CacheInstance; set => CacheInstance = value; }
    }
}
namespace System.Web.Script.Serialization {
    // Faithful-enough replacement: delegates to Newtonsoft with camelCase-insensitive property names as JS serializer produced PascalCase.
    public class JavaScriptSerializer {
        public string Serialize(object o) => Newtonsoft.Json.JsonConvert.SerializeObject(o);
        public T Deserialize<T>(string json) => Newtonsoft.Json.JsonConvert.DeserializeObject<T>(json);
        public object Deserialize(string json, Type t) => Newtonsoft.Json.JsonConvert.DeserializeObject(json, t);
    }
}
namespace SageFrame.Core.Utilities {
    public class AppConfiguration {
        public static string GetConnectionString(string name) {
            var cs = Environment.GetEnvironmentVariable("DINING_CONNECTIONSTRING");
            if (!string.IsNullOrEmpty(cs)) return cs;
            var file = Path.Combine(AppContext.BaseDirectory, "appsettings.json");
            if (File.Exists(file)) {
                dynamic j = Newtonsoft.Json.JsonConvert.DeserializeObject(File.ReadAllText(file));
                try { return (string)j.ConnectionStrings[name]; } catch { }
            }
            throw new InvalidOperationException("Connection string '" + name + "' not found.");
        }
    }
}
// NOTE: the Hangfire shim (BackgroundJob) lives in HangfireShim.cs — single source of truth.
