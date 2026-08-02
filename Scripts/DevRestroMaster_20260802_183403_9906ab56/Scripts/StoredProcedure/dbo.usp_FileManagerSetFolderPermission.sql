SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerSetFolderPermission] 
(
@FolderID      INT, 
@PermissionKey VARCHAR(50), 
@UserID        INT, 
@RoleID        UNIQUEIDENTIFIER, 
@IsActive      BIT, 
@AddedBy       NVARCHAR(256)) 
AS 
  BEGIN 
      SET NOCOUNT ON; 
      DECLARE @PermissionID INT
      SELECT @PermissionID = PermissionID 
      FROM   Permission 
      WHERE  PermissionKey = @PermissionKey 

      INSERT INTO FolderPermission 
                  (FolderID, 
                   PermissionID, 
                   UserID, 
                   RoleID, 
                   IsActive, 
                   AddedOn, 
                   AddedBy) 
      VALUES      ( @FolderID, 
                    @PermissionID, 
                    @UserID, 
                    @RoleID, 
                    @IsActive, 
                    GETDATE(), 
                    @AddedBy ) 
  END;





GO
