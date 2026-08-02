SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AspNet_SqlCacheQueryRegisteredTablesStoredProcedure] 
         AS
         SELECT tableName FROM dbo.AspNet_SqlCacheTablesForChangeNotification





GO
