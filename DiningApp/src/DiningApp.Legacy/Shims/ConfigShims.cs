// System.Configuration replacement backed by appsettings.json (ConnectionStrings + AppSettings sections).
#pragma warning disable
using System;
using System.Collections.Specialized;
using System.IO;
namespace System.Configuration {
    public static class ConfigurationManager {
        private static dynamic _root;
        private static dynamic Root() {
            if (_root == null) {
                var file = Path.Combine(AppContext.BaseDirectory, "appsettings.json");
                _root = File.Exists(file) ? Newtonsoft.Json.JsonConvert.DeserializeObject(File.ReadAllText(file)) : null;
            }
            return _root;
        }
        // Cached: read once per config-file change instead of re-parsing appsettings.json on every call.
        // Env-var override (DINING_APPSETTING__<KEY>) lets ops flip OrderPrinting/DBPrinting etc. without
        // editing files on the server — mirrors ASP.NET's "__" nesting convention.
        private static NameValueCollection _appSettings;
        private static DateTime _appSettingsStamp = DateTime.MinValue;
        public static NameValueCollection AppSettings {
            get {
                var file = Path.Combine(AppContext.BaseDirectory, "appsettings.json");
                var stamp = File.Exists(file) ? File.GetLastWriteTimeUtc(file) : DateTime.MinValue;
                if (_appSettings == null || _appSettingsStamp != stamp) {
                    var nv = new NameValueCollection();
                    try { foreach (var kv in Root().AppSettings) nv[kv.Key] = kv.Value?.ToString(); } catch { }
                    foreach (System.Collections.DictionaryEntry e in System.Environment.GetEnvironmentVariables()) {
                        var k = e.Key as string;
                        if (k != null && k.StartsWith("DINING_APPSETTING__", StringComparison.OrdinalIgnoreCase))
                            nv[k.Substring("DINING_APPSETTING__".Length)] = e.Value as string;
                    }
                    _appSettings = nv;
                    _appSettingsStamp = stamp;
                }
                return _appSettings;
            }
        }
        public static ConnectionStringSettingsCollection ConnectionStrings {
            get {
                var c = new ConnectionStringSettingsCollection();
                // Secret-safe: a connection string may live ONLY in the environment
                // (DINING_CS__<Name>) and not in appsettings.json on disk.
                var env = new System.Collections.Generic.HashSet<string>(System.StringComparer.OrdinalIgnoreCase);
                foreach (System.Collections.DictionaryEntry e in System.Environment.GetEnvironmentVariables()) {
                    var k = e.Key as string;
                    if (k != null && k.StartsWith("DINING_CS__", StringComparison.OrdinalIgnoreCase)) {
                        var name = k.Substring("DINING_CS__".Length);
                        env.Add(name);
                        c.Add(new ConnectionStringSettings(name, e.Value as string));
                    }
                }
                try {
                    foreach (var kv in Root().ConnectionStrings) {
                        string name = kv.Key;
                        if (!env.Contains(name)) c.Add(new ConnectionStringSettings(name, (string)kv.Value));
                    }
                } catch { }
                return c;
            }
        }
    }
    public class ConnectionStringSettings { public ConnectionStringSettings(string n, string v) { Name = n; ConnectionString = v; } public string Name; public string ConnectionString; }
    public class ConnectionStringSettingsCollection : System.Collections.Generic.List<ConnectionStringSettings> {
        public ConnectionStringSettings this[string name] => Find(x => x.Name == name);
    }
}
