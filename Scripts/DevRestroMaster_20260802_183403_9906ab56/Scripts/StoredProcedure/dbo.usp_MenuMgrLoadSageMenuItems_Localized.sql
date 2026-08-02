SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrLoadSageMenuItems_Localized] (@UserModuleID INT, @PortalID INT, @UserName NVARCHAR(200), @Culture NVARCHAR(50))
AS
BEGIN
 DECLARE @temprole TABLE (roleid NVARCHAR(250), username NVARCHAR(Max))

 INSERT INTO @temprole
 SELECT [dbo].[aspnet_UsersInRoles].roleid, [dbo].[aspnet_Users].username
 FROM [dbo].[aspnet_UsersInRoles]
 INNER JOIN [dbo].[aspnet_Users] ON [dbo].[aspnet_Users].userid = [dbo].[aspnet_UsersInRoles].userid
 
 UNION ALL
 
 SELECT [RoleId], 'anonymous user' AS username
 FROM dbo.aspnet_roles
 WHERE loweredrolename = 'anonymous user'

 DECLARE @MenuID INT

 IF EXISTS (
    SELECT SettingValue
    FROM SageMenuSettingValue
    WHERE  SettingKey = 'MenuID'
     AND UserModuleID = @UserModuleID
    )
     BEGIN
      SELECT @MenuID = SettingValue
      FROM SageMenuSettingValue
      WHERE SettingKey = 'MenuID'
       AND UserModuleID = @UserModuleID
     END
    ELSE
     BEGIN
      SELECT @MenuID = MenuID
      FROM Menu
      WHERE IsDefault = 1
     END

 SELECT DISTINCT mi.MenuID, mi.PageID, ISNULL((
    SELECT lp.LocalPageName
    FROM LocalPage lp
    WHERE lp.PageID = mi.PageID
         AND lp.CultureCode = @Culture
    ),   p.PageName) AS PageName
    ,    PageName AS Title, 
    (SELECT COUNT(1)FROM MenuItem m WHERE m.ParentID = mi.MenuItemID)  AS ChildCount
    , p.IconFile AS ImageIcon
    , p.TabPath AS URL
    , ISNULL((SELECT lp.LocalPageCaption FROM LocalPage lp WHERE lp.PageID = mi.PageID AND lp.CultureCode = @Culture), mi.Caption) AS Caption
    , mi.HtmlContent, mi.ParentID, mi.MenuLevel as menulevel, mi.MenuOrder as menuOrder , mi.SubText, mi.IsVisible
    , mi.IsActive, mi.MenuItemID as MenuItemID, mi.LinkType, mi.LinkURL
 FROM MenuItem mi
   LEFT JOIN Pages p ON mi.PageID = p.PageID
   INNER JOIN [dbo].[PagePermission] ON [dbo].[PagePermission].pageid = p.pageid
   INNER JOIN @temprole mv ON (
     [dbo].[PagePermission].RoleID = mv.roleid
     AND [dbo].[PagePermission].UserName = mv.UserName
     )
    OR (
     [dbo].[PagePermission].RoleID = mv.roleid
     AND [dbo].[PagePermission].UserName = ''
     )
   WHERE (
     mv.username = @UserName
     OR [dbo].[PagePermission].username = @UserName
     )
    AND p.pageid = mi.PageID
    AND (
     p.[IsDeleted] = 0
     OR p.[IsDeleted] IS NULL
     )
    AND (
     p.portalid = @PortalID
     OR p.portalid = - 1
     )
    AND (
     [dbo].[PagePermission].[IsDeleted] = 0
     OR [dbo].[PagePermission].[IsDeleted] IS NULL
     )
    AND mi.MenuID = @MenuID
    AND mi.LinkType = 0
    AND mi.IsVisible = 1
    AND mi.PortalID = @PortalID

   UNION ALL

 SELECT DISTINCT mi.MenuID, mi.PageID, p.PageName, mi.Title, 
      (SELECT COUNT(1)
      FROM MenuItem m
      WHERE m.ParentID = mi.MenuItemID ) AS ChildCount
     , mi.ImageIcon, p.TabPath AS URL, mi.Caption, mi.HtmlContent, mi.ParentID, mi.MenuLevel as menulevel
     , mi.MenuOrder as menuOrder, mi.SubText, mi.IsVisible, mi.IsActive, mi.MenuItemID as MenuItemID , mi.LinkType, mi.LinkURL
     
 FROM   MenuItem mi
     LEFT JOIN Pages p ON mi.PageID = p.PageID
     LEFT JOIN PagePermission pp ON p.PageID = pp.PageID
 WHERE    mi.MenuID = @MenuID
     AND (
      mi.LinkType = 1
      OR mi.LinkType = 2
      )
     AND mi.IsVisible = 1
     AND mi.PortalID = @PortalID
  
 ORDER BY menuOrder ,MenuItemID desc 

 
END





GO
