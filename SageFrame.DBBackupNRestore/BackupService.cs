using System;
using System.IO;
using System.Net.Mail;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace SageFrame.DBBackupNRestore
{
    /// <summary>
    /// Enhanced Backup Service with Error Handling, Verification, and Notifications
    /// </summary>
    public class BackupService
    {
        private readonly string _connectionString;
        private readonly string _backupPath;
        private readonly string _smtpServer;
        private readonly int _smtpPort;
        private readonly string _alertEmail;
        private readonly int _retentionDays;

        public BackupService()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["SiteDatabase"]?.ConnectionString
                ?? throw new ConfigurationErrorsException("SiteDatabase connection string not found");
            
            _backupPath = ConfigurationManager.AppSettings["BackupPath"] 
                ?? throw new ConfigurationErrorsException("BackupPath not configured in appSettings");
            
            _smtpServer = ConfigurationManager.AppSettings["SMTPServer"] ?? "";
            _smtpPort = int.TryParse(ConfigurationManager.AppSettings["SMTPPort"], out var port) ? port : 587;
            _alertEmail = ConfigurationManager.AppSettings["AlertEmail"] ?? "";
            _retentionDays = int.TryParse(ConfigurationManager.AppSettings["BackupRetentionDays"], out var days) ? days : 30;

            // Ensure backup directory exists
            if (!Directory.Exists(_backupPath))
            {
                Directory.CreateDirectory(_backupPath);
            }
        }

        /// <summary>
        /// Execute database backup with full error handling and verification
        /// </summary>
        public BackupResult ExecuteBackup(string databaseName, string backupNamePrefix = "")
        {
            var result = new BackupResult();
            string backupFileName = "";
            string backupFullPath = "";

            try
            {
                GlobalErrorHandler.LogInfo($"Starting backup for database: {databaseName}");

                // Generate backup filename with timestamp
                string timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
                string prefix = string.IsNullOrEmpty(backupNamePrefix) ? "" : backupNamePrefix + "_";
                backupFileName = $"{prefix}{databaseName}_{timestamp}.bak";
                backupFullPath = Path.Combine(_backupPath, backupFileName);

                using (var conn = new SqlConnection(_connectionString))
                {
                    conn.Open();

                    // Step 1: Execute backup with compression and checksum
                    string backupSql = $@"
                        BACKUP DATABASE [{databaseName}]
                        TO DISK = @BackupPath
                        WITH FORMAT, COMPRESSION, CHECKSUM, STATS = 10";

                    using (var cmd = new SqlCommand(backupSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@BackupPath", backupFullPath);
                        cmd.CommandTimeout = 600; // 10 minutes timeout
                        cmd.ExecuteNonQuery();
                    }

                    GlobalErrorHandler.LogInfo($"Backup completed: {backupFullPath}");

                    // Step 2: Verify backup integrity
                    result.IsValid = VerifyBackupIntegrity(databaseName, backupFullPath, conn);
                    
                    if (!result.IsValid)
                    {
                        throw new Exception("Backup verification failed - backup file may be corrupted");
                    }

                    // Step 3: Get backup file size
                    FileInfo fileInfo = new FileInfo(backupFullPath);
                    result.BackupSizeMB = Math.Round(fileInfo.Length / (1024.0 * 1024.0), 2);
                    
                    // Step 4: Cleanup old backups
                    CleanupOldBackups(databaseName);

                    result.Success = true;
                    result.BackupPath = backupFullPath;
                    result.BackupDate = DateTime.Now;
                    result.Message = $"Backup successful: {backupFileName} ({result.BackupSizeMB} MB)";

                    GlobalErrorHandler.LogInfo(result.Message);

                    // Send success notification if enabled
                    if (!string.IsNullOrEmpty(_alertEmail))
                    {
                        SendEmailNotification("Backup Successful", result.Message, true);
                    }
                }
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = ex.Message;
                result.Exception = ex;

                GlobalErrorHandler.LogError($"Backup failed: {ex.Message}", ex);

                // Send failure notification
                if (!string.IsNullOrEmpty(_alertEmail))
                {
                    SendEmailNotification("Backup FAILED", 
                        $"Backup failed for {databaseName}: {ex.Message}\n\nStack Trace:\n{ex.StackTrace}", 
                        false);
                }

                // Attempt to cleanup partial backup file if it exists
                if (!string.IsNullOrEmpty(backupFullPath) && File.Exists(backupFullPath))
                {
                    try
                    {
                        File.Delete(backupFullPath);
                        GlobalErrorHandler.LogInfo($"Deleted partial backup file: {backupFullPath}");
                    }
                    catch (Exception deleteEx)
                    {
                        GlobalErrorHandler.LogError($"Failed to delete partial backup: {deleteEx.Message}", deleteEx);
                    }
                }
            }

            return result;
        }

        /// <summary>
        /// Restore database from backup file
        /// </summary>
        public RestoreResult ExecuteRestore(string databaseName, string backupFilePath)
        {
            var result = new RestoreResult();

            try
            {
                GlobalErrorHandler.LogInfo($"Starting restore for database: {databaseName} from {backupFilePath}");

                if (!File.Exists(backupFilePath))
                    throw new FileNotFoundException($"Backup file not found: {backupFilePath}");

                // Verify backup before restore
                using (var conn = new SqlConnection(_connectionString))
                {
                    conn.Open();

                    // Set database to single user mode
                    SetDatabaseSingleUser(databaseName, conn);

                    // Perform restore
                    string restoreSql = $@"
                        RESTORE DATABASE [{databaseName}]
                        FROM DISK = @BackupPath
                        WITH REPLACE, RECOVERY, STATS = 10";

                    using (var cmd = new SqlCommand(restoreSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@BackupPath", backupFilePath);
                        cmd.CommandTimeout = 600;
                        cmd.ExecuteNonQuery();
                    }

                    // Set database back to multi-user mode
                    SetDatabaseMultiUser(databaseName, conn);

                    result.Success = true;
                    result.Message = $"Database {databaseName} restored successfully";
                    GlobalErrorHandler.LogInfo(result.Message);
                }
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = ex.Message;
                result.Exception = ex;

                GlobalErrorHandler.LogError($"Restore failed: {ex.Message}", ex);
            }

            return result;
        }

        /// <summary>
        /// Verify backup integrity using RESTORE VERIFYONLY
        /// </summary>
        private bool VerifyBackupIntegrity(string databaseName, string backupPath, SqlConnection conn)
        {
            try
            {
                string verifySql = $@"RESTORE VERIFYONLY FROM DISK = @BackupPath";

                using (var cmd = new SqlCommand(verifySql, conn))
                {
                    cmd.Parameters.AddWithValue("@BackupPath", backupPath);
                    cmd.CommandTimeout = 300;
                    cmd.ExecuteNonQuery();
                }

                GlobalErrorHandler.LogInfo($"Backup verification successful for {databaseName}");
                return true;
            }
            catch (Exception ex)
            {
                GlobalErrorHandler.LogError($"Backup verification failed: {ex.Message}", ex);
                return false;
            }
        }

        /// <summary>
        /// Cleanup old backup files based on retention policy
        /// </summary>
        private void CleanupOldBackups(string databaseName)
        {
            try
            {
                string pattern = $"*{databaseName}_*.bak";
                string[] backupFiles = Directory.GetFiles(_backupPath, pattern);
                
                DateTime cutoffDate = DateTime.Now.AddDays(-_retentionDays);
                int deletedCount = 0;

                foreach (string file in backupFiles)
                {
                    FileInfo fileInfo = new FileInfo(file);
                    if (fileInfo.CreationTime < cutoffDate)
                    {
                        File.Delete(file);
                        deletedCount++;
                        GlobalErrorHandler.LogInfo($"Deleted old backup: {file}");
                    }
                }

                if (deletedCount > 0)
                {
                    GlobalErrorHandler.LogInfo($"Cleanup completed: {deletedCount} old backup(s) deleted");
                }
            }
            catch (Exception ex)
            {
                GlobalErrorHandler.LogError($"Backup cleanup failed: {ex.Message}", ex);
                // Don't throw - cleanup failure shouldn't fail the entire backup operation
            }
        }

        /// <summary>
        /// Set database to single user mode for restore
        /// </summary>
        private void SetDatabaseSingleUser(string databaseName, SqlConnection conn)
        {
            string sql = $@"
                ALTER DATABASE [{databaseName}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE";
            
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.CommandTimeout = 60;
                cmd.ExecuteNonQuery();
            }
        }

        /// <summary>
        /// Set database back to multi user mode
        /// </summary>
        private void SetDatabaseMultiUser(string databaseName, SqlConnection conn)
        {
            string sql = $@"ALTER DATABASE [{databaseName}] SET MULTI_USER";
            
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.ExecuteNonQuery();
            }
        }

        /// <summary>
        /// Send email notification for backup status
        /// </summary>
        private void SendEmailNotification(string subject, string body, bool isSuccess)
        {
            try
            {
                if (string.IsNullOrEmpty(_smtpServer) || string.IsNullOrEmpty(_alertEmail))
                    return;

                var mailMessage = new MailMessage
                {
                    From = new MailAddress("noreply@sageframe.com", "SageFrame Backup Service"),
                    Subject = $"[Backup {(isSuccess ? "SUCCESS" : "FAILED")}] {subject}",
                    Body = body,
                    IsBodyHtml = false
                };

                mailMessage.To.Add(_alertEmail);

                using (var smtpClient = new SmtpClient(_smtpServer, _smtpPort))
                {
                    smtpClient.EnableSsl = (_smtpPort == 587 || _smtpPort == 465);
                    smtpClient.Timeout = 30000;
                    smtpClient.Send(mailMessage);
                }

                GlobalErrorHandler.LogInfo($"Email notification sent: {subject}");
            }
            catch (Exception ex)
            {
                GlobalErrorHandler.LogError($"Failed to send email notification: {ex.Message}", ex);
            }
        }

        /// <summary>
        /// Get list of available backups for a database
        /// </summary>
        public List<BackupInfo> GetAvailableBackups(string databaseName)
        {
            var backups = new List<BackupInfo>();
            
            try
            {
                string pattern = $"*{databaseName}_*.bak";
                string[] backupFiles = Directory.GetFiles(_backupPath, pattern);

                foreach (string file in backupFiles)
                {
                    FileInfo fileInfo = new FileInfo(file);
                    backups.Add(new BackupInfo
                    {
                        FileName = fileInfo.Name,
                        FilePath = fileInfo.FullName,
                        FileSizeMB = Math.Round(fileInfo.Length / (1024.0 * 1024.0), 2),
                        CreatedDate = fileInfo.CreationTime,
                        DatabaseName = databaseName
                    });
                }

                // Sort by date descending
                backups.Sort((a, b) => b.CreatedDate.CompareTo(a.CreatedDate));
            }
            catch (Exception ex)
            {
                GlobalErrorHandler.LogError($"Failed to get backup list: {ex.Message}", ex);
            }

            return backups;
        }

        /// <summary>
        /// Get backup statistics
        /// </summary>
        public BackupStatistics GetBackupStatistics()
        {
            var stats = new BackupStatistics();

            try
            {
                string[] allBackups = Directory.GetFiles(_backupPath, "*.bak");
                stats.TotalBackups = allBackups.Length;
                stats.TotalSizeMB = Math.Round(allBackups.Sum(f => new FileInfo(f).Length) / (1024.0 * 1024.0), 2);
                stats.OldestBackup = allBackups.Any() 
                    ? allBackups.Min(f => new FileInfo(f).CreationTime) 
                    : (DateTime?)null;
                stats.NewestBackup = allBackups.Any() 
                    ? allBackups.Max(f => new FileInfo(f).CreationTime) 
                    : (DateTime?)null;
            }
            catch (Exception ex)
            {
                GlobalErrorHandler.LogError($"Failed to get backup statistics: {ex.Message}", ex);
            }

            return stats;
        }
    }

    #region Supporting Classes

    public class BackupResult
    {
        public bool Success { get; set; }
        public bool IsValid { get; set; }
        public string BackupPath { get; set; }
        public string Message { get; set; }
        public string ErrorMessage { get; set; }
        public DateTime? BackupDate { get; set; }
        public double BackupSizeMB { get; set; }
        public Exception Exception { get; set; }
    }

    public class RestoreResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public string ErrorMessage { get; set; }
        public Exception Exception { get; set; }
    }

    public class BackupInfo
    {
        public string FileName { get; set; }
        public string FilePath { get; set; }
        public double FileSizeMB { get; set; }
        public DateTime CreatedDate { get; set; }
        public string DatabaseName { get; set; }
    }

    public class BackupStatistics
    {
        public int TotalBackups { get; set; }
        public double TotalSizeMB { get; set; }
        public DateTime? OldestBackup { get; set; }
        public DateTime? NewestBackup { get; set; }
    }

    #endregion
}
