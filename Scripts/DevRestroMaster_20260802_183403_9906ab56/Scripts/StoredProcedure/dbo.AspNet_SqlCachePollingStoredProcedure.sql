SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AspNet_SqlCachePollingStoredProcedure] AS
         SELECT tableName, changeId FROM dbo.AspNet_SqlCacheTablesForChangeNotification
         RETURN 0





GO
