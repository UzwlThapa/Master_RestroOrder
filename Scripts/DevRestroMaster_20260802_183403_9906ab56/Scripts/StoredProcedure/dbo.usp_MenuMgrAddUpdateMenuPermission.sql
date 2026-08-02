SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrAddUpdateMenuPermission] 
@MenuID INT,
@PermissionID INT,
@RoleID UNIQUEIDENTIFIER,
@UserName NVARCHAR(256),
@AllowAccess BIT,
@PortalID INT
                                                  
AS
  BEGIN
      IF( (@UserName IS NOT NULL ) OR @UserName<>'' )
  BEGIN
   DELETE FROM
    [dbo].[MenuPermission] 
   WHERE  
     [PortalID] = @PortalID 
    AND [MenuID] = @MenuID 
    AND username=@username
   INSERT INTO [dbo].[MenuPermission]
           (
             MenuID,
             PermissionID,
             RoleID,
             Username,
             AllowAccess,
             PortalID,
             AddedOn
            )            
          VALUES      
           (
             @MenuID,
             @permissionid,
             NULL,
             @UserName,
             @AllowAccess,
             @PortalID,
             GETDATE()
           )
  END
 ELSE IF((@RoleID IS NOT NULL) OR @RoleID <> '' )
  BEGIN
   IF(NOT EXISTS(SELECT * FROM  [MenuPermission] WHERE PortalID=@PortalID AND MenuID=@MenuID AND PermissionID=@PermissionID AND RoleID=@RoleID))
    BEGIN
     DELETE FROM 
      [MenuPermission] 
     WHERE  
       PortalID=@PortalID 
      AND MenuID=@MenuID  
      AND RoleID=@RoleID
     INSERT INTO [dbo].[MenuPermission]
              (
               MenuID,
               PermissionID,
               RoleID,
               Username,
               AllowAccess,
               PortalID,
               AddedOn
              )
             VALUES
              (
               @MenuID,
               @PermissionID,
               CAST(@RoleID AS UNIQUEIDENTIFIER ),
               @RoleID,
               @AllowAccess,
               @PortalID,
               GETDATE()
              )
    END   
  END      
  END





GO
