SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_MasterPageGetPageModules] 1,'Admin',1,'superuser'
CREATE PROCEDURE [dbo].[usp_MasterPageGetPageModulesAdmin]
 @ControlType [int],
 @PageSEOName [nvarchar](1000),
 @PortalID [int],
 @UserName [nvarchar](256),
@IsPreview bit,
@PreviewCode nvarchar(256)
WITH EXECUTE AS CALLER
AS
BEGIN
SET NOCOUNT ON;
-----------------------------------------------------------
--Declare All Variables Here
-----------------------------------------------------------
DECLARE @IsPageAvailable bit,@IsPageAccessible bit,@PageID int
DECLARE @AllowPreview BIT
  
SET @AllowPreview  = 0 
-----------------------------------------------------------
--Get PageID From PageSEOName
-----------------------------------------------------------
SELECT @PageID=PageID FROM Pages WHERE SEOName=@PageSEOName AND (PortalID=@PortalID OR PortalID=-1)


--------------------------------------------------------------------------------------
IF EXISTS(SELECT PageID FROM PagePreview WHERE PreviewCode = @PreviewCode and PageID =  @PageID) and (@IsPreview = 1)  
 SET @AllowPreview = 1
 
 -----------------------------------------------------------
--Check If the User Has Access To the Page
-----------------------------------------------------------

--SET @IsPageAvailable = 0

 IF(@IsPreview=1)
 BEGIN
   IF(@AllowPreview=1)
     BEGIN
      IF EXISTS(SELECT PageID FROM Pages WHERE SEOName=@PageSEOName AND PortalID=@PortalID)     
       SET @IsPageAvailable=1
     END
    ELSE
     BEGIN
      IF EXISTS(SELECT PageID FROM Pages WHERE SEOName=@PageSEOName AND PortalID=@PortalID and IsVisible=1)
        SET @IsPageAvailable = 1
      ELSE
       SET @IsPageAvailable=0
      END
    END
 ELSE
  BEGIN
   IF EXISTS(SELECT PageID FROM Pages WHERE SEOName=@PageSEOName AND PortalID=@PortalID and IsVisible=1)
    SET @IsPageAvailable=1
   ELSE
    SET @IsPageAvailable=0   
  END
-----------------------------------------------------------
--Check If the User Has Access To the Page
-----------------------------------------------------------
IF EXISTS(SELECT [dbo].[Pages].* 
FROM   [dbo].[Pages] 
       INNER JOIN [dbo].[PagePermission] 
         ON [dbo].[PagePermission].pageid = [dbo].[Pages].pageid 
WHERE  ( [dbo].[PagePermission].[RoleID] IN (SELECT 
         [dbo].[aspnet_UsersInRoles].roleid 
                                             FROM   [dbo].[aspnet_UsersInRoles] 
         INNER JOIN [dbo].[aspnet_Users] 
           ON 
                  [dbo].[aspnet_Users].userid = 
                  [dbo].[aspnet_UsersInRoles].userid 
                                             WHERE 
                  [dbo].[aspnet_Users].username = @UserName 
                                             UNION ALL 
                                             SELECT [RoleId] 
                                             FROM   dbo.aspnet_roles 
                                             WHERE 
         loweredrolename = 'anonymous user') 
          OR [dbo].[PagePermission].username = @UserName ) 
       AND [dbo].[Pages].seoname = @PageSEOName 
       AND ( [dbo].[Pages].[IsDeleted] = 0 
              OR [dbo].[Pages].[IsDeleted] IS NULL ) 
       AND ( [dbo].[Pages].portalid = @PortalID 
              OR [dbo].[Pages].portalid = -1 ) 
       AND ( [dbo].[PagePermission].[IsDeleted] = 0 
              OR [dbo].[PagePermission].[IsDeleted] IS NULL ) )
BEGIN
SET @IsPageAccessible=1
END
-----------------------------------------------------------
--Create the PageDetails Table
-----------------------------------------------------------
DECLARE @Title nvarchar(250),@RefreshInterval nvarchar(250),@Description nvarchar(500),@KeyWords nvarchar(500)
SELECT @Title=p.Title,@RefreshInterval=CAST(p.RefreshInterval AS nvarchar),@Description=p.Description,@KeyWords=p.KeyWords 
FROM   pages p
WHERE  p.seoname = @PageSEOName
       AND (p.portalid = @PortalID  OR p.PortalID=-1)

-----------------------------------------------------------
--Get The List Of Page Modules By PageSEOName and Portal ID
-----------------------------------------------------------
SELECT DISTINCT @IsPageAvailable AS IsPageAvailable,@IsPageAccessible AS IsPageAccessible,v.PageID,v.usermoduleid,v.panename, 
       v.moduleorder, 
       v.ishandheld, 
       v.suffixclass, 
       v.showheadertext, 
       v.headertext ,
    v.ControlSrc,
    v.SupportsPartialRendering,
    --RoleID,
    v.ControlsCount,
v.PortalID,
    (select
    COUNT(*) as IsEdit 
 FROM   usermodulepermission ump 
       INNER JOIN moduledefpermission mdp 
         ON ump.moduledefpermissionid = mdp.moduledefpermissionid 
            AND ump.usermoduleid = v.UserModuleID
            AND ((ump.roleid IN (SELECT roleid 
                               FROM   dbo.aspnet_usersinroles 
                                      INNER JOIN dbo.aspnet_users 
                                        ON dbo.aspnet_usersinroles.userid = 
                                           dbo.aspnet_users.userid 
                               WHERE  dbo.aspnet_users.username = @UserName)) OR ump.username=@UserName)
            AND mdp.permissionid = 2  and ump.PortalID=@PortalID ) AS IsEdit,
  @Title AS Title,
  @RefreshInterval AS RefreshInterval,
  @Description AS [Description],
  @KeyWords AS KeyWords,
  v.ModuleDefID     AS ModuleDefID  
 FROM   vw_PageUserModules v 
 WHERE  ((v.[RoleID] IN (SELECT 
         [dbo].[aspnet_UsersInRoles].roleid 
                                             FROM   [dbo].[aspnet_UsersInRoles] 
         INNER JOIN [dbo].[aspnet_Users] 
           ON 
                  [dbo].[aspnet_Users].userid = 
                  [dbo].[aspnet_UsersInRoles].userid 
                                             WHERE 
                  [dbo].[aspnet_Users].username = @UserName 
                                             UNION ALL 
                                             SELECT [RoleId] 
                                             FROM   dbo.aspnet_roles 
                                             WHERE 
         loweredrolename = 'anonymous user') 
          OR v.username = @UserName)) 
      
AND  ((v.PageID = @PageID) OR(v.AllPages=1)
 or( @PageID IN (SELECT Rtrim(Ltrim(items)) 
            FROM   Split(v.showinpages, ',') WHERE (v.isdeleted=0 or v.IsDeleted is null )))
               )
       AND (v.portalid = 1 or v.portalid=-1)

and v.ControlType=1
and (v.IsDeleted=0 or v.IsDeleted is null)
and v.IsActive=1 
order by v.moduleorder asc
END





GO
