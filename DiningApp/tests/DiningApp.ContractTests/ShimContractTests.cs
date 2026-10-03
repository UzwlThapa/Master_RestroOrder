// Shim-level contract tests: response buffer semantics, Server.MapPath sandboxing, config layering.
#pragma warning disable
using System;
using System.IO;
using Xunit;

namespace DiningApp.ContractTests {
    public class ShimContractTests {

        // ---------- HttpResponseWrapper (the Clear/Flush semantics that protect sent bodies) ----------

        [Fact]
        public void Response_ClearBeforeFlush_DiscardsBufferedWrites() {
            var r = new System.Web.HttpResponseWrapper();
            r.Write("junk");
            r.Clear();
            r.Write("real");
            Assert.Equal("real", r.GetWritten());
        }

        [Fact]
        public void Response_AfterMarkFlushed_ClearAndWriteAreNoOps() {
            // Mirrors AsmxInvoker: once the body is on the wire, late mutations must not blank it.
            var ctx = new System.Web.HttpContextBase();
            ctx.Response.Write("SENT");
            System.Web.Services.WebService.MarkFlushed(ctx);
            ctx.Response.Clear();
            ctx.Response.Write("APPENDED");
            Assert.Equal("SENT", ctx.Response.GetWritten());
        }

        [Fact]
        public void Response_WriteNull_IsIgnored() {
            var r = new System.Web.HttpResponseWrapper();
            r.Write((string)null);
            r.Write((object)null);
            // GetWritten() now returns null when NOTHING was written (invoker uses that to fall back
            // to the method's return value). Null writes must not flip it to "".
            Assert.Null(r.GetWritten());
        }

        // ---------- HttpServerUtilityWrapper.MapPath sandbox (path traversal hardening) ----------

        [Theory]
        [InlineData("/Modules/ROPurchaseOrder/Foo.Json")]
        [InlineData("~/Upload/x.txt")]
        [InlineData("../../Windows/win.ini")]           // hostile input must stay inside upload/
        [InlineData("/../../..%2fetc/passwd")]
        public void MapPath_AlwaysStaysUnderUploadFolder(string input) {
            var s = new System.Web.HttpServerUtilityWrapper();
            var full = s.MapPath(input);
            var root = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "upload"));
            Assert.True(full.StartsWith(root + Path.DirectorySeparatorChar, StringComparison.Ordinal) || full == root,
                $"MapPath escaped the sandbox: {input} -> {full}");
        }

        [Fact]
        public void WriteMapPathFile_BestEffort_NeverThrowsOnGarbage() {
            var s = new System.Web.HttpServerUtilityWrapper();
            // even a weird path must not throw — snapshot files are optional by design
            var ex = Record.Exception(() => s.WriteMapPathFile("\0\0bad\0", "x"));
            Assert.Null(ex);
        }

        // ---------- ConfigurationManager: env overrides beat appsettings.json ----------

        [Fact]
        public void AppSettings_EnvOverride_WinsOverFile() {
            Environment.SetEnvironmentVariable("DINING_APPSETTING__DBPrinting", "true");
            try {
                Assert.Equal("true", System.Configuration.ConfigurationManager.AppSettings["DBPrinting"]);
            } finally {
                Environment.SetEnvironmentVariable("DINING_APPSETTING__DBPrinting", null);
            }
        }

        [Fact]
        public void ConnectionStrings_EnvOnly_IsResolvableByName() {
            Environment.SetEnvironmentVariable("DINING_CS__LocalSqlServer", "Server=env-only;Integrated Security=true");
            try {
                var cs = System.Configuration.ConfigurationManager.ConnectionStrings["LocalSqlServer"];
                Assert.NotNull(cs);
                Assert.Contains("env-only", cs.ConnectionString);
            } finally {
                Environment.SetEnvironmentVariable("DINING_CS__LocalSqlServer", null);
            }
        }

        // ---------- Session isolation per context ----------

        [Fact]
        public void Session_IsPerContext_NotStaticAcrossRequests() {
            var c1 = new System.Web.HttpContextBase();
            var c2 = new System.Web.HttpContextBase();
            c1.Session["k"] = "a";
            Assert.Null(c2.Session["k"]);
        }
    }
}
