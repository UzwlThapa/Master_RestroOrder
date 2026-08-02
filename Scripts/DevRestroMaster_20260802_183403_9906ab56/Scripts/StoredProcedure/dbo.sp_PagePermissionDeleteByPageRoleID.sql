SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PagePermissionDeleteByPageRoleID]
 @RoleID nvarchar(800),
 @PageID int, 
 @PortalID int,
 @IsAdmin bit
AS
BEGIN
 IF @IsAdmin = 0
 BEGIN
  DELETE [dbo].[PagePermission]
  WHERE [PortalID] = @PortalID AND
   [PageID] = @PageID AND 
   [RoleID]=@RoleID
 END 
 ELSE
 BEGIN
  DELETE [dbo].[PagePermission]
  WHERE [PageID] = @PageID AND 
   [RoleID]=@RoleID
 END
END




GO
