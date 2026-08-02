SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--USP_RO_GetAllTableDataByTableName RO_SalesMaster
CREATE PROCEDURE  [dbo].[USP_RO_GetAllTableDataByTableName] 
@TableName NVARCHAR(max)
As
DECLARE @Sql NVARCHAR(max)
SET @Sql = 'SELECT * FROM ' + @TableName
EXEC(@Sql)






GO
