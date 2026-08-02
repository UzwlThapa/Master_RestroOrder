SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrAddMenuPermission] 
 @MenuID INT,
 @PermissionID INT,
 @RoleID UNIQUEIDENTIFIER,
 @UserName NVARCHAR(256),
 @AllowAccess BIT,
 @PortalID INT
                                                  
AS
  BEGIN
 INSERT INTO MenuPermission
        ( 
         MenuID
         ,PermissionID
         ,RoleID
         ,Username
         ,AllowAccess
         ,PortalID
         ,AddedOn
         )
        VALUES      
        (
          @MenuID
         ,@permissionid
         ,CAST(@RoleID AS UNIQUEIDENTIFIER)
         ,@UserName
         ,@AllowAccess
         ,@PortalID
         ,GETDATE()
        )
  END





GO
