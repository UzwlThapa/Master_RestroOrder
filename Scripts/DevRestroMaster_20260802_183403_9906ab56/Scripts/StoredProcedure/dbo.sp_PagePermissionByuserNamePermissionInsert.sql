SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  Milson Munakami
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_PagePermissionByuserNamePermissionInsert]
(
 @PageID int,
 @RoleID uniqueidentifier,
 @PermissionID int,
 @AllowAccess bit,
 @UserName nvarchar(800),
 @IsActive bit,
 @AddedOn datetime,
 @PortalID int,
 @AddedBy nvarchar(256)
)
AS
DECLARE @count int
DECLARE @str nvarchar(800)
DECLARE @spot SMALLINT
WHILE @UserName <> ''

BEGIN
 SET @spot = CHARINDEX(',', @UserName)
 IF @spot>0
 BEGIN
  SET @str = LEFT(@UserName, @spot-1)
  SET @UserName = RIGHT(@UserName, LEN(@UserName)-@spot)
 END
 ELSE
 BEGIN
  SET @str = @UserName 
  SET @UserName = ''
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
 @RoleID,
 @str,
 @IsActive,
 @AddedOn,
 @PortalID,
 @AddedBy
)
END
END
RETURN





GO
