SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ModulesUpdate]
 @ModuleID int, 
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
 @IsModified bit,  
 @UpdatedOn datetime,  
 @PortalID int, 
 @UpdatedBy nvarchar(256) 
AS
SET @PortalID = 1

UPDATE [dbo].[Modules] SET
 [FriendlyName] = @FriendlyName,
 [Description] = @Description,
 [Version] = @Version,
 [IsPremium] = @IsPremium,
 [IsAdmin] = @IsAdmin,
 [BusinessControllerClass] = @BusinessControllerClass,
 [FolderName] = @FolderName,
 [ModuleName] = @ModuleName,
 [SupportedFeatures] = @SupportedFeatures,
 [CompatibleVersions] = @CompatibleVersions,
 [Dependencies] = @Dependencies,
 [Permissions] = @Permissions,
 [PackageID] = @PackageID,
 [IsActive] = @IsActive,
 [IsModified] = @IsModified,
 [UpdatedOn] = @UpdatedOn,
 [PortalID] = @PortalID,
 [UpdatedBy] = @UpdatedBy
WHERE
 [ModuleID] = @ModuleID





GO
