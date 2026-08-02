SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED DATE: 2010-03-12
CREATE PROCEDURE [dbo].[sp_GetPageSetting]
 @ControlType [INT],
 @PageID [INT],
 @PortalID [INT],
 @UserName [NVARCHAR](256)
WITH EXECUTE AS CALLER
AS
BEGIN

CREATE TABLE #tmpTable (
       [PageID] [int]  NOT NULL,
       [PageOrder] [int] NULL,
       [PageName] [nvarchar](100)  NULL,
       [IsVisible] [bit] NULL DEFAULT ((1)),
       [ParentID] [int] NULL,
       [Level] [int] NULL,
       [IconFile] [nvarchar](100) NULL,
       [DisableLink] [bit] NULL,
       [Title] [nvarchar](200) NULL,
       [Description] [nvarchar](500) NULL,
       [KeyWords] [nvarchar](500) NULL,
       [Url] [nvarchar](255) NULL,
       [TabPath] [nvarchar](255) NULL,
       [StartDate] [datetime] NULL,
       [EndDate] [datetime] NULL,
       [RefreshInterval] [decimal](16, 2) NULL,
       [PageHeadText] [nvarchar](500) NULL,
       [IsSecure] [bit] NOT NULL,
       [IsActive] [bit] NULL,
       [IsDeleted] [bit] NULL,
       [IsModified] [bit] NULL,
       [AddedOn] [datetime] NULL ,
       [UpdatedOn] [datetime] NULL ,
       [DeletedOn] [datetime] NULL,
       [PortalID] [int] NULL,
       [AddedBy] [nvarchar](256) NULL,
       [UpdatedBy] [nvarchar](256) NULL,
       [DeletedBy] [nvarchar](256) NULL,
       [SEOName] [nvarchar](100) NULL,
       [IsShowInFooter] BIT NULL,
       [IsRequiredPage] BIT NULL
      )

-------------------------Select Page Setting----------------------------------------
INSERT INTO #tmpTable
SELECT DISTINCT [dbo].[Pages].* 
FROM   [dbo].[Pages] 
    INNER JOIN  [dbo].[PagePermission]  ON [dbo].[PagePermission].PageID = [dbo].[Pages].PageID
WHERE ([dbo].[PagePermission].[RoleID] IN (SELECT [dbo].[aspnet_UsersInRoles].RoleId
           FROM [dbo].[aspnet_UsersInRoles]
           INNER JOIN [dbo].[aspnet_Users] ON [dbo].[aspnet_Users].UserId = [dbo].[aspnet_UsersInRoles].UserId
           WHERE [dbo].[aspnet_Users].UserName = @UserName)
  OR [dbo].[PagePermission].Username=@UserName ) AND [dbo].[Pages].PageID=@PageID

DECLARE @IconFile [nvarchar](100),
 @Title [nvarchar](200),
 @Description [nvarchar](500),
 @KeyWords [nvarchar](500),
 @PageHeadText [nvarchar](500),
 @IsSecure [bit],
 @RefreshInterval [decimal](16, 2)

SELECT @IconFile=CONVERT(NVARCHAR(100),ISNULL(Pages.IconFile,[dbo].[fn_GetSettingValueBySettingKey]('SiteAdmin',@PortalID,'IconFile'))),
@Title=CONVERT(NVARCHAR(200),ISNULL(Pages.Title,[dbo].[fn_GetSettingValueBySettingKey]('SiteAdmin',@PortalID,'PageTitle'))),
@Description=CONVERT(NVARCHAR(500),ISNULL(Pages.Description,[dbo].[fn_GetSettingValueBySettingKey]('SiteAdmin',@PortalID,'MetaDescription'))),
@KeyWords=CONVERT(NVARCHAR(500),ISNULL(Pages.KeyWords,[dbo].[fn_GetSettingValueBySettingKey]('SiteAdmin',@PortalID,'MetaKeywords'))),
@PageHeadText=CONVERT(NVARCHAR(500),ISNULL(Pages.PageHeadText,[dbo].[fn_GetSettingValueBySettingKey]('SiteAdmin',@PortalID,'PageHeadText'))),
@IsSecure=CONVERT(BIT,ISNULL(Pages.IsSecure,[dbo].[fn_GetSettingValueBySettingKey]('SiteAdmin',1,'IsSecure'))),
@RefreshInterval=CONVERT(DECIMAL(16,2),ISNULL(Pages.RefreshInterval,[dbo].[fn_GetSettingValueBySettingKey]('SiteAdmin',@PortalID,'MetaRefresh'))) 
FROM #tmpTable Pages

SELECT PageID, PageOrder, PageName, IsVisible, ParentID, [Level], 
  @IconFile AS [IconFile], 
  DisableLink, 
  @Title AS [Title], 
  @Description AS [Description], 
  @KeyWords AS [KeyWords], 
  Url, TabPath, StartDate, EndDate, 
  @RefreshInterval AS [RefreshInterval], 
  @PageHeadText AS [PageHeadText], 
  @IsSecure AS [IsSecure], 
  IsActive, IsDeleted, IsModified, AddedOn, UpdatedOn, DeletedOn, PortalID, AddedBy, UpdatedBy, DeletedBy,
  SEOName
FROM #tmpTable


---------------------- Select Page Modules-------------------------------
SELECT DISTINCT [dbo].[PageModules].*
FROM  [dbo].[UserModules]
INNER JOIN [dbo].[UserModulePermission] ON [dbo].[UserModulePermission].UserModuleID = [dbo].[UserModules].UserModuleID 
INNER JOIN [dbo].[PageModules] ON [dbo].[UserModules].UserModuleID = [dbo].[PageModules].UserModuleID 
WHERE [dbo].[PageModules].PageID = @PageID AND ([dbo].[UserModulePermission].RoleID IN
                  (SELECT [dbo].[aspnet_UsersInRoles].RoleId
           FROM [dbo].[aspnet_UsersInRoles]
           INNER JOIN [dbo].[aspnet_Users] ON [dbo].[aspnet_Users].UserId = [dbo].[aspnet_UsersInRoles].UserId
           WHERE [dbo].[aspnet_Users].UserName = @UserName)
  OR [dbo].[UserModulePermission].Username=@UserName)
ORDER BY [dbo].[PageModules].ModuleOrder ASC

-----------------------------Select Page Module Controls------------------------
SELECT DISTINCT [dbo].[ModuleControls].*
FROM  [dbo].[UserModulePermission]
INNER JOIN [dbo].[UserModules] ON [dbo].[UserModulePermission].UserModuleID = [dbo].[UserModules].UserModuleID 
INNER JOIN [dbo].[ModuleControls] ON [dbo].[UserModules].ModuleDefID = [dbo].[ModuleControls].ModuleDefID 
INNER JOIN [dbo].[PageModules] ON [dbo].[UserModules].UserModuleID = [dbo].[PageModules].UserModuleID 
WHERE [dbo].[PageModules].PageID = @PageID AND [dbo].[ModuleControls].ControlType=@ControlType
ORDER BY [dbo].[ModuleControls].DisplayOrder ASC

DROP TABLE #tmpTable
END
/****** Object:  StoredProcedure [dbo].[sp_GetPasswordRecoverySuccessfulTokenValue]    Script Date: 12/02/2012 12:51:07 ******/
SET ANSI_NULLS ON





GO
