SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ModulesGetByPortalID]
 @PortalID int
AS
SELECT
 [dbo].[Modules].[ModuleID],
 [dbo].[Modules].[FriendlyName],
 [dbo].[Modules].[Description],
 [dbo].[Modules].[Version],
 [dbo].[Modules].[IsPremium],
 [dbo].[Modules].[IsAdmin],
 [dbo].[Modules].[BusinessControllerClass],
 [dbo].[Modules].[FolderName],
 [dbo].[Modules].[ModuleName],
 [dbo].[Modules].[SupportedFeatures],
 [dbo].[Modules].[CompatibleVersions],
 [dbo].[Modules].[Dependencies],
 [dbo].[Modules].[Permissions],
 [dbo].[Modules].[PackageID],
 [dbo].[Modules].[IsActive],
 [dbo].[Modules].[IsDeleted],
 [dbo].[Modules].[IsModified],
 [dbo].[Modules].[AddedOn],
 [dbo].[Modules].[UpdatedOn],
 [dbo].[Modules].[DeletedOn],
 [dbo].[Modules].[PortalID],
 [dbo].[Modules].[AddedBy],
 [dbo].[Modules].[UpdatedBy],
 [dbo].[Modules].[DeletedBy]
FROM [dbo].[Modules]
INNER JOIN dbo.PortalModules ON [dbo].[Modules].[ModuleID] = dbo.PortalModules.[ModuleID]
WHERE
 dbo.PortalModules.[PortalID]=@PortalID AND (dbo.PortalModules.IsDeleted=0 or dbo.PortalModules.IsDeleted IS NULL) AND dbo.PortalModules.IsActive =1 AND [Modules].[ModuleID] NOT IN (SELECT SuperuserModuleID FROm [dbo].SystemConstrains)
ORDER BY [dbo].[Modules].[FriendlyName]





GO
