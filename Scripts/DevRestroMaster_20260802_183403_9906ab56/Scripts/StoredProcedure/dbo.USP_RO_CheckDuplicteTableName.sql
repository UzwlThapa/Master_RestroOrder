SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_CheckDuplicteTableName]
@TableName VARCHAR(250)
AS
BEGIN
	SELECT restrotableTitle FROM RO_restroTable WHERE restrotableTitle = @TableName
END





GO
