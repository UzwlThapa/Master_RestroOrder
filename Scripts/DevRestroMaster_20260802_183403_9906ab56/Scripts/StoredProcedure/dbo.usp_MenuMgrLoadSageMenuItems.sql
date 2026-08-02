SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrLoadSageMenuItems]
(
@UserModuleID INT,
@PortalID INT,
@UserName NVARCHAR(200)
)

AS
BEGIN

      ----------------------------------------------------------
        -- Declare and select Role and Username 
      -----------------------------------------------------------
   declare @temprole table
   (
   roleid nvarchar(250),
   username nvarchar(50)
   )
   INSERT INTO @temprole

   SELECT  [dbo].[aspnet_UsersInRoles].roleid, [dbo].[aspnet_Users].username
   FROM         [dbo].[aspnet_UsersInRoles] INNER JOIN
          [dbo].[aspnet_Users] ON [dbo].[aspnet_Users].userid = [dbo].[aspnet_UsersInRoles].userid
   UNION ALL
   SELECT     [RoleId], 'anonymous user' AS username
   FROM         dbo.aspnet_roles
   WHERE     loweredrolename = 'anonymous user'

 DECLARE @MenuID INT
  IF EXISTS
    (
     SELECT 
      SettingValue 
     FROM 
      SageMenuSettingValue 
     WHERE 
       SettingKey='MenuID' 
      AND UserModuleID=@UserModuleID
    )
   BEGIN
    SELECT 
     @MenuID=SettingValue 
    FROM 
     SageMenuSettingValue 
    WHERE 
      SettingKey='MenuID' 
     AND UserModuleID=@UserModuleID
   END
  ELSE
   BEGIN
    SELECT 
     @MenuID=MenuID 
    FROM 
     Menu 
    WHERE IsDefault=1
   END

 DECLARE  @Temp TABLE
  (
   MenuID INT,
   PageID INT,
   PageName NVARCHAR(250),
   Title NVARCHAR(250),
   ChildCount INT,
   ImageIcon NVARCHAR(250),
   URL NVARCHAR(250),
   Caption NVARCHAR(250),
   HtmlContent NVARCHAR(2000),
   ParentID INT,
   MenuLevel INT,
   MenuOrder INT,
   SubText NVARCHAR(250),
   IsVisible BIT,
   IsActive BIT,
   MenuItemID INT,
   LinkType INT,
   LinkURL NVARCHAR(256)
  )
 
 INSERT INTO @Temp
 SELECT 
  DISTINCT mi.MenuID,
     mi.PageID,
     p.PageName,
     mi.Title,
     (
      SELECT 
       COUNT(*) 
      FROM 
       MenuItem m 
      WHERE 
       m.ParentID=mi.MenuItemID
     ) AS ChildCount,
     p.IconFile AS ImageIcon,
     p.TabPath AS URL,
     mi.Caption,
     mi.HtmlContent,
     mi.ParentID,
     mi.MenuLevel,
     mi.MenuOrder,
     mi.SubText,
     mi.IsVisible,
     mi.IsActive,
     mi.MenuItemID,
     mi.LinkType,
     mi.LinkURL
 FROM 
  MenuItem mi 
 LEFT JOIN 
  Pages p 
 ON 
  mi.PageID=p.PageID  
 INNER JOIN 
  PageMenu pm 
 ON 
  pm.PageID=p.PageID  
 INNER JOIN 
  [dbo].[PagePermission] 
 ON 
  [dbo].[PagePermission].pageid = p.pageid
  
  INNER JOIN @temprole mv on [dbo].[PagePermission].RoleID = mv.roleid
    WHERE  
 (mv.username = @UserName or[dbo].[PagePermission].username = @UserName) 
 
  AND 
   p.pageid = mi.PageID 
  AND 
   (  p.[IsDeleted] = 0 
    OR 
     p.[IsDeleted] IS NULL 
   ) 
  AND 
   ( 
     p.portalid = @PortalID 
    OR p.portalid = -1 
   ) 
  AND 
   ( 
     [dbo].[PagePermission].[IsDeleted] = 0 
    OR [dbo].[PagePermission].[IsDeleted] IS NULL 
   )
  AND 
   mi.MenuID=@MenuID
  AND 
   mi.LinkType=0 
  AND 
   mi.IsVisible=1 
  AND 
   mi.PortalID=@PortalID
  ORDER BY 
   MenuLevel,MenuOrder
  
 
 INSERT INTO @Temp
  SELECT  
   DISTINCT mi.MenuID,
      mi.PageID,
      p.PageName,
      mi.Title,
      (
       SELECT 
        COUNT(*) 
       FROM 
        MenuItem m 
       WHERE 
        m.ParentID=mi.MenuItemID
      ) AS ChildCount,
      mi.ImageIcon,
      p.TabPath AS URL,
      mi.Caption,
      mi.HtmlContent,
      mi.ParentID,
      mi.MenuLevel,
      mi.MenuOrder,
      mi.SubText,
      mi.IsVisible,
      mi.IsActive,
      mi.MenuItemID,
      mi.LinkType,
      mi.LinkURL
  FROM 
   MenuItem mi 
  LEFT JOIN 
   Pages p 
  ON 
   mi.PageID=p.PageID
  LEFT JOIN
   PagePermission pp 
  ON 
   p.PageID=pp.PageID      
  WHERE 
   mi.MenuID=@MenuID 
  AND 
   (
     mi.LinkType=1 
    OR mi.LinkType=2
   )
  AND 
   mi.IsVisible=1 
  AND 
   mi.PortalID=@PortalID
  ORDER BY 
   MenuLevel,MenuOrder
  
 SELECT 
  * 
 FROM 
  @Temp 
 ORDER BY 
  MenuOrder
 
END





GO
