SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerGetModulePermission] 
(
  @UserModuleID INT, 
  @UserName     NVARCHAR(256)
) 
AS 
  BEGIN      
      DECLARE @Count INT
      SELECT @Count = COUNT(*) 
      FROM   UserModules um 
             INNER JOIN UserModulePermission ump 
               ON ump.UserModuleID = um.UserModuleID 
      WHERE  um.UserModuleID = @UserModuleID 
             AND ump.Username = @UserName
     
      IF @Count <> 0 
        BEGIN 
            SELECT DISTINCT( ump.ModuleDefPermissionID ), 
                           p.PermissionKey 
            FROM   UserModules um 
                   INNER JOIN UserModulePermission ump 
                     ON ump.UserModuleID= um.UserModuleID 
                        AND ump.PortalID = um.PortalID 
                   INNER JOIN ModuleDefPermission mdp 
                     ON ump.ModuleDefPermissionID = mdp.ModuleDefPermissionID 
                   INNER JOIN Permission p 
                     ON mdp.PermissionID = p.PermissionID 
            WHERE  um.UserModuleID = @UserModuleID 
   AND ump.Username=@UserName
        END       
      ELSE 
        IF @Count = 0 
          BEGIN               
              DECLARE @RoleID UNIQUEIDENTIFIER
              SELECT @RoleID = aur.RoleId
              FROM   aspnet_users au 
                     INNER JOIN aspnet_usersinroles aur 
                       ON au.UserId = aur.UserId 
              WHERE  au.UserName = @UserName 
              DECLARE @RoleName NVARCHAR(200)
              SELECT @RoleName = loweredrolename 
              FROM   aspnet_roles 
              WHERE  RoleId = @RoleID
              IF @RoleName = 'super user' 
                BEGIN 
                    SELECT 'EDIT' AS PermissionKey 
                END 
              ELSE 
                BEGIN                           
                    SELECT DISTINCT( ump.ModuleDefPermissionID ), 
                                   p.PermissionKey 
                    FROM   UserModules um 
                           INNER JOIN UserModulePermission ump 
                             ON ump.UserModuleID = um.UserModuleID 
                                AND ump.PortalID = um.PortalID
                           INNER JOIN ModuleDefPermission mdp 
                             ON ump.ModuleDefPermissionID = 
                                mdp.ModuleDefPermissionID 
                           INNER JOIN Permission p 
                             ON mdp.PermissionID = p.PermissionID 
                    WHERE  um.UserModuleID = @UserModuleID 
                           AND ump.RoleID = @RoleID 
                END 
          END 
  END;





GO
