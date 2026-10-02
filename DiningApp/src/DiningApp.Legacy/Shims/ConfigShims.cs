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
        public static NameValueCollection AppSettings {
            get {
                var nv = new NameValueCollection();
                try { foreach (var kv in Root().AppSettings) nv[kv.Key] = (string)kv.Value; } catch { }
                return nv;
            }
        }
        public static ConnectionStringSettingsCollection ConnectionStrings {
            get {
                var c = new ConnectionStringSettingsCollection();
                try { foreach (var kv in Root().ConnectionStrings) c.Add(new ConnectionStringSettings(kv.Key, (string)kv.Value)); } catch { }
                return c;
            }
        }
    }
    public class ConnectionStringSettings { public ConnectionStringSettings(string n, string v) { Name = n; ConnectionString = v; } public string Name; public string ConnectionString; }
    public class ConnectionStringSettingsCollection : System.Collections.Generic.List<ConnectionStringSettings> {
        public ConnectionStringSettings this[string name] => Find(x => x.Name == name);
    }
}
