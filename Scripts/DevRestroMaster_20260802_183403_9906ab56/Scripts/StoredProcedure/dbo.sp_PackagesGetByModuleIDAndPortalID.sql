SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[sp_PackagesGetByModuleIDAndPortalID]
 @PackageID int,
 @ModuleID int,
 @PortalID int  
AS

SELECT
 [PackageID],
 [PortalID],
 [ModuleID],
 [Name],
 [FriendlyName],
 [Description],
 [PackageType],
 [Version],
 [License],
 [Manifest],
 [Owner],
 [Organization],
 [Url],
 [Email],
 [ReleaseNotes],
 [IsSystemPackage],
 [IsActive],
 [IsDeleted],
 [IsModified],
 [AddedOn],
 [UpdatedOn],
 [DeletedOn],
 [AddedBy],
 [UpdatedBy],
 [DeletedBy]
FROM [dbo].[Packages]
WHERE
 [PackageID] = @PackageID
 AND ModuleID = @ModuleID
 --AND PortalID = @PortalID





GO
