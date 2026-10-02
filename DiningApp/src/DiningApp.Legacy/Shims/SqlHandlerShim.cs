// ADO.NET replacement for SageFrame.Core SQLHandler (source lives only in SageFrame.Core.dll).
// Verified call surface: ExecuteAsList<T>, ExecuteAsDataSet, ExecuteAsObject<T>, ExecuteAsScalar, ExecuteNonQuery.
#pragma warning disable
using System;
using System.Collections.Generic;
using System.Data;
using System.Reflection;
using Microsoft.Data.SqlClient;

namespace SageFrame.Web.Utilities {
    public class SQLParameterCollection {
        internal readonly List<SqlParameter> Items = new();
        public void AddParameter(string name, object value) {
            var p = new SqlParameter(name, value ?? DBNull.Value);
            if (name != null && name.TrimStart('@').StartsWith("output", StringComparison.OrdinalIgnoreCase)) p.Direction = ParameterDirection.Output;
            Items.Add(p);
        }
        public void AddParameterOutput(string name, Type t) { Items.Add(new SqlParameter(name, t) { Direction = ParameterDirection.Output }); }
    }
    public partial class SQLHandler {
        public static SQLParameterCollection ToColl(object ps) {
            var c = new SQLParameterCollection();
            if (ps is System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, object>> l)
                foreach (var kv in l) c.AddParameter(kv.Key, kv.Value);
            else if (ps is SQLParameterCollection s) return s;
            return c;
        }
        private readonly string _cs;
        public SQLHandler() : this(SageFrame.Core.Utilities.AppConfiguration.GetConnectionString("LocalSqlServer")) { }
        public SQLHandler(string connectionString) { _cs = connectionString; }
        private SqlConnection Open() { var c = new SqlConnection(_cs); c.Open(); return c; }
        public List<T> ExecuteAsList<T>(string spName, SQLParameterCollection ps = null) {
            using var con = Open(); using var cmd = new SqlCommand(spName, con) { CommandType = CommandType.StoredProcedure, CommandTimeout = 0 };
            Fill(cmd, ps);
            using var rdr = cmd.ExecuteReader();
            var list = new List<T>();
            do {
                while (rdr.Read()) list.Add(MapRow<T>(rdr));
            } while (!rdr.IsClosed && rdr.NextResult());
            BindOutputs(cmd, ps);
            return list;
        }
        public DataSet ExecuteAsDataSet(string spName, List<KeyValuePair<string, object>> ps) => ExecuteAsDataSet(spName, ToColl(ps));
        public DataSet ExecuteAsDataSet(string spName, SQLParameterCollection ps = null) {
            using var con = Open(); using var cmd = new SqlCommand(spName, con) { CommandType = CommandType.StoredProcedure, CommandTimeout = 0 };
            Fill(cmd, ps);
            var ds = new DataSet();
            using var rdr = cmd.ExecuteReader();
            int i = 0;
            do {
                var dt = new DataTable { TableName = "Table" + (i > 0 ? i.ToString() : "") };
                for (int c = 0; c < rdr.FieldCount; c++) dt.Columns.Add(rdr.GetName(c), rdr.GetFieldType(c));
                while (rdr.Read()) dt.LoadDataRow(rdr is System.Data.Common.DbDataReader d ? GetVals(d) : null, true);
                ds.Tables.Add(dt); i++;
            } while (rdr.NextResult());
            BindOutputs(cmd, ps);
            return ds;
        }
        private static object[] GetVals(IDataReader r) { var v = new object[r.FieldCount]; r.GetValues(v); return v; }
        public T ExecuteAsObject<T>(string spName, SQLParameterCollection ps = null) where T : new() {
            var l = ExecuteAsList<T>(spName, ps);
            return l.Count > 0 ? l[0] : default;
        }
        public int ExecuteAsScalar_int(string spName, List<KeyValuePair<string, object>> ps) { var v = ExecuteAsScalar(spName, ToColl(ps)); return v == null || v == System.DBNull.Value ? 0 : System.Convert.ToInt32(v); }
        public bool ExecuteAsScalar_bool(string spName, List<KeyValuePair<string, object>> ps) { var v = ExecuteAsScalar(spName, ToColl(ps)); return v != null && v != System.DBNull.Value && System.Convert.ToBoolean(v); }
        public string ExecuteAsScalar_string(string spName, List<KeyValuePair<string, object>> ps) { var v = ExecuteAsScalar(spName, ToColl(ps)); return v == null || v == System.DBNull.Value ? null : v.ToString(); }
        public object ExecuteAsScalar(string spName, List<KeyValuePair<string, object>> ps) => ExecuteAsScalar(spName, ToColl(ps));
        public object ExecuteAsScalar(string spName, SQLParameterCollection ps = null) {
            using var con = Open(); using var cmd = new SqlCommand(spName, con) { CommandType = CommandType.StoredProcedure, CommandTimeout = 0 };
            Fill(cmd, ps);
            var r = cmd.ExecuteScalar();
            BindOutputs(cmd, ps);
            return r;
        }
        public int ExecuteNonQuery(string spName, SQLParameterCollection ps = null) {
            using var con = Open(); using var cmd = new SqlCommand(spName, con) { CommandType = CommandType.StoredProcedure, CommandTimeout = 0 };
            Fill(cmd, ps);
            var r = cmd.ExecuteNonQuery();
            BindOutputs(cmd, ps);
            return r;
        }
        
        public int ExecuteNonQuery(string sp, List<KeyValuePair<string, object>> ps) => ExecuteNonQuery(sp, ToColl(ps));
        private static void Fill(SqlCommand cmd, SQLParameterCollection ps) {
            if (ps == null) return;
            foreach (var p in ps.Items) cmd.Parameters.Add(p);
        }
        private static void BindOutputs(SqlCommand cmd, SQLParameterCollection ps) {
            if (ps == null) return;
            // output values are read back from the same SqlParameter instances attached to cmd
        }
        private static T MapRow<T>(IDataReader r) {
            var t = typeof(T);
            var obj = Activator.CreateInstance(t);
            for (int i = 0; i < r.FieldCount; i++) {
                if (r.IsDBNull(i)) continue;
                string name = r.GetName(i);
                foreach (var prop in t.GetProperties(BindingFlags.Public | BindingFlags.Instance)) {
                    if (string.Equals(prop.Name, name, StringComparison.OrdinalIgnoreCase) && prop.CanWrite) {
                        object val = r.GetValue(i);
                        var tt = Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType;
                        try {
                            if (tt == typeof(bool) && !(val is bool)) val = Convert.ToInt64(val) != 0;
                            else if (val.GetType() != tt) val = Convert.ChangeType(val, tt);
                            prop.SetValue(obj, val);
                        } catch { }
                        break;
                    }
                }
            }
            return (T)obj;
        }
    }
}
