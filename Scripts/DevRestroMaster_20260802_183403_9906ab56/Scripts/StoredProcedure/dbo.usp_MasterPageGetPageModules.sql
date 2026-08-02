SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec sp_rename 'usp_MasterPageGetPageModules', 'usp_MasterPageGetPageModules_backup'
--[usp_MasterPageGetPageModules] 1, 'footercontent', 1, 'Edge', 'en-US', 0, 'sfXHL123' 
--select * from portal
--[dbo].[usp_MasterPageGetPageModules] 1,'start',1,'raju', 'en-US',0, 'sfXHL123'
--[dbo].[usp_MasterPageGetPageModules] 1,'Menu',1,'Edge'
----[usp_MasterPageGetPageModules] 1, 'Dining', 1, 'Edge', 'en-US', 0, 'sfXHL123'
CREATE PROCEDURE [dbo].[usp_MasterPageGetPageModules] 
 @ControlType [int]
 ,@PageSEOName [nvarchar] (1000)
 ,@PortalID [int]
 ,@Username [nvarchar] (256)
 ,@CultureCode[NVARCHAR](100)
 ,@IsPreview bit
 ,@PreviewCode nvarchar(256)
 AS
BEGIN
 SET NOCOUNT ON;

 -----------------------------------------------------------
 --Declare All Variables Here
 -----------------------------------------------------------
 DECLARE @IsPageAvailable BIT
 DECLARE @IsPageAccessible BIT = 0
 DECLARE @PageID INT
 DECLARE @AllowPreview bit
 DECLARE @IsModuleEdit BIT
 
 SET @AllowPreview=0 
 SET @IsModuleEdit = 0 

 -----------------------------------------------------------
 --Get PageID From PageSEOName
 -----------------------------------------------------------
 SELECT @PageID = PageID
 FROM Pages
 WHERE SEOName = @PageSEOName  AND PortalID = @PortalID  and IsActive = 1 and Isdeleted = 0

 -----------------------------------------------------------
 --Check for page review
 -----------------------------------------------------------

 IF EXISTS( SELECT PageID FROM PagePreview WHERE PreviewCode = @PreviewCode and PageID =  @PageID) and (@IsPreview = 1)  
   SET @AllowPreview=1
   
   
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
   
 DECLARE @temprole TABLE
 (   roleID NVARCHAR(250), username NVARCHAR(50), UNIQUE NONCLUSTERED (roleid,username) )

 INSERT INTO @temprole
 SELECT [dbo].[aspnet_UsersInRoles].roleid  , [dbo].[aspnet_Users].username
     FROM [dbo].[aspnet_UsersInRoles]
     INNER JOIN [dbo].[aspnet_Users] ON [dbo].[aspnet_Users].userid = [dbo].[aspnet_UsersInRoles].userid
     WHERE [dbo].[aspnet_Users].username = @Username
     
 UNION ALL
     
 SELECT [RoleId],'anonymoususer'
 FROM dbo.aspnet_roles
 WHERE loweredrolename = 'anonymous user'


 -----------------------------------------------------------
 --Check If the User Has Access To the Page
 -----------------------------------------------------------
 IF EXISTS (  SELECT PageID  FROM Pages  WHERE SEOName = @PageSEOName   AND PortalID = @PortalID   )
 BEGIN
  SET @IsPageAvailable = 1
 END

 IF EXISTS (
   SELECT [dbo].[Pages].PageID
   FROM [dbo].[Pages]
   INNER JOIN [dbo].[PagePermission] ON [dbo].[PagePermission].pageid = [dbo].[Pages].pageid
   WHERE (
     [dbo].[PagePermission].[RoleID] IN (  SELECT RoleID FROM @temprole)      
     OR [dbo].[PagePermission].username = @Username
     )
    AND [dbo].[Pages].seoname = @PageSEOName
    AND (
     [dbo].[Pages].[IsDeleted] = 0
     OR [dbo].[Pages].[IsDeleted] IS NULL
     )
    AND (
     [dbo].[Pages].portalid = @PortalID
     OR [dbo].[Pages].portalid = - 1
     )
    AND (
     [dbo].[PagePermission].[IsDeleted] = 0
     OR [dbo].[PagePermission].[IsDeleted] IS NULL
     )
   )
 BEGIN
  SET @IsPageAccessible = 1
 END

 -----------------------------------------------------------
 --Create the PageDetails Table
 -----------------------------------------------------------
 DECLARE @Title NVARCHAR(250)
  ,@RefreshInterval NVARCHAR(250)
  ,@Description NVARCHAR(500)
  ,@KeyWords NVARCHAR(500)

 SELECT @Title = p.Title
  ,@RefreshInterval = CAST(p.RefreshInterval AS NVARCHAR)
  ,@Description = p.Description
  ,@KeyWords = p.KeyWords
 FROM pages p
 WHERE p.seoname = @PageSEOName
  AND p.portalid = @PortalID

 -----------------------------------------------------------
 --Get The List Of Page Modules By PageSEOName and Portal ID
 -----------------------------------------------------------
 SELECT DISTINCT  @IsPageAvailable AS IsPageAvailable
  ,@IsPageAccessible AS IsPageAccessible
  ,p.PageID
  ,um.usermoduleid
  ,pm.PaneName
  ,pm.moduleorder
  , um.IsHandheld
  ,um.SuffixClass
  ,um.ShowHeaderText
  ,um.headertext
  ,mc.ControlSrc
  ,mc.SupportsPartialRendering
  , 1 ControlsCount
  ,MC.PortalID 
  ,1 AS IsEdit
  ,@Title AS Title
  ,@RefreshInterval AS RefreshInterval
  ,@Description AS [Description]
  ,@KeyWords AS KeyWords
  ,um.usermoduletitle AS UserModuleTitle
 FROM dbo.Pages AS p 
 LEFT OUTER JOIN dbo.PageModules AS pm ON p.PageID = pm.PageID AND p.PortalID = pm.PortalID AND P.PageID=@PageID
 LEFT OUTER JOIN dbo.UserModules AS um ON (pm.UserModuleID = um.UserModuleID and um.PortalID=@PortalID) 
 LEFT OUTER JOIN dbo.ModuleControls AS mc ON mc.ModuleDefID = um.ModuleDefID AND p.IsDeleted <> 1 AND mc.ControlType = 1 
 LEFT OUTER JOIN dbo.UserModulePermission AS ump ON ump.UserModuleID = um.UserModuleID
 inner join @temprole tr on ump.RoleID = tr.roleID 
 union all 
 SELECT DISTINCT  @IsPageAvailable AS IsPageAvailable
  ,@IsPageAccessible AS IsPageAccessible
  ,p.PageID
  ,um.usermoduleid
  ,pm.PaneName
  ,pm.moduleorder
  , um.IsHandheld
  ,um.SuffixClass
  ,um.ShowHeaderText
  ,um.headertext
  ,mc.ControlSrc
  ,mc.SupportsPartialRendering
  , 1 ControlsCount
  ,MC.PortalID 
  ,1 AS IsEdit
  ,@Title AS Title
  ,@RefreshInterval AS RefreshInterval
  ,@Description AS [Description]
  ,@KeyWords AS KeyWords
  ,um.usermoduletitle AS UserModuleTitle
 FROM dbo.UserModules AS um 
 LEFT OUTER JOIN dbo.PageModules AS pm ON (pm.UserModuleID = um.UserModuleID and um.PortalID=1) 
 LEFT OUTER JOIN dbo.Pages AS p  ON p.PageID = pm.PageID AND p.PortalID = pm.PortalID
 LEFT OUTER JOIN dbo.ModuleControls AS mc ON mc.ModuleDefID = um.ModuleDefID AND p.IsDeleted <> 1 AND mc.ControlType = 1 
 LEFT OUTER JOIN dbo.UserModulePermission AS ump ON ump.UserModuleID = um.UserModuleID
 --inner join @temprole tr on ump.RoleID = tr.roleID 
 where  (
    @PageID IN (
    SELECT SplittedValue  FROM   UDFSplit(um.showinpages, ',')     
     WHERE (
       um.isdeleted = 0
       OR um.IsDeleted IS NULL
       )
     )
    )
	and p.PageID <> @PageID
 ORDER BY pm.ModuleOrder ASC
END





GO
