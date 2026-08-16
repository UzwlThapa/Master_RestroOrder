using SageFrame.Web;
using System;
using System.Web.UI;
using SageFrame.DBBackupNRestore;
using System.Data.SqlClient;
using System.IO;
using Microsoft.Win32;
using System.Configuration;
using SageFrame.Web.Utilities;
using Microsoft.SqlServer.Management.Smo;
using Microsoft.SqlServer.Management.Common;
using SageFrame.RestroOrder;

public partial class Modules_DatabaseBackup_DBBackupNRestore : BaseAdministrationUserControl
{
    DBBackupController controller = new DBBackupController();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            GetDatabaseName();
            //FillDatabases();
            ReadBackupFiles();
        }
    }

    private void GetDatabaseName()
    {
        string conString;
        ConnectionStringSettings mySetting = ConfigurationManager.ConnectionStrings["SageFrameConnectionString"];
        if (mySetting == null || string.IsNullOrEmpty(mySetting.ConnectionString))
            throw new Exception("Fatal error: missing connecting string in web.config file");
        conString = mySetting.ConnectionString;
        string connectString = conString;

        SqlConnectionStringBuilder builder =
            new SqlConnectionStringBuilder(connectString);
        using (SqlConnection connection =
            new SqlConnection(builder.ConnectionString))
        {
            //connection.Open();
            // Now use the open connection.
            Console.WriteLine("Database = " + builder.InitialCatalog);
            ddlDatabases.Text = builder.InitialCatalog;

        }





    }


    protected void btnBackupScript_Click(object sender, EventArgs e)
    {
        try
        {
            SQLHandler SQLH = new SQLHandler();
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(SQLH.connectionString);
            string server = builder["Data Source"] as string;
            string database = builder["Initial Catalog"] as string;
            string user = builder["User ID"] as string;
            string password = builder["Password"] as string;
            string _BackupName = database + "_" + DateTime.Now.Hour.ToString() + "_" + DateTime.Now.Minute.ToString() + "_" + DateTime.Now.Millisecond.ToString() + "_" + DateTime.Now.Day.ToString() + "_" + DateTime.Now.Month.ToString() + "_" + DateTime.Now.Year.ToString() + ".bak";
            string destination = AppDomain.CurrentDomain.BaseDirectory + @"Modules\DatabaseBackup\BUD\" + _BackupName;
            string username = SageFrame.Common.PortalIDProvider.GetUsername(); // Get current logged-in username
            JRBackupRestoreDB.BackupDatabase(database, user, password, server, destination, username);
            lblMessage.Text = "The " + database + " database Backup with the name " + _BackupName + " successfully...";
            lblMessage.ForeColor = System.Drawing.Color.Green;
            ReadBackupFiles();
            //GetTransferScript();
        }
        catch (SqlException sqlException)
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = sqlException.Message.ToString();
        }
        catch (Exception exception)
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = exception.Message.ToString();
        }
    }
    protected void btnRestoreScript_Click(object sender, EventArgs e)
    {
        try
        {
            SQLHandler SQLH = new SQLHandler();
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(SQLH.connectionString);
            string server = builder["Data Source"] as string;
            string database = builder["Initial Catalog"] as string;
            string user = builder["User ID"] as string;
            string password = builder["Password"] as string;
            string destination = AppDomain.CurrentDomain.BaseDirectory + @"Modules\DatabaseBackup\BUD\";
            string username = SageFrame.Common.PortalIDProvider.GetUsername(); // Get current logged-in username
            string message = JRBackupRestoreDB.RestoreData(SQLH.connectionString, database, lstBackupfiles.Text, username);
            lblMessage.Text = "The " + database + " database Restore successfully...";
            lblMessage.ForeColor = System.Drawing.Color.Green;


        }
        catch (SqlException sqlException)
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = sqlException.Message.ToString();
        }
        catch (Exception exception)
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = exception.Message.ToString();
        }
    }

    private string GetSqlPath()
    {
        string path = "";

        using (RegistryKey sqlServerKey = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Microsoft SQL Server"))
        {
            foreach (string subKeyName in sqlServerKey.GetSubKeyNames())
            {
                if (subKeyName.StartsWith("MSSQL"))
                {
                    using (RegistryKey instanceKey = sqlServerKey.OpenSubKey(subKeyName))
                    {
                        string instanceName = instanceKey.GetValue("").ToString();

                        if (instanceName == "MSSQLSERVER")//say
                        {
                            //path = instanceKey.OpenSubKey(@"Setup").GetValue("SQLBinRoot").ToString();
                            path = instanceKey.OpenSubKey(@"Setup").GetValue("SQLBinRoot").ToString();
                            var go = instanceKey.OpenSubKey(@"Setup");
                            //path = Path.Combine(path, "sqlserver.exe");
                            return path;
                        }
                    }
                }
            }
        }

        return path;
    }

    private void ReadBackupFiles()
    {
        try
        {
            if (!Directory.Exists(AppDomain.CurrentDomain.BaseDirectory + @"Modules\DatabaseBackup\BUD"))
            {
                Directory.CreateDirectory(AppDomain.CurrentDomain.BaseDirectory + @"Modules\DatabaseBackup\BUD");
            }

            string[] files = Directory.GetFiles(AppDomain.CurrentDomain.BaseDirectory + @"Modules\DatabaseBackup\BUD", "*.bak");
            lstBackupfiles.DataSource = files;
            lstBackupfiles.DataBind();
            lstBackupfiles.SelectedIndex = 0;
        }
        catch (Exception exception)
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = exception.Message.ToString();
        }
    }
}

public class JRBackupRestoreDB
{
    public static void BackupDatabase(String databaseName, String userName, String password, String serverName, String destinationPath, string username)
    {
        Backup sqlBackup = new Backup();

        sqlBackup.Action = BackupActionType.Database;
        sqlBackup.BackupSetDescription = "ArchiveDataBase:" + DateTime.Now.ToShortDateString();
        sqlBackup.BackupSetName = "Archive";

        sqlBackup.Database = databaseName;

        BackupDeviceItem deviceItem = new BackupDeviceItem(destinationPath, DeviceType.File);
        ServerConnection connection = new ServerConnection(serverName, userName, password);
        Server sqlServer = new Server(connection);
        RestrOrderController roc = new RestrOrderController();
        Database db = sqlServer.Databases[databaseName];
        sqlBackup.Initialize = true;
        sqlBackup.Checksum = true;
        sqlBackup.ContinueAfterError = true;

        sqlBackup.Devices.Add(deviceItem);
        sqlBackup.Incremental = false;

        sqlBackup.ExpirationDate = DateTime.Now.AddDays(3);
        sqlBackup.LogTruncation = BackupTruncateLogType.Truncate;

        sqlBackup.FormatMedia = false;

        sqlBackup.SqlBackup(sqlServer);
        roc.SaveDBLog("B", destinationPath, username);
    }

    public static void RestoreDatabase(String databaseName, String filePath,
    String serverName, String userName, String password,
    String dataFilePath, String logFilePath)
    {
        Restore sqlRestore = new Restore();

        BackupDeviceItem deviceItem = new BackupDeviceItem(filePath, DeviceType.File);
        sqlRestore.Devices.Add(deviceItem);
        sqlRestore.Database = databaseName;

        ServerConnection connection = new ServerConnection(serverName, userName, password);
        Server sqlServer = new Server(connection);

        Database db = sqlServer.Databases[databaseName];
        sqlRestore.Action = RestoreActionType.Database;
        String dataFileLocation = dataFilePath + databaseName + ".mdf";
        String logFileLocation = logFilePath + databaseName + "_Log.ldf";
        db = sqlServer.Databases[databaseName];
        RelocateFile rf = new RelocateFile(databaseName, dataFileLocation);

        System.Data.DataTable logicalRestoreFiles = sqlRestore.ReadFileList(sqlServer);
        sqlRestore.RelocateFiles.Add(new RelocateFile(logicalRestoreFiles.Rows[0][0].ToString(), dataFileLocation));
        sqlRestore.RelocateFiles.Add(new RelocateFile(logicalRestoreFiles.Rows[1][0].ToString(), logFileLocation));

        sqlRestore.SqlRestore(sqlServer);
        db.SetOffline();
        db = sqlServer.Databases[databaseName];
        db.SetOnline();
        sqlServer.Refresh();
    }
    public static string RestoreData(string ConnectionString, string DatabaseFullPath, string backUpPath, string username)
    {
        using (SqlConnection con = new SqlConnection(ConnectionString))
        {
            con.Open();
            RestrOrderController roc = new RestrOrderController();
            roc.SaveDBLog("R", backUpPath, username);

            string UseMaster = "USE master";
            SqlCommand UseMasterCommand = new SqlCommand(UseMaster, con);
            UseMasterCommand.ExecuteNonQuery();

            string Alter1 = @"ALTER DATABASE [" + DatabaseFullPath + "] SET Single_User WITH Rollback Immediate";
            SqlCommand Alter1Cmd = new SqlCommand(Alter1, con);
            Alter1Cmd.ExecuteNonQuery();

            string Restore = @"RESTORE DATABASE [" + DatabaseFullPath + "] FROM DISK = N'" + backUpPath + @"' WITH REPLACE";//  FILE = 1,  NOUNLOAD,  STATS = 10";
            SqlCommand RestoreCmd = new SqlCommand(Restore, con);
            RestoreCmd.ExecuteNonQuery();

            string Alter2 = @"ALTER DATABASE [" + DatabaseFullPath + "] SET Multi_User";
            SqlCommand Alter2Cmd = new SqlCommand(Alter2, con);
            Alter2Cmd.ExecuteNonQuery();
            roc.SaveDBLog("R", backUpPath, username);

            return "Restore Successful";
        }
    }

}