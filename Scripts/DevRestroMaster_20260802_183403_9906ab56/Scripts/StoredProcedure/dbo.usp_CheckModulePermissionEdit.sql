SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_CheckModulePermissionEdit] @UserModuleID INT
 ,@UserName NVARCHAR(256)
 ,@PortalID INT
AS
BEGIN
 IF (
 
   EXISTS (
    SELECT UserModulePermissionID
    FROM userModulepermission ump
     ,aspnet_UsersInRoles aur
     ,aspnet_Users au
     ,ModuleDefPermission mdf
    WHERE ump.userModuleID = @userModuleID
     AND ump.portalID = @portalID
     AND ump.RoleID = aur.RoleID
     AND aur.UserID = au.UserID
     AND au.UserName = @UserName
     AND mdf.ModuleDefPermissionID = ump.ModuleDefPermissionID
     AND mdf.PermissionID = 2
    )
   )
 BEGIN
  SELECT 1
 END
 ELSE
 BEGIN
  SELECT 0
 END
END





GO
