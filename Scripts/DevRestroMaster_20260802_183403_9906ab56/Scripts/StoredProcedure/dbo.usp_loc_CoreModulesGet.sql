SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_loc_CoreModulesGet]
AS
BEGIN
SELECT cm.CoreModuleID,cm.ModuleID,m.ModuleName,m.FolderName FROM CoreModules cm 
INNER JOIN Modules m ON cm.ModuleId=m.ModuleID
END





GO
