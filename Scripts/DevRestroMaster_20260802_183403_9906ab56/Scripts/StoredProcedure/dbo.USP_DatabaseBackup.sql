SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_DatabaseBackup]
AS
DECLARE @name VARCHAR(50) -- database name  
DECLARE @path VARCHAR(256) -- path for backup files  
DECLARE @fileName VARCHAR(256) -- filename for backup  
DECLARE @fileDate VARCHAR(20) -- used for file name
 
-- specify database backup directory
SET @path = 'D:\DataBackup\'  
SET @name=DB_NAME()
--select @name
-- specify filename format
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 


--DECLARE db_cursor CURSOR READ_ONLY FOR  
--SELECT name 
--FROM master.dbo.sysdatabases 
--WHERE name NOT IN ('master','model','msdb','tempdb')  -- exclude these databases
--and name IN ('[RO_V2.1]') --Include these database
 
--OPEN db_cursor   
--FETCH NEXT FROM db_cursor INTO @name   
 
--WHILE @@FETCH_STATUS = 0   
--BEGIN   
	
	DECLARE @DeleteDate DATETIME = DATEADD(wk,-1,GETDATE());

   SET @fileName = @path + @name + '_' + @fileDate + '.BAK'  
   BACKUP DATABASE @name TO DISK = @fileName  
 
--   FETCH NEXT FROM db_cursor INTO @name   
--END   
--CLOSE db_cursor   
--DEALLOCATE db_cursor

	EXEC master.sys.xp_delete_file 0,@path,'BAK',@DeleteDate,0;

GO
