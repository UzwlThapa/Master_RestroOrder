using SageFrame.Web.Utilities;
using System.Collections.Generic;
using System.Data;

namespace SageFrame.DBBackupNRestore
{
    public class DBBackupProvider
    {
        internal DataSet GetAllDatabaseName()
        {
            SQLHandler sqlhan = new SQLHandler();
            DataSet DS = sqlhan.ExecuteAsDataSet("USP_DBBackupNRestore_GetAllDatabaseName");
            return DS;
        }

        internal void BackupSelectedDatabase(string _DatabaseName, string _BackupName, string SqlQuery)
        {
            SQLHandler sqlhan = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@DatabaseName", _DatabaseName));
            Param.Add(new KeyValuePair<string, object>("@BackupName", _BackupName));
            Param.Add(new KeyValuePair<string, object>("@SqlQuery", SqlQuery));
            sqlhan.ExecuteNonQuery("USP_DBBackupNRestore_BackupSelectedDatabase", Param);
        }

        internal void RestoreSelectedDatabase(string _DatabaseName, string _BackupName)
        {
            SQLHandler sqlhan = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@DatabaseName", _DatabaseName));
            Param.Add(new KeyValuePair<string, object>("@BackupName", _BackupName));
            sqlhan.ExecuteNonQuery("USP_DBBackupNRestore_RestoreSelectedDatabase", Param);
        }
    }
}
