// LegacyParity contract tests: pin the EXACT wire shapes clients (RestroWaiter Gson + old web UI)
// already parse. Any drift in AsmxInvoker/shims that changes these literals fails CI here first.
#pragma warning disable
using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json.Linq;
using Xunit;
using DiningApp.Api;

namespace DiningApp.ContractTests {
    public class LegacyParityTests {

        static DefaultHttpContext MakeHttp() {
            var http = new DefaultHttpContext();
            http.Connection.RemoteIpAddress = System.Net.IPAddress.Loopback;
            return http;
        }

        static async Task<(int status, string body)> Run(System.Web.Services.WebService svc, string method) {
            // DefaultHttpContext.Response.Body is a NullStream by default — swap in a real MemoryStream
            // so AsmxInvoker's writes are actually captured (same role Kestrel's socket stream plays live).
            var http = MakeHttp();
            using var capture = new MemoryStream();
            http.Response.Body = capture;
            await AsmxInvoker.InvokeAsync(svc, method, http);
            return (http.Response.StatusCode, Encoding.UTF8.GetString(capture.ToArray()));
        }

        [Fact]
        public async Task SuccessEnvelope_StartsWithStatusCode200Message_ExactPrefix() {
            var (status, body) = await Run(new Fixtures.FixtureService(), "WriteEnvelope");
            Assert.Equal(200, status);
            Assert.StartsWith(LegacyParity.OkEnvelopeStart, body);
        }

        [Fact]
        public async Task FaultBody_MatchesLegacyFaultTemplate_Escaped() {
            // The fault JSON must be byte-parseable by Gson's lenient reader AND match the shape
            // Program.cs/AsmxInvoker document: {"statusCode":<n>,"message":"...","data":null}
            var (status, body) = await Run(new Fixtures.FixtureService(), "Boom");
            Assert.Equal(500, status);
            var j = JObject.Parse(body);
            Assert.Equal(500, (int)j["statusCode"]);
            Assert.NotNull(j["message"]);
            // xunit's Assert.Null(JToken) is ambiguous with its generic overload and always fails;
            // check the JSON null explicitly.
            Assert.True(j["data"] == null || j["data"].Type == JTokenType.Null);
            // key order preserved as written (Gson tolerates any, but old web UI string-searches)
            Assert.True(body.IndexOf("statusCode", StringComparison.Ordinal) < body.IndexOf("message", StringComparison.Ordinal));
        }

        [Fact]
        public async Task MalformedTableTransfer_IsNotRepaired() {
            // Regression guard: someone "fixing" the legacy malformed body would break old clients.
            var (_, body) = await Run(new Fixtures.FixtureService(), "MalformedTableTransfer");
            Assert.Equal(LegacyParity.MalformedTableTransfer, body);
        }

        [Fact]
        public async Task EmptyBodyMethod_Returns200EmptyString_LikeLegacyVoidWrite() {
            // LoggedOut writes "" then Clears — legacy delivered an empty 200 body; we must too.
            var (status, body) = await Run(new VoidWriter(), "Logged");
            Assert.Equal(200, status);
            Assert.Equal("", body);
        }

        class VoidWriter : System.Web.Services.WebService {
            [System.Web.Services.WebMethod]
            public void Logged() {
                Context.Response.Write("");
                Context.Response.Clear();
            }
        }
    }
}
