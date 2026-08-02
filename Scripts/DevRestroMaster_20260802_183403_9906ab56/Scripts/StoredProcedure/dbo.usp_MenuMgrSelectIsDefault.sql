SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrSelectIsDefault]
@MenuID INT

AS
BEGIN
 SELECT 1
 FROM   [dbo].[Menu] 
 WHERE  IsDefault = 1 AND MenuID = @MenuID         
END





GO
