SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerGetFolderPermissionByUserID]
(
@FolderID INT,
@UserID INT,
@UserModuleID INT,
@UserName NVARCHAR(256)
)
AS
BEGIN
DECLARE @Count INT
SELECT @Count = COUNT(p.PermissionKey) 
FROM   FolderPermission fp 
       INNER JOIN Permission p 
         ON fp.PermissionID = p.PermissionID
WHERE  fp.FolderID = @FolderID 
       AND fp.UserID = @UserID 
 
IF @Count <> 0 
  BEGIN     
      SELECT p.PermissionKey 
      FROM   FolderPermission fp 
             INNER JOIN Permission p 
               ON fp.PermissionID = p.PermissionID 
      WHERE  fp.FolderID = @FolderID 
             AND fp.UserID = @UserID 
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
 SELECT @RoleName=LoweredRoleName FROM aspnet_Roles WHERE RoleID=@RoleID
 IF @RoleName='superuser' OR @RoleName='siteadmin'
     BEGIN
      SELECT 'EDIT' AS PermissionKey
     END
 ELSE
    BEGIN             
     DECLARE @Count2 INT
            SELECT @Count2=COUNT(p.PermissionKey) 
            FROM   FolderPermission fp 
            INNER JOIN Permission p 
            ON fp.PermissionID = p.PermissionID
            WHERE  fp.FolderID = @FolderID 
            AND fp.RoleID= @RoleID   
     IF @Count2<>0
       BEGIN
  SELECT p.PermissionKey
  FROM   FolderPermission fp 
                INNER JOIN Permission p 
                ON fp.PermissionID = p.PermissionID
  WHERE  fp.FolderID = @FolderID 
                AND fp.RoleID = @RoleID 
       END
     ELSE IF @Count2=0
       BEGIN
  EXEC [usp_FileManagerGetModulePermission] @UserModuleID,@UserName
       END
   END
    END 
END;





GO
