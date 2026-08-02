SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- CREATED BY: Dinesh Hona
-- CREATED DATE: 2010-03-24
-- MODIFIED BY: Dinesh Hona 
-- MODIFIED DATE: 2010-07-18
CREATE PROCEDURE [dbo].[sp_PageGetByParentID]
 @ParentID int,
 @IsActive [bit]=null,
 @IsVisible [bit]=null,
 @IsRequiredPage bit=null,
 @UserName nvarchar(256),
 @PortalID int
AS
BEGIN
SELECT DISTINCT [dbo].[Pages].* 
FROM   [dbo].[Pages] 
    INNER JOIN  [dbo].[PagePermission]  ON [dbo].[PagePermission].PageID = [dbo].[Pages].PageID
WHERE ([dbo].[PagePermission].[RoleID] IN (SELECT [dbo].[aspnet_UsersInRoles].RoleId
           FROM [dbo].[aspnet_UsersInRoles]
           INNER JOIN [dbo].[aspnet_Users] ON [dbo].[aspnet_Users].UserId = [dbo].[aspnet_UsersInRoles].UserId
           WHERE [dbo].[aspnet_Users].UserName = @UserName)
  OR [dbo].[PagePermission].Username=@UserName ) AND [dbo].[Pages].ParentID=@ParentID
 AND ([dbo].[Pages].IsDeleted=0 OR [dbo].[Pages].IsDeleted IS NULL)
 AND ([dbo].[Pages].IsActive=@IsActive OR @IsActive IS NULL)
 AND ([dbo].[Pages].IsVisible=@IsVisible OR @IsVisible IS NULL) AND ([dbo].[Pages].IsRequiredPage=@IsRequiredPage OR @IsRequiredPage IS NULL)
 AND [dbo].[Pages].PortalID=@PortalID
ORDER BY [dbo].[Pages].PageOrder Asc
END



SET ANSI_NULLS ON





GO
