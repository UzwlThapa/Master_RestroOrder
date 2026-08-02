SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  Milson Munakami
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_PagePermissionByRolePermissionInsert]
(
 @PageID int,
 @RoleID nvarchar(800),
 @PermissionID int,
 @AllowAccess bit,
 @UserName nvarchar(256),
 @IsActive bit,
 @AddedOn datetime,
 @PortalID int,
 @AddedBy nvarchar(256)
)
AS
DECLARE @count int
DECLARE @str nvarchar(800)
DECLARE @spot SMALLINT
WHILE @RoleID <> ''

BEGIN
 SET @spot = CHARINDEX(',', @RoleID)
 IF @spot>0
 BEGIN
  SET @str = CAST(LEFT(@RoleID, @spot-1) AS uniqueidentifier)
  SET @RoleID = RIGHT(@RoleID, LEN(@RoleID)-@spot)
 END
 ELSE
 BEGIN
  SET @str = CAST(@RoleID AS uniqueidentifier)
  SET @RoleID = ''
 END
-- SELECT @count=count(1) FROM dbo.PagePermission
-- WHERE RoleID=@str AND PageID=@PageID
--IF @count =0
BEGIN
INSERT INTO dbo.PagePermission
 (PageID,
 PermissionID,
 AllowAccess,
 RoleID,
 Username,
 IsActive,
 AddedOn,
 PortalID,
 AddedBy
)
VALUES
 (@PageID,
 @PermissionID,
 @AllowAccess,
 @str,
 @UserName,
 @IsActive,
 @AddedOn,
 @PortalID,
 @AddedBy
)
END
END
RETURN





GO
