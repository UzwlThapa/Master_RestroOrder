SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_PagePermissions]
AS
SELECT DISTINCT 
                      PP.PagePermissionID, PP.PageID, P.PermissionID, PP.RoleID, PP.AllowAccess, P.PermissionCode, MDP.ModuleDefID, P.PermissionKey, 
                      P.PermissionName, Pg.PortalID, PP.IsActive, PP.IsDeleted, PP.IsModified, PP.AddedOn, PP.UpdatedOn, PP.DeletedOn, PP.AddedBy, PP.UpdatedBy, 
                      PP.DeletedBy, R.RoleName, U.UserName
FROM         dbo.PagePermission AS PP INNER JOIN
                      dbo.Pages AS Pg ON PP.PageID = Pg.PageID AND PP.PortalID = Pg.PortalID LEFT OUTER JOIN
                      dbo.Permission AS P ON PP.PermissionID = P.PermissionID LEFT OUTER JOIN
                      dbo.ModuleDefPermission AS MDP ON P.PermissionID = MDP.PermissionID LEFT OUTER JOIN
                      dbo.aspnet_Roles AS R ON PP.RoleID = R.RoleId LEFT OUTER JOIN
                      dbo.aspnet_UsersInRoles AS UR ON R.RoleId = UR.RoleId LEFT OUTER JOIN
                      dbo.aspnet_Users AS U ON UR.UserId = U.UserId





GO
