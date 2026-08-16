SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_DBBackupNRestore_RestoreSelectedDatabase]
    @DatabaseName NVARCHAR(500),
    @BackupName NVARCHAR(500)
AS
BEGIN
    -- This procedure is called by the provider but the actual restore logic
    -- is implemented in the JRBackupRestoreDB.RestoreData method in the code-behind
    -- which uses direct SQL commands to restore the database
    
    -- The restore operation requires setting the database to single user mode,
    -- restoring from backup, and then setting it back to multi-user mode.
    -- This is handled in the application layer via JRBackupRestoreDB.RestoreData()
    
    -- Placeholder procedure for consistency with the provider pattern
    SELECT 'Restore operation should be executed via application layer' AS Message;
END
GO
