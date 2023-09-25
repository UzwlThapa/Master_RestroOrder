using System.Data;

namespace SageFrame.DBBackupNRestore
{
    public class DBBackupController
    {
        DBBackupProvider provider = new DBBackupProvider();
        public DataSet GetAllDatabaseName()
        {
           
            return provider.GetAllDatabaseName();
        }

        public void BackupSelectedDatabase(string _DatabaseName, string _BackupName, string SqlQuery)
        {
            provider.BackupSelectedDatabase(_DatabaseName, _BackupName, SqlQuery);
        }

        public void RestoreSelectedDatabase(string _DatabaseName, string _BackupName)
        {
            provider.RestoreSelectedDatabase(_DatabaseName, _BackupName);
        }
    }
}
