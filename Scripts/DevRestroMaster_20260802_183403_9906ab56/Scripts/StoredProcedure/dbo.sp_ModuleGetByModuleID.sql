SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ModuleGetByModuleID]
 @ModuleID INT
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
