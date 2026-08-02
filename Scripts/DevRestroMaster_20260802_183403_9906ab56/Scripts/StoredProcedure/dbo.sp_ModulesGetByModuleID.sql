SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[sp_ModulesGetByModuleID]
 @ModuleID int,
 @PortalID int
AS

SELECT
 [ModuleID],
 [FriendlyName],
 [Description],
 [Version],
 [IsPremium],
 [IsAdmin],
 [BusinessControllerClass],
 [FolderName],
 [ModuleName],
 [SupportedFeatures],
 [CompatibleVersions],
 [Dependencies],
 [Permissions],
 [PackageID],
 [IsActive],
 [IsDeleted],
 [IsModified],
 [AddedOn],
 [UpdatedOn],
 [DeletedOn],
 [PortalID],
 [AddedBy],
 [UpdatedBy],
 [DeletedBy]
FROM [dbo].[Modules]
WHERE
 [ModuleID] = @ModuleID





GO
