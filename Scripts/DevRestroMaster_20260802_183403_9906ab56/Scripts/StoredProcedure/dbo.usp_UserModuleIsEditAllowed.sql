SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UserModuleIsEditAllowed] (
 @UserModuleID INT,
 @PortalID INT,
 @UserName NVARCHAR (250)
) AS
BEGIN
 SELECT
  COUNT (*) AS IsEdit
 FROM
  UserModulePermission ump
 INNER JOIN ModuledefPermission mdp ON ump.ModuledefPermissionId = mdp.ModuledefPermissionId
 AND ump.UserModuleID = @UserModuleID
 AND (
  (
   ump.RoleId IN (
    SELECT
     RoleId
    FROM
     dbo.aspnet_UsersInRoles
    INNER JOIN dbo.aspnet_Users ON dbo.aspnet_UsersInRoles.userid = dbo.aspnet_Users.UserId
    WHERE
     dbo.aspnet_users.UserName = @UserName
   )
  )
  OR ump.Username =@UserName
 )
 AND mdp.PermissionId = 2
 AND ump.PortalID =@PortalID
 END





GO
