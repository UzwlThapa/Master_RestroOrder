SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PackagesAdd]
 @PackageID int output,
 @PortalID int,
 @ModuleID int,
 @Name nvarchar(128),
 @FriendlyName nvarchar(250),
 @Description nvarchar(2000),
 @PackageType nvarchar(100),
 @Version nvarchar(50),
 @License ntext,
 @Manifest ntext,
 @Owner nvarchar(100),
 @Organization nvarchar(100),
 @Url nvarchar(250),
 @Email nvarchar(100),
 @ReleaseNotes ntext,
 @IsSystemPackage bit,
 @IsActive bit,
 @AddedOn datetime,
 @AddedBy nvarchar(256)
AS

SET @PortalID = 1
INSERT INTO [dbo].[Packages] (
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
 [AddedOn],
 [AddedBy]
) VALUES (
 @PortalID,
 @ModuleID,
 @Name,
 @FriendlyName,
 @Description,
 @PackageType,
 @Version,
 @License,
 @Manifest,
 @Owner,
 @Organization,
 @Url,
 @Email,
 @ReleaseNotes,
 @IsSystemPackage,
 @IsActive,
 @AddedOn,
 @AddedBy
)

select @PackageID=SCOPE_IDENTITY()





GO
