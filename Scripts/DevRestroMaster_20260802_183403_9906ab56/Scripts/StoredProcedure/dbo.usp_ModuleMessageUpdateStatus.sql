SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModuleMessageUpdateStatus]
(
 @ModuleID INT,
 @IsActive BIT
)
AS
BEGIN
 DECLARE @MID INT
 SELECT 
  @MID=md.ModuleID 
 FROM 
  UserModules um 
 INNER JOIN 
  ModuleDefinitions md
 ON 
  um.ModuleDefID=md.ModuleDefID 
 WHERE 
  um.UserModuleID=@ModuleID

 
 UPDATE 
  ModuleMessage
 SET 
  IsActive=@IsActive
 WHERE 
  ModuleID=@MID 
END





GO
