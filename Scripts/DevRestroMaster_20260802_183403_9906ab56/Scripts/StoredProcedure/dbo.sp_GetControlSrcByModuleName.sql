SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetControlSrcByModuleName]
@ModuleName NVARCHAR(250)
AS
BEGIN
SELECT mc.ControlSrc,mc.ControlType,md.ModuleID FROM dbo.ModuleControls as mc INNER JOIN dbo.Modules as md ON mc.ModuleDefID=md.ModuleID
 WHERE md.ModuleName=@ModuleName AND mc.IsDeleted=0 AND mc.IsActive=1
END




GO
