SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED DATE: 2010-03-20
CREATE PROCEDURE [dbo].[sp_ExtensionUpdate] @ModuleID                INT,
                                           @FolderName              NVARCHAR(128),
                                           @BusinessControllerClass NVARCHAR(200),
                                           @Dependencies            NVARCHAR(400),
                                           @Permissions             NVARCHAR(400),
                                           @IsPortable              BIT,
                                           @IsSearchable            BIT,
                                           @IsUpgradable            BIT,
                                           @IsPremium               BIT,
                                           @PackageName             NVARCHAR(128),
                                           @PackageDescription      NVARCHAR(2000),
                                           @Version                 NVARCHAR(50),
                                           @License                 NTEXT,
                                           @ReleaseNotes            NTEXT,
                                           @Owner                   NVARCHAR(100),
                                           @Organization            NVARCHAR(100),
                                           @Url                     NVARCHAR(250),
                                           @Email                   NVARCHAR(100),
                                           @PortalID                INT,
                                           @UserName                NVARCHAR(256)
AS
  BEGIN
      UPDATE [dbo].[modules]
      SET    description = @PackageDescription,
             version = @Version,
             foldername = @FolderName,
             businesscontrollerclass = @BusinessControllerClass,
             dependencies = @Dependencies,
             [permissions] = @Permissions,
             ispremium = @IsPremium,
             ismodified = 1,
             updatedon = GETDATE(),
             updatedby = @UserName
      WHERE  moduleid = @ModuleID

      UPDATE [dbo].[packages]
      SET    name = @PackageName,
             [description] = @PackageDescription,
             [version] = @Version,
             license = @License,
             releasenotes = @ReleaseNotes,
             [owner] = @Owner,
             organization = @Organization,
             url = @Url,
             email = @Email,
             ismodified = 1,
             updatedon = GETDATE(),
             updatedby = @UserName
      WHERE  [dbo].[packages].moduleid = @ModuleID
  END





GO
