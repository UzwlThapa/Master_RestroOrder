SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--USP_DBBackupNRestore_BackupSelectedDatabase 'RestroOrderInventory_testMerge','RestroOrder_29_11_2016.bak','BACKUP DATABASE RestroOrder TO DISK = "E:\\Danfe Projects\\restroorder_inventory\\RestroOrder\\SageFrame\\Modules\\DatabaseBackup\\BackedUpDatabase\\RestroOrderInventory_testMerge_29_12_2016.bak" WITH FORMAT, MEDIANAME = "Z_SQLServerBackups", NAME = "RestroOrder_29_11_2016.bak";'

--[dbo].[USP_DBBackupNRestore_BackupSelectedDatabase] 'RestroOrderInventory_testMerge','RestroOrder_29_11_2017.bak','E:\\Danfe Projects\\restroorder_inventory\\RestroOrder\\SageFrame\\Modules\\DatabaseBackup\\BackedUpDatabase\\RestroOrderInventory_testMerge_29_12_2017.bak'

CREATE PROCEDURE [dbo].[USP_DBBackupNRestore_BackupSelectedDatabase]
@DatabaseName NVARCHAR(500),
@BackupName NVARCHAR(500),
@SqlQuery  NVARCHAR(1000)
AS
--EXECUTE sp_executesql @SqlQuery
 BACKUP DATABASE @DatabaseName TO DISK = @SqlQuery WITH FORMAT, MEDIANAME = 'Z_SQLServerBackups', NAME = @BackupName;

-- BACKUP DATABASE RestroOrderInventory_testMerge  
--TO DISK = 'E:\\Danfe Projects\\restroorder_inventory\\RestroOrder\\SageFrame\\Modules\\DatabaseBackup\\BackedUpDatabase\\RestrOrder_30_11_2016.bak'  with init
--   --WITH FORMAT,  
   --   MEDIANAME = 'Z_SQLServerBackups',  
   --   NAME = @BackupName;  



GO
