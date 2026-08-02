SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PackagesList]
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





GO
