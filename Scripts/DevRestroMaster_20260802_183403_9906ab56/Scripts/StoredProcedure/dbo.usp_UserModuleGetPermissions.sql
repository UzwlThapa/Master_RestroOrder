SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UserModuleGetPermissions]
( @UserModuleID INT,
 @PortalID INT) AS
BEGIN
 SELECT
  CAST (ump.RoleID AS NVARCHAR(200)) AS RoleID,
  ump.Username,
  ump.AllowAccess,
  mdp.PermissionID
 FROM
  dbo.UserModulePermission ump
 INNER JOIN ModuleDefPermission mdp ON ump.ModuleDefPermissionID = mdp.ModuleDefPermissionID
 WHERE
  ump.UserModuleID =@UserModuleID
 AND ump.PortalID =@PortalID
 END





GO
