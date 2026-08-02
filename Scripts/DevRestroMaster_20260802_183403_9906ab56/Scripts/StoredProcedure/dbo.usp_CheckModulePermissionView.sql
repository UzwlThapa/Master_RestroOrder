SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_CheckModulePermissionView] @UserModuleID INT
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
		 AND mdf.PermissionID =1
		)
	   )
		 BEGIN
		  SELECT 1
		 END
	 ELSE
		 BEGIN
			
		  --SELECT 0
		  DECLARE @IVP BIT
		
		  
		  SET @IVP = (SELECT InheritViewPermissions FROM UserModules WHERE UserModuleID = @UserModuleID) 
		  IF(@IVP=1)
				BEGIN
				  DECLARE @PID INT
				  DECLARE @PER BIT
				  DECLARE @MPER BIT
				  DECLARE @RID uniqueidentifier
		 
		  SET @RID = (SELECT RoleID FROM aspnet_UsersInRoles AUI LEFT JOIN aspnet_Users AU ON AUI.UserId=AU.UserId WHERE  AU.UserName=@UserName)

				SET @PID = (SELECT PageID FROM PageModules  WHERE UserModuleID = @UserModuleID )
				SET @PER = (SELECT AllowAccess FROM PagePermission 
				WHERE PageID=@PID 
				AND (Username=@UserName OR @RID=RoleID)
				--AND PortalID=@PortalID 
				AND PermissionID=1
				)
					IF(@PER=1)
						SELECT 1
					ELSE 
						SELECT 0
				END
			ELSE
				SELECT 0


		 END
END





GO
