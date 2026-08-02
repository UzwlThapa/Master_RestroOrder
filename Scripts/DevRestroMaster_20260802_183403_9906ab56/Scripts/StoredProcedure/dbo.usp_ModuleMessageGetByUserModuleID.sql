SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModuleMessageGetByUserModuleID]
(
@UserModuleID INT,
@Culture NVARCHAR(50)
)
AS
BEGIN
 DECLARE @ModuleID INT
 SELECT 
  @ModuleID=md.ModuleID 
 FROM 
  UserModules um 
 INNER JOIN 
  ModuleDefinitions md 
 ON 
  um.ModuleDefID=md.ModuleDefID 
 WHERE 
  um.UserModuleID=@UserModuleID

 SELECT 
  * 
 FROM 
  ModuleMessage 
 WHERE 
   ModuleID=@ModuleID 
  AND Culture=@Culture
END





GO
