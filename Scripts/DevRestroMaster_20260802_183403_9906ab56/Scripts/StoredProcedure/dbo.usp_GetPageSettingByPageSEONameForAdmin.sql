SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_GetPageSettingByPageSEONameForAdmin]
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
     FROM [dbo].[Pages]
     INNER JOIN [dbo].[PagePermission] ON [dbo].[PagePermission].PageID = [dbo].[Pages].PageID
     WHERE (
       [dbo].[Pages].PortalID = @PortalID
       OR [dbo].[Pages].PortalID = - 1
       )
      AND [dbo].[Pages].SEOName = @PageSEOName
      AND (
       [dbo].[Pages].[IsDeleted] = 0
       OR [dbo].[Pages].[IsDeleted] IS NULL
       )
   )
 BEGIN
    
      IF EXISTS (
        SELECT [dbo].[Pages].PageID
        FROM [dbo].[Pages]
        INNER JOIN [dbo].[PagePermission] ON [dbo].[PagePermission].PageID = [dbo].[Pages].PageID
        WHERE (
          [dbo].[PagePermission].[RoleID] IN ( 
                 SELECT [dbo].[aspnet_UsersInRoles].RoleId
                 FROM [dbo].[aspnet_UsersInRoles]
                 INNER JOIN [dbo].[aspnet_Users] ON [dbo].[aspnet_Users].UserId = [dbo].[aspnet_UsersInRoles].UserId
                 WHERE [dbo].[aspnet_Users].UserName = @UserName
           
                UNION ALL
                
                SELECT [RoleId]
                FROM dbo.aspnet_roles
                WHERE LoweredRoleName = 'anonymous user'
               )
                OR [dbo].[PagePermission].Username = @UserName
          )
         AND [dbo].[Pages].SEOName = @PageSEOName
         AND (
          [dbo].[Pages].[IsDeleted] = 0
          OR [dbo].[Pages].[IsDeleted] IS NULL
          )
         AND (
          [dbo].[Pages].PortalID = @PortalID
          OR [dbo].[Pages].PortalID = - 1
          )
         AND (
          [dbo].[PagePermission].[IsDeleted] = 0
          OR [dbo].[PagePermission].[IsDeleted] IS NULL
          )
        )
      BEGIN
       DECLARE @tblRoleID TABLE ([UserRoleId] VARCHAR(50))   
       DECLARE @tblPageID TABLE ([PageID] VARCHAR(50))--,[PortalID] INT  ) -- UNIQUE NONCLUSTERED ([PageID],[PortalID])) 
          
           
        INSERT INTO @tblRoleID
        SELECT [dbo].[aspnet_UsersInRoles].RoleId 
        FROM [dbo].[aspnet_UsersInRoles]
          LEFT JOIN [dbo].[aspnet_Users] ON [dbo].[aspnet_Users].UserId = [dbo].[aspnet_UsersInRoles].UserId
          LEFT JOIN [dbo].[aspnet_roles] ON [dbo].[aspnet_roles].RoleId = [dbo].[aspnet_UsersInRoles].RoleId 
        WHERE [dbo].[aspnet_Users].[UserName] = @UserName OR [dbo].[aspnet_roles].[LoweredRoleName] = 'anonymous user'   
          
          
       INSERT INTO @tblPageID 
       SELECT DISTINCT p.PageID -- ,p.PortalID               
       FROM   [dbo].[Pages] p
           INNER JOIN [dbo].[PagePermission] ON [dbo].[PagePermission].PageID = p.PageID
       WHERE   ISNULL(p.[IsDeleted],0) = 0 
           AND p.SEOName = @PageSEOName
           AND (p.PortalID = @PortalID OR p.PortalID = - 1)
            
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
       FROM  Pages where SEOName = @PageSEOName
       
         ------------------------------------------------------------------------------------------------------------------------------------------------
         DECLARE @IsPageAccessible BIT
         SET @IsPageAccessible = 0 
       
       IF EXISTS (
          SELECT 1
          FROM [dbo].[PortalUser] pu
           LEFT JOIN [dbo].[Portal] p ON p.PortalID = pu.PortalID
           LEFT JOIN aspnet_usersinroles au ON pu.UserID = AU.UserId
           LEFT JOIN aspnet_roles AR ON AR.RoleId = AU.RoleId
          WHERE (pu.Username = @UserName or  AR.RoleName = 'Super User')  and p.PortalID = 1  
           AND pu.IsActive = 1
           AND ISNULL(pu.IsDeleted,0) = 0
            
             
         )
       SET @IsPageAccessible = 1    
        
       SELECT cast(1 AS BIT) AS IsPageAvailable, CAST(@IsPageAccessible AS BIT) AS IsPageAccessible, @IsSecure AS [IsSecure]    
       
       ------------------------------------------------------------------------------------------------------------------------------------------------------------

       DECLARE @PageID INT

       SELECT @PageID = PageID
       FROM   Pages
       WHERE  SEOName = @PageSEOName AND PortalID = @PortalID   

       ------------------------------------------------------------------------------------------------------------------------------------------------------------

       SELECT DISTINCT  p.PageID, PageOrder, PageName, IsVisible, ParentID, [Level],
            @IconFile AS [IconFile], DisableLink, @Title AS [Title],
            @Description AS [Description], @KeyWords AS [KeyWords], 
            Url, TabPath, StartDate, EndDate, @RefreshInterval AS [RefreshInterval],
            @PageHeadText AS [PageHeadText], @IsSecure AS [IsSecure]       
       FROM    [dbo].[Pages] p
           INNER JOIN [dbo].[PagePermission] ON [dbo].[PagePermission].PageID = p.PageID
       WHERE   (p.[IsDeleted] = 0 AND p.SEOName = @PageSEOName
           AND (p.PortalID = @PortalID OR p.PortalID = - 1 ))
         
         ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
         
         SELECT DISTINCT  [dbo].[PageModules].*,[dbo].[ModuleControls].[ModuleControlID],
          [dbo].[ModuleControls].[ControlKey],
          [dbo].[ModuleControls].[ControlTitle],[dbo].[ModuleControls].[ControlSrc],
          [dbo].[ModuleControls].[IconFile] AS [ModuleIconFile],
          [dbo].[ModuleControls].[ControlType],
          [dbo].[ModuleControls].[DisplayOrder],
          [dbo].[ModuleControls].[HelpUrl],
          [dbo].[ModuleControls].[ModuleDefID],
          [dbo].[ModuleControls].[SupportsPartialRendering] 
         
      FROM  [dbo].[UserModules] INNER JOIN [dbo].[ModuleControls]   ON [dbo].[UserModules].ModuleDefID = [dbo].[ModuleControls].ModuleDefID 
          INNER JOIN [dbo].[UserModulePermission]      ON [dbo].[UserModulePermission].UserModuleID = [dbo].[UserModules].UserModuleID 
          INNER JOIN [dbo].[PageModules]    ON [dbo].[UserModules].UserModuleID = [dbo].[PageModules].UserModuleID 


      WHERE [dbo].[PageModules].PageID IN (SELECT PageID FROM @tblPageID )
          AND   (
            [dbo].[UserModulePermission].RoleID  IN (SELECT [UserRoleId] FROM @tblRoleID )
             OR [dbo].[UserModulePermission].Username=@UserName
             ) 
          AND ([dbo].[PageModules].IsActive =1 
          AND ([dbo].[PageModules].[IsDeleted] = 0 OR [dbo].[PageModules].[IsDeleted] IS NULL)) 

          AND ([dbo].[ModuleControls].IsDeleted=0 OR [dbo].[ModuleControls].[IsDeleted] IS NULL) 
          AND ([dbo].[ModuleControls].[ControlType]= @ControlType) --OR  [dbo].[ModuleControls].[ControlType]=0) 

          AND [dbo].[UserModules].IsActive=1 
          AND ([dbo].[UserModules].IsDeleted=0 OR [dbo].[UserModules].IsDeleted IS NULL)
         
     
          ---- IF EXISTS(SELECT * FROM @tblPageID WHERE PortalID=-1)
          ----BEGIN
          ---- INSERT #TmpModules
          ---- SELECT DISTINCT [dbo].[PageModules].*,
          ----       [dbo].[ModuleControls].[ModuleControlID],
          ----       [dbo].[ModuleControls].[ControlKey],
          ----     [dbo].[ModuleControls].[ControlTitle],
          ----       [dbo].[ModuleControls].[ControlSrc],
          ----       [dbo].[ModuleControls].[IconFile] AS [ModuleIconFile],
          ----     [dbo].[ModuleControls].[ControlType],
          ----     [dbo].[ModuleControls].[DisplayOrder],
          ----     [dbo].[ModuleControls].[HelpUrl],
          ----     [dbo].[ModuleControls].[SupportsPartialRendering]
          ----  FROM  [dbo].[UserModules]
          ---- INNER JOIN [dbo].[ModuleControls] 
          ----   ON [dbo].[UserModules].ModuleDefID = [dbo].[ModuleControls].ModuleDefID 
          ---- INNER JOIN [dbo].[UserModulePermission] 
          ----   ON [dbo].[UserModulePermission].UserModuleID = [dbo].[UserModules].UserModuleID 
          ---- INNER JOIN [dbo].[PageModules] 
          ----   ON [dbo].[UserModules].UserModuleID = [dbo].[PageModules].UserModuleID
          ---- INNER JOIN [dbo].[Pages] 
          ----   ON [dbo].[PageModules].PageID=[dbo].[Pages].PageID 
          ----   AND ([dbo].[Pages].[IsDeleted] = 0 OR [dbo].[Pages].[IsDeleted] IS NULL)
                         
                         
          ---- WHERE [dbo].[UserModules].PortalID=@PortalID 
           
          ----   AND [dbo].[UserModules].AllPages=1  AND [dbo].[PageModules].IsActive=1 
                         
          ----  AND ([dbo].[PageModules].IsDeleted=0 OR [dbo].[PageModules].IsDeleted IS NULL) 
          ----   AND [dbo].[UserModules].IsActive=1 
                         
          ---- AND ([dbo].[UserModules].IsDeleted=0 OR [dbo].[UserModules].IsDeleted IS NULL) 
           
          ---- AND ([dbo].[ModuleControls].[ControlType]= @ControlType OR  [dbo].[ModuleControls].[ControlType]=0) 
                 
          ---- AND [dbo].[Pages].PageID IN(SELECT PageID FROM [dbo].[PageMenu] WHERE IsAdmin=1)
           
          ---- AND @PageID IN (SELECT RTRIM(LTRIM(items)) 
          ----     FROM   Split([dbo].UserModules.[showinpages], ',') 
          ----     WHERE ([dbo].UserModules.isdeleted=0 OR [dbo].UserModules.isdeleted IS NULL))
          ----END
          ----ELSE
          ----BEGIN
          ---- INSERT #TmpModules
          ---- SELECT DISTINCT [dbo].[PageModules].*,
          ----       [dbo].[ModuleControls].[ModuleControlID],
          ----       [dbo].[ModuleControls].[ControlKey],
          ----     [dbo].[ModuleControls].[ControlTitle],
          ----       [dbo].[ModuleControls].[ControlSrc],
          ----       [dbo].[ModuleControls].[IconFile] AS [ModuleIconFile],
          ----     [dbo].[ModuleControls].[ControlType],
          ----     [dbo].[ModuleControls].[DisplayOrder],
          ----     [dbo].[ModuleControls].[HelpUrl],
          ----     [dbo].[ModuleControls].[SupportsPartialRendering]
          ----  FROM  [dbo].[UserModules]
          ----     INNER JOIN [dbo].[ModuleControls] ON [dbo].[UserModules].ModuleDefID = [dbo].[ModuleControls].ModuleDefID 
          ----    INNER JOIN [dbo].[UserModulePermission] ON [dbo].[UserModulePermission].UserModuleID = [dbo].[UserModules].UserModuleID 
          ----    INNER JOIN [dbo].[PageModules] ON [dbo].[UserModules].UserModuleID = [dbo].[PageModules].UserModuleID 
          ----      AND [dbo].[UserModules].PortalID=[dbo].[PageModules].PortalID
          ----    INNER JOIN [dbo].[Pages] ON [dbo].[PageModules].PageID=[dbo].[Pages].PageID AND [dbo].[Pages].IsDeleted=0 
          ----    WHERE [dbo].[Pages].PageID
          ----        IN(SELECT PageID FROM [dbo].[PageMenu] WHERE IsAdmin=1) 
             
              
          ----    AND ([dbo].[PageModules].IsDeleted=0 OR [dbo].[PageModules].IsDeleted IS NULL) 
              
          ----    AND [dbo].[UserModules].IsActive=1 AND ([dbo].[UserModules].IsDeleted=0 OR [dbo].[UserModules].IsDeleted IS NULL)
               
          ----    AND ([dbo].[ModuleControls].[ControlType]= @ControlType 
          ----      OR  [dbo].[ModuleControls].[ControlType]=0)
                
                
          ----    AND [dbo].[UserModules].PortalID=@PortalID  
              
          ----    AND [dbo].[UserModules].AllPages=1 AND [dbo].[PageModules].IsActive=1 
                 
                
          ----    OR @PageID IN (
          ----          SELECT RTRIM(LTRIM(items)) 
          ----          FROM   Split([dbo].UserModules.[showinpages], ',') 
          ----          WHERE ([dbo].UserModules.isdeleted=0 OR [dbo].UserModules.isdeleted IS NULL) 
          ----          AND [dbo].[ModuleControls].[ControlType]= @ControlType
          ----        )
                    
                
                
                
                
          ----END
          ---- SELECT DISTINCT * FROM #TmpModules 
          ---- WHERE (PortalID=@PortalID OR PortalID=-1) --ORDER BY ModuleOrder ASC
          ---- DROP TABLE #TmpModules
           
                  
              
        
        
        
      END
   ELSE
   BEGIN
    SELECT cast(1 AS BIT) AS IsPageAvailable,cast(0 AS BIT) AS IsPageAccessible
   END
 END
 ELSE
  BEGIN
   SELECT cast(0 AS BIT) AS IsPageAvailable, cast(0 AS BIT) AS IsPageAccessible
  END
END




GO
