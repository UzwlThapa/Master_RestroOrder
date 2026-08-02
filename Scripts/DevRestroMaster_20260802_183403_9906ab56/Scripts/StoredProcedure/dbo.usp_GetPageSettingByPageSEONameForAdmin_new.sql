SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_rename 'usp_GetPageSettingByPageSEONameForAdmin','usp_GetPageSettingByPageSEONameForAdmin_backup'

CREATE PROCEDURE [dbo].[usp_GetPageSettingByPageSEONameForAdmin_new]
   @ControlType INT
   , @PageSEOName NVARCHAR(1000)
   , @PortalID INT
   , @UserName NVARCHAR(256)
 WITH EXECUTE AS CALLER
AS
BEGIN
  --- page exists  with portalID and SEOName and isnot marked for deletion   --- 

 IF EXISTS (
     SELECT [dbo].[Pages].PageID
     FROM [dbo].[Pages] with (nolock)
     INNER JOIN [dbo].[PagePermission] with (nolock) ON [dbo].[PagePermission].PageID = [dbo].[Pages].PageID
											AND [dbo].[Pages].SEOName = @PageSEOName
     WHERE (
       [dbo].[Pages].PortalID = @PortalID
       OR [dbo].[Pages].PortalID = - 1
       )
      AND (
       [dbo].[Pages].[IsDeleted] = 0
       OR [dbo].[Pages].[IsDeleted] IS NULL
       )
   )
 BEGIN
    
      IF EXISTS (
        SELECT p.PageID
        FROM [dbo].[Pages] p with (nolock)
        INNER JOIN [dbo].[PagePermission] pp with (nolock) ON pp.PageID = p.PageID	AND p.SEOName = @PageSEOName
		left join [dbo].[aspnet_UsersInRoles] uir with (nolock) on pp.RoleID=uir.RoleId
		left JOIN [dbo].[aspnet_Users] u with (nolock) on u.UserId = uir.UserId
		left join  dbo.aspnet_roles r with (nolock) on pp.RoleID= r.RoleId
		WHERE (u.UserName = @UserName or r.LoweredRoleName='anonymous user')		
		AND (
          p.[IsDeleted] = 0
          OR p.[IsDeleted] IS NULL
          )
         AND (
          p.PortalID = @PortalID
          OR p.PortalID = - 1
          )
         AND (
          pp.[IsDeleted] = 0
          OR pp.[IsDeleted] IS NULL
          )
        
         
        )
      BEGIN
       --DECLARE @tblRoleID TABLE ([UserRoleId] VARCHAR(50))   
       --DECLARE @tblPageID TABLE ([PageID] VARCHAR(50))--,[PortalID] INT  ) -- UNIQUE NONCLUSTERED ([PageID],[PortalID])) 
          
           
       -- INSERT INTO @tblRoleID
       -- SELECT [dbo].[aspnet_UsersInRoles].RoleId 
       -- FROM [dbo].[aspnet_UsersInRoles]
       --   LEFT JOIN [dbo].[aspnet_Users] ON [dbo].[aspnet_Users].UserId = [dbo].[aspnet_UsersInRoles].UserId
       --   LEFT JOIN [dbo].[aspnet_roles] ON [dbo].[aspnet_roles].RoleId = [dbo].[aspnet_UsersInRoles].RoleId 
       -- WHERE [dbo].[aspnet_Users].[UserName] = @UserName OR [dbo].[aspnet_roles].[LoweredRoleName] = 'anonymous user'   
          
          
       --INSERT INTO @tblPageID 
       --SELECT DISTINCT p.PageID -- ,p.PortalID               
       --FROM   [dbo].[Pages] p
       --    INNER JOIN [dbo].[PagePermission] ON [dbo].[PagePermission].PageID = p.PageID
       --WHERE   ISNULL(p.[IsDeleted],0) = 0 
       --    AND p.SEOName = @PageSEOName
       --    AND (p.PortalID = @PortalID OR p.PortalID = - 1)
            
        ------------------------------------------------------------------------------------------------------------------------------------------------
         DECLARE @IconFile NVARCHAR(100), @Title NVARCHAR(200), @Description NVARCHAR(500)
         , @KeyWords NVARCHAR(500), @PageHeadText NVARCHAR(500)
         , @IsSecure BIT, @RefreshInterval DECIMAL(16, 2)

       SELECT @IconFile = ISNULL(Pages.IconFile, [dbo].[fn_GetSettingValueBySettingKey]('SiteAdmin', @PortalID, 'IconFile'))
         , @Title = ISNULL(Pages.Title, [dbo].[fn_GetSettingValueBySettingKey]('SiteAdmin', @PortalID, 'PageTitle'))
         , @Description =  ISNULL(Pages.Description, [dbo].[fn_GetSettingValueBySettingKey]('SiteAdmin', @PortalID, 'MetaDescription'))
         , @KeyWords =  ISNULL(Pages.KeyWords, [dbo].[fn_GetSettingValueBySettingKey]('SiteAdmin', @PortalID, 'MetaKeywords'))
         , @PageHeadText =ISNULL(Pages.PageHeadText, [dbo].[fn_GetSettingValueBySettingKey]('SiteAdmin', @PortalID, 'PageHeadText'))
         , @IsSecure =  ISNULL(Pages.IsSecure, [dbo].[fn_GetSettingValueBySettingKey]('SiteAdmin', 1, 'IsSecure'))
         , @RefreshInterval =  ISNULL(Pages.RefreshInterval, [dbo].[fn_GetSettingValueBySettingKey]('SiteAdmin', @PortalID, 'MetaRefresh'))
       FROM  Pages  with (nolock) 
	   where SEOName = @PageSEOName
       
         ------------------------------------------------------------------------------------------------------------------------------------------------
         --DECLARE @IsPageAccessible BIT
         --SET @IsPageAccessible = 0 
       
       --IF EXISTS (
       --   SELECT 1
       --   FROM [dbo].[PortalUser] pu
       --    LEFT JOIN [dbo].[Portal] p ON p.PortalID = pu.PortalID
       --    LEFT JOIN aspnet_usersinroles au ON pu.UserID = AU.UserId
       --    LEFT JOIN aspnet_roles AR ON AR.RoleId = AU.RoleId
       --   WHERE (pu.Username = @UserName or  AR.RoleName = 'Super User')  and p.PortalID = 1  
       --    AND pu.IsActive = 1
       --    AND ISNULL(pu.IsDeleted,0) = 0
            
             
       --  )
       --SET @IsPageAccessible = 1    
        
       SELECT cast(1 AS BIT) AS IsPageAvailable, CAST(1 AS BIT) AS IsPageAccessible, @IsSecure AS [IsSecure]    
       
       ------------------------------------------------------------------------------------------------------------------------------------------------------------

       --DECLARE @PageID INT

       --SELECT @PageID = PageID
       --FROM   Pages
       --WHERE  SEOName = @PageSEOName AND PortalID = @PortalID   

       ------------------------------------------------------------------------------------------------------------------------------------------------------------

       SELECT DISTINCT  p.PageID, PageOrder, PageName, IsVisible, ParentID, [Level],
            @IconFile AS [IconFile], DisableLink, @Title AS [Title],
            @Description AS [Description], @KeyWords AS [KeyWords], 
            Url, TabPath, StartDate, EndDate, @RefreshInterval AS [RefreshInterval],
            @PageHeadText AS [PageHeadText], @IsSecure AS [IsSecure]       
       FROM    [dbo].[Pages] p  with (nolock)
       WHERE  p.SEOName = @PageSEOName AND  (p.[IsDeleted] = 0 
           AND (p.PortalID = @PortalID OR p.PortalID = - 1 ))
         
         ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
         
         SELECT DISTINCT  pm.*,mc.[ModuleControlID],
          mc.[ControlKey],
          mc.[ControlTitle],mc.[ControlSrc],
          mc.[IconFile] AS [ModuleIconFile],
          mc.[ControlType],
          mc.[DisplayOrder],
          mc.[HelpUrl],
          mc.[ModuleDefID],
          mc.[SupportsPartialRendering]          
      FROM  [dbo].[UserModules] um  with (nolock)
		  INNER JOIN [dbo].[ModuleControls]  mc  with (nolock) ON um.ModuleDefID = mc.ModuleDefID 
          INNER JOIN [dbo].[UserModulePermission] ump  with (nolock)    ON ump.UserModuleID = um.UserModuleID 
          INNER JOIN [dbo].[PageModules]  pm  with (nolock) ON um.UserModuleID = pm.UserModuleID 
		  INNER JOIN [dbo].[Pages] p  with (nolock) ON  pm.PageID=p.PageID and p.SEOName=@PageSEOName
      WHERE 1=1
          AND (pm.IsActive =1 
          AND (pm.[IsDeleted] = 0 OR pm.[IsDeleted] IS NULL)) 
          AND (mc.IsDeleted=0 OR mc.[IsDeleted] IS NULL) 
          AND (mc.[ControlType]= @ControlType) --OR  [dbo].[ModuleControls].[ControlType]=0) 
          AND um.IsActive=1 
          AND (um.IsDeleted=0 OR um.IsDeleted IS NULL)         
      END
   ELSE
   BEGIN
    SELECT cast(1 AS BIT) AS IsPageAvailable, cast(0 AS BIT) AS IsPageAccessible
   END
 END
 ELSE
  BEGIN
   SELECT cast(0 AS BIT) AS IsPageAvailable, cast(0 AS BIT) AS IsPageAccessible
  END
END




GO
