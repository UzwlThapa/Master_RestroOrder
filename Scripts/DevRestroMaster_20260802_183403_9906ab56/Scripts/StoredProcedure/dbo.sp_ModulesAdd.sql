SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ModulesAdd]
 @ModuleID int output,
 @ModuleDefID int output,
 @Name nvarchar(128),
 @PackageType nvarchar(100), 
 @License ntext,
    @Owner nvarchar(100),
    @Organization nvarchar(100),
    @Url nvarchar(250),
    @Email nvarchar(100),
 @ReleaseNotes ntext,
 @FriendlyName nvarchar(128),
 @Description nvarchar(2000),
 @Version nvarchar(8),
 @IsPremium bit,
 @IsAdmin bit,
 @BusinessControllerClass nvarchar(200),
 @FolderName nvarchar(128),
 @ModuleName nvarchar(128),
 @SupportedFeatures int,
 @CompatibleVersions nvarchar(500),
 @Dependencies nvarchar(400),
 @Permissions nvarchar(400),
 @PackageID int,
 @IsActive bit,
 @AddedOn datetime,
 @PortalID int,
 @AddedBy nvarchar(256) 
AS

SET @PortalID=1

BEGIN TRANSACTION

INSERT INTO [dbo].[Modules] (
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
 [AddedOn],
 [PortalID],
 [AddedBy]
) VALUES (
 @FriendlyName,
 @Description,
 @Version,
 @IsPremium,
 @IsAdmin,
 @BusinessControllerClass,
 @FolderName,
 @ModuleName,
 @SupportedFeatures,
 @CompatibleVersions,
 @Dependencies,
 @Permissions,
 @PackageID,
 @IsActive, 
 @AddedOn,
 @PortalID,
 @AddedBy
)

SET @ModuleID = IDENT_CURRENT('Modules')
--INSERT INTO [dbo].[Packages] VALUES (@ObjectID, @DataID)
INSERT INTO [dbo].[ModuleDefinitions] (
 [FriendlyName],
 [ModuleID],
 [DefaultCacheTime],
 [IsActive],
 [AddedOn],
 [PortalID],
 [AddedBy]
)
VALUES (
 @FriendlyName,
 @ModuleID,
 0, 
 @IsActive,
 @AddedOn,
 @PortalID,
 @AddedBy
)
SET @ModuleDefID = IDENT_CURRENT('ModuleDefinitions')

INSERT INTO [dbo].[Packages]
           ([PortalID]
           ,[ModuleID]
           ,[Name]
           ,[FriendlyName]
           ,[Description]
           ,[PackageType]
           ,[Version]
           ,[License]
           ,[Manifest]
           ,[Owner]
           ,[Organization]
           ,[Url]
           ,[Email]
           ,[ReleaseNotes]
           ,[IsSystemPackage]
           ,[IsActive]
           ,[AddedOn]
           ,[AddedBy])
     VALUES
           (@PortalID
           ,@ModuleID
           ,@Name
           ,@FriendlyName
           ,@Description
           ,@PackageType
           ,@Version
           ,@License
           ,null
           ,@Owner
           ,@Organization
           ,@Url
           ,@Email
           ,@ReleaseNotes
           ,0
           ,1
           ,@AddedOn
           ,@AddedBy)

SET @PackageID = IDENT_CURRENT('Packages')

 UPDATE [dbo].[Modules] SET 
  PackageID = @PackageID
 WHERE
  ModuleID = @ModuleID

COMMIT
--END





GO
