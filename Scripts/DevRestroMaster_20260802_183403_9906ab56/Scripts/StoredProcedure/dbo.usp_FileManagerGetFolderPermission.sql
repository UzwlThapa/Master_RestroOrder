SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerGetFolderPermission]
(
@FolderID INT
)
AS
BEGIN
SELECT fp.FolderPermissionID,
       fp.FolderID,
       fp.PermissionID,
       (SELECT Username FROM Users WHERE UserID=fp.UserID) AS UserName,
  fp.UserID,
       fp.RoleID,
    p.PermissionKey,
       fp.IsActive,
       fp.IsDeleted,
       fp.IsModified,
       fp.AddedOn,
       fp.UpdatedOn,
       fp.DeletedOn,
       fp.AddedBy,
       fp.UpdatedBy,
       fp.DeletedBy
  FROM [dbo].[FolderPermission] fp
  INNER JOIN Permission p
   ON fp.PermissionID = p.PermissionID
 WHERE FolderID=@FolderID
END;





GO
