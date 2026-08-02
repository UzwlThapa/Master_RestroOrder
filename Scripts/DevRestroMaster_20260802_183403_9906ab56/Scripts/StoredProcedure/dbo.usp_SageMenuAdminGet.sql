SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageMenuAdminGet]
 @ParentNodeID [int],
 @UserName [NVARCHAR](256),
 @PortalID [int],
 @CultureCode NVARCHAR(20)
WITH EXECUTE AS CALLER
AS
BEGIN 
 DECLARE @PortalSEOName NVARCHAR(200), @IsParentPortal BIT, @UseFriendlyUrls NVARCHAR(256), @PortalPrefix NVARCHAR(200)
 SELECT @PortalSEOName=LTRIM(RTRIM(SEOName)),@IsParentPortal=IsParent FROM dbo.Portal WHERE PortalID=@PortalID
 SET @PortalPrefix=''
 IF(NOT(@IsParentPortal=1))
 BEGIN
  SET @PortalPrefix='/portal/'+@PortalSEOName
 END
 SELECT DISTINCT [dbo].[Pages].PageID INTO #tmppage FROM [dbo].[Pages] 
 INNER JOIN [dbo].[PagePermission] ON [dbo].[PagePermission].PageID  = [dbo].[Pages].PageID
 WHERE IsVisible=1 AND [dbo].[Pages].IsActive=1 AND ([dbo].[Pages].IsDeleted=0 OR [dbo].[Pages].IsDeleted IS NULL) 
 AND [dbo].[PagePermission].[RoleID] IN ( SELECT [dbo].[aspnet_Roles].RoleId
    FROM [dbo].[aspnet_Roles]
    WHERE [dbo].[aspnet_Roles].RoleName IN ('Site Admin','Super User')
 )
 AND (([dbo].[Pages].PortalID=-1 AND @ParentNodeID=0) OR @ParentNodeID>0)  AND [dbo].[Pages].ParentID=@ParentNodeID 
 AND ([dbo].[Pages].IsDeleted=0 OR [dbo].[Pages].IsDeleted IS NULL)
 SELECT @UseFriendlyUrls= dbo.fn_GetSettingValueBySettingKey('SuperUser',1,'UseFriendlyUrls')
 IF UPPER(@UseFriendlyUrls)='TRUE'
 BEGIN
  SELECT [dbo].[Pages].PageID, 
  [dbo].[Pages].PageOrder, 
   ( CASE 
                 WHEN (SELECT COUNT(pageid) 
                       FROM   localpage 
                       WHERE  pageid = [dbo].[Pages].pageid 
                              AND culturecode = @Culturecode) > 0 THEN (SELECT 
                 localpagename 
                                                                        FROM 
                 localpage 
                                                                        WHERE 
                 pageid = [dbo].[Pages].pageid  
                 AND culturecode = @CultureCode) 
                 ELSE (SELECT pagename 
                       FROM   pages 
                       WHERE  pageid = [dbo].[Pages].pageid ) 
               END )                               AS PageName,
  [dbo].[Pages].IsVisible, 
  [dbo].[Pages].ParentID, 
  [dbo].[Pages].[Level], 
  [dbo].[Pages].IconFile, 
  [dbo].[Pages].DisableLink, 
  [dbo].[Pages].Title, 
  [dbo].[Pages].[Description], 
  [dbo].[Pages].KeyWords, 
  (CASE WHEN ([dbo].[Pages].Url IS NULL) OR (LEN(RTRIM(LTRIM([dbo].[Pages].Url)))<1) THEN @PortalPrefix+[dbo].[Pages].TabPath+'.aspx' 
   ELSE [dbo].[Pages].Url END) AS TabPath, 
  [dbo].[Pages].Url, 
  [dbo].[Pages].StartDate, 
  [dbo].[Pages].EndDate, 
  [dbo].[Pages].RefreshInterval, 
  [dbo].[Pages].PageHeadText, 
  [dbo].[Pages].IsSecure, 
  [dbo].[Pages].IsActive,
  [dbo].[fn_GetPageRolesNUsername]([dbo].[Pages].PageID) AS PageRoles
 FROM   [dbo].[Pages] 
 INNER JOIN #tmppage ON #tmppage.PageID = [dbo].[Pages].PageID
 ORDER BY [dbo].[Pages].PageOrder ASC
 END
 ELSE
 BEGIN
 SELECT [dbo].[Pages].PageID, 
  [dbo].[Pages].PageOrder, 
  ( CASE 
                 WHEN (SELECT COUNT(pageid) 
                       FROM   localpage 
                       WHERE  pageid = [dbo].[Pages].pageid 
                              AND culturecode = @Culturecode) > 0 THEN (SELECT 
                 localpagename 
                                                                        FROM 
                 localpage 
                                                                        WHERE 
                 pageid = [dbo].[Pages].pageid  
                 AND culturecode = @CultureCode) 
                 ELSE (SELECT pagename 
                       FROM   pages 
                       WHERE  pageid = [dbo].[Pages].pageid ) 
               END )                               AS PageName,
  [dbo].[Pages].IsVisible, 
  [dbo].[Pages].ParentID, 
  [dbo].[Pages].[Level], 
  [dbo].[Pages].IconFile, 
  [dbo].[Pages].DisableLink, 
  [dbo].[Pages].Title, 
  [dbo].[Pages].[Description], 
  [dbo].[Pages].KeyWords, 
  (CASE WHEN ([dbo].[Pages].Url IS NULL) OR (len(RTRIM(LTRIM([dbo].[Pages].Url)))<1) 
   THEN '/Default.aspx?ptlid='+convert(VARCHAR(18),@PortalID)+'&ptSEO='+ISNULL(@PortalSEOName,'')+'&pgnm='+ISNULL([dbo].[Pages].[SEOName],'') 
   ELSE [dbo].[Pages].Url END ) AS TabPath, 
  [dbo].[Pages].Url, 
  [dbo].[Pages].StartDate, 
  [dbo].[Pages].EndDate, 
  [dbo].[Pages].RefreshInterval, 
  [dbo].[Pages].PageHeadText, 
  [dbo].[Pages].IsSecure, 
  [dbo].[Pages].IsActive,
  [dbo].[fn_GetPageRolesNUsername]([dbo].[Pages].PageID) AS PageRoles
 FROM   [dbo].[Pages] 
 INNER JOIN #tmppage ON #tmppage.PageID = [dbo].[Pages].PageID
 ORDER BY [dbo].[Pages].PageOrder ASC
 END 
 DROP TABLE #tmpPage
END





GO
