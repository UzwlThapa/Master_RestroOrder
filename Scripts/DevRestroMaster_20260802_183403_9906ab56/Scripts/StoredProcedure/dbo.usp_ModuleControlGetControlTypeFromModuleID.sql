SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModuleControlGetControlTypeFromModuleID]
 @ModuleDefID INT

AS
BEGIN
 SELECT 
  ControlTitle,
  ControlType,
  ControlSrc 
 FROM 
  [dbo].[ModuleControls] 
 WHERE 
  ModuleDefID = @ModuleDefID 
END





GO
