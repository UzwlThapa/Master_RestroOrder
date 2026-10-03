// Contract tests for the ASMX-parity pipeline (AsmxInvoker + System.Web shims).
// No database, no network — pure in-process invocation of the same code path Program.cs maps.
#pragma warning disable
using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Primitives;
using Newtonsoft.Json.Linq;
using Xunit;
using DiningApp.Api;
using DiningApp.ContractTests.Fixtures;

namespace DiningApp.ContractTests {
    public class AsmxInvokerContractTests {

        static DefaultHttpContext MakeHttp(string query = null, string body = null, string contentType = "application/json") {
            var http = new DefaultHttpContext();
            http.Connection.RemoteIpAddress = System.Net.IPAddress.Loopback;
            if (query != null) http.Request.QueryString = new QueryString("?" + query);
            if (body != null) {
                var bytes = Encoding.UTF8.GetBytes(body);
                http.Request.Body = new MemoryStream(bytes);
                http.Request.ContentType = contentType;
                http.Request.ContentLength = bytes.Length;
            }
            return http;
        }

        static async Task<(int status, string ct, string body)> Run(string method, HttpContext http) {
            // Harness bug fix: DefaultHttpContext.Response.Body is a NoStream by default, so writes
            // were silently discarded and every test read an empty string. Swap in a real MemoryStream
            // — the same pattern production uses via Kestrel's socket transport.
            using var capture = new MemoryStream();
            http.Response.Body = capture;
            var svc = new FixtureService();
            bool ok = await AsmxInvoker.InvokeAsync(svc, method, http);
            string body = Encoding.UTF8.GetString(capture.ToArray());
            return (http.Response.StatusCode, http.Response.ContentType, body);
        }

        // ---------- happy-path envelopes ----------

        [Fact]
        public async Task ContextResponseWrite_ReachesWire_WithJsonContentType() {
            var (status, ct, body) = await Run("WriteEnvelope", MakeHttp());
            Assert.Equal(200, status);
            Assert.StartsWith("application/json", ct);
            Assert.StartsWith(LegacyParity.OkEnvelopeStart, body);
            var j = JObject.Parse(body);
            Assert.Equal(200, (int)j["statusCode"]);
            Assert.Equal("5", (string)j["data"][0]["TableNo"]);
        }

        [Fact]
        public async Task ReturnedString_IsUsedWhenNothingWritten() {
            var (status, _, body) = await Run("ReturnValueOnly", MakeHttp());
            Assert.Equal(200, status);
            Assert.Contains("from-return", body);
        }

        // ---------- legacy parameter binding ----------

        [Fact]
        public async Task QueryParams_BindCaseInsensitively_WithLenientCoercion() {
            // ASMX binds case-insensitively and coerces "7"/"True" strings — exactly what old pages send.
            var (status, _, body) = await Run("EchoParams", MakeHttp(query: "alpha=hi&beta=%227%22&gamma=true"));
            Assert.Equal(200, status);
            var j = JObject.Parse(body);
            Assert.Equal("hi", (string)j["alpha"]);
            Assert.Equal(7, (int)j["beta"]);
            Assert.True((bool)j["gamma"]);
        }

        [Fact]
        public async Task JsonBodyParams_BindCaseInsensitively() {
            var json = "{\"ALPHA\":\"x\",\"BeTa\":3,\"gamma\":false}";
            var (status, _, body) = await Run("EchoParams", MakeHttp(body: json));
            Assert.Equal(200, status);
            var j = JObject.Parse(body);
            Assert.Equal("x", (string)j["alpha"]);
            Assert.Equal(3, (int)j["beta"]);
            Assert.False((bool)j["gamma"]);
        }

        [Fact]
        public async Task MissingParams_FallBackToTypeDefaults_NotCrash() {
            // Legacy ASMX used default(T) for absent params; Gson clients sometimes omit fields.
            var (status, _, body) = await Run("EchoParams", MakeHttp(query: "beta=1"));
            Assert.Equal(200, status);
            var j = JObject.Parse(body);
            Assert.Equal("", (string)j["alpha"] ?? "");   // null tolerated by fixture concat
            Assert.Equal(1, (int)j["beta"]);
            Assert.False((bool)j["gamma"]);
        }

        // ---------- response buffer semantics (the P0 fixes from earlier rounds) ----------

        [Fact]
        public async Task ClearAfterWrite_DiscardsStaleBufferedContent() {
            var (status, _, body) = await Run("ClearAfterWrite", MakeHttp());
            Assert.Equal(200, status);
            Assert.DoesNotContain("STALE-CONTENT-MUST-NOT-LEAK", body);
            Assert.Contains("\"clean\"", body);
        }

        [Fact]
        public async Task MalformedLegacyBody_PreservedByteExact() {
            // We must NOT repair legacy malformed JSON — old clients parse it leniently already.
            var (_, _, body) = await Run("MalformedTableTransfer", MakeHttp());
            Assert.Equal(LegacyParity.MalformedTableTransfer, body);
        }

        // ---------- fault handling ----------

        [Fact]
        public async Task ThrowingWebMethod_ReturnsNon200_StructuredJsonFault() {
            var (status, ct, body) = await Run("Boom", MakeHttp());
            Assert.Equal(500, status);                       // never 200: Gson would treat errors as success
            Assert.StartsWith("application/json", ct);
            var j = JObject.Parse(body);
            Assert.Equal(500, (int)j["statusCode"]);
            Assert.Contains("fixture failure", (string)j["message"]);
            // xunit's Assert.Null(JToken) is ambiguous with its generic overload and always fails;
            // check the JSON null explicitly.
            Assert.True(j["data"] == null || j["data"].Type == JTokenType.Null);
        }

        [Fact]
        public async Task UnknownMethodName_Returns404Fault() {
            var (status, _, body) = await Run("NoSuchMethod", MakeHttp());
            Assert.Equal(404, status);
            Assert.Contains("not found", body);
        }

        [Fact]
        public async Task FaultMessageIsJsonEscaped_NoBrokenBodyOnQuotes() {
            // ex.Message with quotes/backslashes must not produce invalid JSON (client crash guard).
            var http = MakeHttp();
            using var capture = new MemoryStream();   // NullStream by default — see Run() for why
            http.Response.Body = capture;
            var svc = new QuoteThrower();
            await AsmxInvoker.InvokeAsync(svc, "QuoteBoom", http);
            var body = Encoding.UTF8.GetString(capture.ToArray());
            var j = JObject.Parse(body); // throws if our escaping broke the JSON
            Assert.Equal(500, (int)j["statusCode"]);
        }

        // ---------- context isolation ----------

        [Fact]
        public async Task ConcurrentInvocations_DoNotShareContextBuffers() {
            // AsyncLocal per-request binding: two parallel runs must not cross-contaminate bodies.
            var t1 = Run("WriteEnvelope", MakeHttp());
            var t2 = Run("ClearAfterWrite", MakeHttp());
            await Task.WhenAll(t1, t2);
            var r1 = t1.Result; var r2 = t2.Result;
            Assert.Contains("\"ok\"", r1.body);
            Assert.DoesNotContain("STALE", r2.body);
            Assert.DoesNotContain("ok", r2.body);
        }

        [Fact]
        public void WebServiceWithoutBoundContext_FailsFast() {
            // Direct instantiation outside the pipeline must throw a clear message, not NRE deep inside.
            var svc = new NeedsCtxCaller();
            var ex = Assert.Throws<InvalidOperationException>(() => svc.Call());
            Assert.Contains("No HttpContext bound", ex.Message);
        }

        // ---------- XFF / client IP plumbing (waiter notification depends on this) ----------

        [Fact]
        public async Task XForwardedFor_FirstIpWins_ForRequestUserHostAddress() {
            var http = MakeHttp();
            using var capture = new MemoryStream();   // NullStream by default — see Run() for why
            http.Response.Body = capture;
            http.Request.Headers["X-Forwarded-For"] = new StringValues("10.0.0.42, 192.168.1.5");
            var svc = new EchoClientIp();
            await AsmxInvoker.InvokeAsync(svc, "Ip", http);
            var body = Encoding.UTF8.GetString(capture.ToArray());
            Assert.Contains("10.0.0.42", body);
        }
    }

    // extra fixtures that need instance state or base-class access outside the main fixture
    public class QuoteThrower : System.Web.Services.WebService {
        [System.Web.Services.WebMethod]
        public void QuoteBoom() { throw new Exception("bad \"quoted\" \\path\\ here"); }
    }

    public class NeedsCtxCaller {
        readonly Inner inner = new Inner();
        public void Call() => inner.Do();
        class Inner : System.Web.Services.WebService {
            public void Do() { var _ = Context; }
        }
    }

    public class EchoClientIp : System.Web.Services.WebService {
        [System.Web.Services.WebMethod]
        public void Ip() { Context.Response.Write("{\"ip\":\"" + Context.Request.UserHostAddress + "\"}"); }
    }
}
