SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PortalModulesGetByPortalID]
 @PortalID INT,
 @UserName NVARCHAR(256)
AS
BEGIN
 SELECT
 dbo.Modules.*, CAST(ISNULL((SELECT IsActive FROM dbo.PortalModules 
 WHERE dbo.PortalModules.IsActive=1 AND (dbo.PortalModules.IsDeleted=0 OR 
 dbo.PortalModules.IsDeleted Is Null) AND (dbo.PortalModules.[PortalID] = @PortalID) AND 
 ModuleID=dbo.Modules.ModuleID),0) AS BIT) AS IsPortalModuleActive
FROM dbo.Modules 
WHERE dbo.Modules.IsActive=1 AND (dbo.Modules.IsDeleted=0 or dbo.Modules.IsDeleted Is Null)

END





GO
