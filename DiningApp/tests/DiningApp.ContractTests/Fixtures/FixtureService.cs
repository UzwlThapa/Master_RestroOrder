// Test-only WebService fixtures. They exercise the SAME invoker + shim pipeline production uses
// (AsmxInvoker.RunWebMethodAsync), but with zero DB access, so CI runs them on any OS.
#pragma warning disable
using System;
using System.Web.Services;

namespace DiningApp.ContractTests.Fixtures {
    [WebService(Name = "FixtureService")]
    public class FixtureService : WebService {

        [WebMethod]
        public void WriteEnvelope() {
            // legacy loose envelope shape written via Context.Response (RoLoginWebService pattern)
            Context.Response.Write("{\"statusCode\":200,\"message\":\"ok\",\"data\":[{\"TableNo\":\"5\"}]}");
        }

        [WebMethod]
        public string ReturnValueOnly() {
            return "{\"statusCode\":200,\"message\":\"from-return\",\"data\":null}";
        }

        [WebMethod]
        public void EchoParams(string Alpha, int Beta, bool Gamma) {
            Context.Response.Write("{\"alpha\":\"" + Alpha + "\",\"beta\":" + Beta + ",\"gamma\":" +
                (Gamma ? "true" : "false") + "}");
        }

        [WebMethod]
        public void ClearAfterWrite() {
            // UpdateOrder's empty-table branch pattern: write junk, Clear(), write real body.
            Context.Response.Write("STALE-CONTENT-MUST-NOT-LEAK");
            Context.Response.Clear();
            Context.Response.Write("{\"statusCode\":200,\"message\":\"clean\",\"data\":[]}");
        }

        [WebMethod]
        public void MalformedTableTransfer() {
            // Byte-exact legacy bug we must preserve (DINING_APP_MASTER_PROMPT §3): unquoted key + stray quote.
            Context.Response.Write("{ oldTable:5, newTable\": 7}");
        }

        [WebMethod]
        public void Boom() {
            throw new InvalidOperationException("fixture failure");
        }

        [WebMethod]
        public void NeedsContext() {
            // Must fault if invoked outside the HTTP pipeline (no AsyncLocal context bound).
            Context.Response.Write("{\"session\":\"" + (Context.Session["k"] ?? "none") + "\"}");
        }
    }
}
