SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModuleControlGetModuleNameFromUserModuleId]
 @UserModuleID INT

AS
BEGIN
 SELECT 
  UserModuleTitle 
 FROM 
  [dbo].[UserModules] 
 WHERE 
  UserModuleID = @UserModuleID 
END

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON





GO
