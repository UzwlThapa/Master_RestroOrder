SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetPageSettingByPageSEOName]
 @ControlType INT,
 @PageSEOName NVARCHAR(1000),
 @PortalID INT,
 @UserName NVARCHAR(256)
WITH EXECUTE AS CALLER
AS
BEGIN
DECLARE @IsPageAvailable BIT,@IsPageAccessible BIT,@PageID INT
SELECT @PageID=PageID FROM Pages 
WHERE ([dbo].[Pages].PortalID=@PortalID OR [dbo].[Pages].PortalID=-1) 
AND  [dbo].[Pages].SEOName=@PageSEOName
AND ([dbo].[Pages].[IsDeleted] = 0 OR [dbo].[Pages].[IsDeleted] IS NULL)
IF EXISTS
(SELECT PageID FROM Pages where ([dbo].[Pages].PortalID=@PortalID OR [dbo].[Pages].PortalID=-1) 
AND  [dbo].[Pages].SEOName=@PageSEOName 
AND ([dbo].[Pages].[IsDeleted] = 0 OR [dbo].[Pages].[IsDeleted] IS NULL))
BEGIN
SET @IsPageAvailable=1
END
IF EXISTS(SELECT * 
FROM   Pages p 
       INNER JOIN PagePermission pm 
         ON p.PageID = pm.PageID 
WHERE (p.PortalID=@PortalID OR p.PortalID=-1) AND p.SEOName=@PageSEOName 
AND (p.[IsDeleted] = 0 OR p.[IsDeleted] IS NULL)

AND pm.RoleID IN (SELECT RoleID 
                         FROM   dbo.aspnet_usersinroles 
                                INNER JOIN dbo.aspnet_users 
                                  ON dbo.aspnet_usersinroles.UserId = 
                                     dbo.aspnet_users.UserId 
                         WHERE  dbo.aspnet_users.UserName = @UserName) 
       AND pm.PermissionID = 1 )
BEGIN
SET @IsPageAccessible=1
END
SELECT @IsPageAvailable AS IsPageAvailable,@IsPageAccessible AS IsPageAccessible

SELECT * 
FROM   Pages p
WHERE (p.PortalID=@PortalID OR p.PortalID=-1) AND p.SEOName=@PageSEOName 
AND (p.[IsDeleted] = 0 OR p.[IsDeleted] IS NULL)

SELECT DISTINCT v.PageID,v.usermoduleid,v.panename, 
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
     (select dbo.fn_EditPermissionExists(@UserName,v.usermoduleid)) AS IsEdit       
FROM   vw_PageUserModules v 
WHERE  v.seoname = @PageSEOName
       AND v.portalid = @PortalID
AND v.RoleID IN (SELECT roleid 
                         FROM   dbo.aspnet_usersinroles 
                                INNER JOIN dbo.aspnet_users 
                                  ON dbo.aspnet_usersinroles.userid = 
                                     dbo.aspnet_users.userid 
                         WHERE  dbo.aspnet_users.username = @UserName) 
AND v.ControlType=1
AND (v.IsDeleted=0 OR v.IsDeleted IS NULL)
AND v.IsActive=1
UNION
SELECT DISTINCT v.PageID,v.usermoduleid,v.panename, 
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
     (SELECT dbo.fn_EditPermissionExists(@UserName,v.usermoduleid)) AS IsEdit       
FROM   vw_PageUserModules v 
WHERE   v.portalid = @PortalID 
  AND v.RoleID IN (SELECT roleid 
                         FROM   dbo.aspnet_usersinroles 
                                INNER JOIN dbo.aspnet_users 
                                  ON dbo.aspnet_usersinroles.userid = 
                                     dbo.aspnet_users.userid 
                         WHERE  dbo.aspnet_users.username = @UserName) 
AND v.ControlType=1
AND (v.IsDeleted=0 OR v.IsDeleted IS NULL)
AND v.IsActive=1
AND v.allpages = 1
OR @PageID IN (SELECT RTRIM(LTRIM(items)) 
               FROM   Split(v.showinpages, ',') 
               WHERE (v.isdeleted=0 OR v.isdeleted IS NULL))
               ORDER BY v.ModuleOrder
END





GO
