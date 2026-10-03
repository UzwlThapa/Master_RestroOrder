// Base class + attribute surface for the ported .asmx services on ASP.NET Core.
// The ported service classes derive from System.Web.Services.WebService and use
// Context.Response / Server.MapPath exactly as in legacy ASMX; this shim provides
// that surface, backed by an AsyncLocal HttpContext set per-request by DiningApp.Api.
#pragma warning disable
using System;
using System.Threading;

namespace System.Web.Services {
    public class WebService {
        // Set per request by DiningApp.Api middleware (and cleared afterwards).
        // Backed by HttpContextBase (SystemWebShims.cs) — the type AsmxInvoker constructs.
        private static readonly AsyncLocal<HttpContextBase> _current = new();
        public static void SetCurrentContext(HttpContextBase ctx) => _current.Value = ctx;
        public static void ClearCurrentContext() => _current.Value = null;

        // PROD-BUGFIX: legacy code sometimes calls Response.Clear() *after* writing the body
        // (e.g. LoggedOut writes "" then Clears). Real ASMX would have flushed to the wire already,
        // so the clear was a no-op there. Our buffer is not flushed until the invoker writes it out,
        // so a late Clear() would silently blank an otherwise-valid response. Once flushed, Clear()
        // must become a no-op to match ASMX semantics.
        // public (not internal): invoked by DiningApp.Api's AsmxInvoker after flushing the buffered
        // body to the wire — same cross-assembly reason as HttpResponseWrapper.GetWritten().
        public static void MarkFlushed(HttpContextBase ctx) { if (ctx != null) ctx.Response.Flushed = true; }

        protected HttpContextBase Context => _current.Value ?? throw new InvalidOperationException(
            "No HttpContext bound to this call. Ported WebMethods must be invoked through the DiningApp.Api HTTP endpoints.");
        protected HttpServerUtilityWrapper Server => Context.Server;
    }

    // Legacy .asmx files use [WebService(Namespace=...)] with only `using System.Web.Services;`
    // (the Description namespace is an implementation detail of real ASMX tooling), so the
    // attribute lives here to resolve via that using.
    [AttributeUsage(AttributeTargets.Class)]
    public class WebServiceAttribute : Attribute { public string Name { get; set; } public string Description { get; set; } public string Namespace { get; set; } }

    [AttributeUsage(AttributeTargets.Class)]
    public class WebServiceBindingAttribute : Attribute { public object ConformsTo { get; set; } }
    public enum WsiProfiles { BasicProfile1_1 }

    [AttributeUsage(AttributeTargets.Method)]
    public class WebMethodAttribute : Attribute {
        public string Description { get; set; }
        public bool EnableSession { get; set; }
    }
}

namespace System.Web.Services.Description {
    // WebServiceAttribute lives in System.Web.Services (see above) so it resolves with the
    // plain `using System.Web.Services;` used by the ported .asmx classes. This namespace is
    // kept only for compatibility with any code that references the full name.
}

namespace System.Web.Script.Services {
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
    public class ScriptServiceAttribute : Attribute { }

    [AttributeUsage(AttributeTargets.Method)]
    public class ScriptMethodAttribute : Attribute {
        public bool UseHttpGet { get; set; }
        public ResponseFormat ResponseFormat { get; set; }
    }
    public enum ResponseFormat { Xml, Json }
}

namespace System.Web.Services.Protocols {
    [AttributeUsage(AttributeTargets.Method)]
    public class SoapDocumentMethodAttribute : Attribute { public object RequestNamespace { get; set; } public object ResponseNamespace { get; set; } public object Use { get; set; } }
}
