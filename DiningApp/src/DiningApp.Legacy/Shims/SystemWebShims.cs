// Minimal .NET-8 replacements for the System.Web / legacy surface used by the ported code.
#pragma warning disable
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.IO;
using System.Text;

namespace System.Web.Services.Description { public class WebServiceAttribute : Attribute { public string Namespace { get; set; } } }
namespace System.Web.Services {
    public class WebServiceBindingAttribute : Attribute { public object ConformsTo { get; set; } }
    public enum WsiProfiles { BasicProfile1_1 }
    [AttributeUsage(AttributeTargets.Method)] public class WebMethodAttribute : Attribute { }
}
namespace System.Web.Script.Services {
    [AttributeUsage(AttributeTargets.Class|AttributeTargets.Method)] public class ScriptServiceAttribute : Attribute { }
    [AttributeUsage(AttributeTargets.Method)] public class ScriptMethodAttribute : Attribute { public bool UseHttpGet { get; set; } public object ResponseFormat { get; set; } }
    public enum ResponseFormat { Json, Xml }
}
namespace System.Web.Services.Protocols {
    [AttributeUsage(AttributeTargets.Method)] public class SoapDocumentMethodAttribute : Attribute { public object RequestNamespace { get; set; } public object ResponseNamespace { get; set; } public object Use { get; set; } }
}
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
        public void Clear() { }
        public void Write(string s) { _w.Write(s); }
        internal string GetWritten() => _w.ToString();
    }
    public class HttpRequestWrapper {
        public string UserHostAddress { get; set; } = "";
        public string UserAgent { get; set; } = "";
        public string[] AllKeys => new string[0];
        public string this[string k] => null;
    }
    public class HttpServerUtilityWrapper { public string MapPath(string p) => Path.Combine(AppContext.BaseDirectory, "upload", p.TrimStart('~','/','\\')); }
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
namespace Hangfire {
    public static class BackgroundJob {
        // Ported call sites only enqueue fire-and-forget sync jobs; DiningApp runs them via the hosted scheduler instead.
        public static string Enqueue(Action a) { try { a(); } catch { } return "immediate"; }
        public static string Enqueue<T>(System.Linq.Expressions.Expression<Action<T>> e) { return "noop"; }
    }
}
