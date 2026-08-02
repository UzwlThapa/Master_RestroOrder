SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerGetUsersWithPermissions]
(
@FolderID INT
)
AS
BEGIN
SELECT DISTINCT fp.UserID,u.UserName FROM FolderPermission fp 
INNER JOIN Users u 
ON fp.UserID=u.UserID WHERE fp.FolderID=@FolderID
END;





GO
