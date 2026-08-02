SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec usp_sagecleanup
CREATE PROCEDURE [dbo].[usp_sagecleanup]
AS
	SET NOCOUNT ON
	BEGIN TRAN
	IF OBJECT_ID('tempdb..#unwantedpages') IS NOT NULL
	    DROP TABLE #unwantedpages
	
	IF OBJECT_ID('tempdb..#unwantedmoduleids') IS NOT NULL
	    DROP TABLE #unwantedmoduleids
	
	IF OBJECT_ID('tempdb..#unwantedusers') IS NOT NULL
	    DROP TABLE #unwantedusers  
	
	IF OBJECT_ID('tempdb..#unwantedroles') IS NOT NULL
	    DROP TABLE #unwantedroles     
	
	SELECT DISTINCT pageid INTO     #unwantedpages
	FROM   Pages                 AS p
	WHERE  p.PortalID <> -1
	       AND p.PageID <> 1
	       AND p.PageName <> 'Under Construction'
	
	DELETE 
	FROM   PagePermission FROM PagePermission pp
	       INNER JOIN #unwantedpages un
	            ON  pp.PageID = un.pageid
	
	PRINT 'Pagepermission Table Cleaned Successfully.'
	
	DELETE 
	FROM   pagemodules FROM pagemodules pp
	       INNER JOIN #unwantedpages un
	            ON  pp.PageID = un.pageid
				
	DELETE	FROM   pagemodules  WHERE PageID = 1
	
	PRINT 'Pagemodule Table Cleaned Successfully.'
	DELETE 
	FROM   Pages FROM pages p
	       INNER JOIN #unwantedpages un
	            ON  p.PageID = un.pageid 
	
	PRINT 'Pages Table Cleaned Successfully.'
	
	SELECT DISTINCT usermoduleid INTO #unwantedmoduleids
	FROM   usermodules
	WHERE  usermoduleid NOT IN (SELECT DISTINCT usermoduleid
	                            FROM   pagemodules)
	
	DELETE 
	FROM   UserModulePermission FROM UserModulePermission AS um
	       INNER JOIN #unwantedmoduleids mi
	            ON  um.UserModuleID = mi.usermoduleid
	
	PRINT 'UserModulePermission Table Cleaned Successfully.'
	TRUNCATE TABLE HtmlText
	PRINT 'HTMLText Table Truncated Successfully.'
	
	DELETE 	FROM   UserModules  FROM   UserModules AS um
	       INNER JOIN #unwantedmoduleids mi
	            ON  um.UserModuleID = mi.usermoduleid
	
	PRINT 'Usermodules Table Cleaned Successfully.' 
	----------------------------------------Users & Roles
	SELECT DISTINCT userid INTO     #unwantedusers
	FROM   aspnet_Users          AS au
	WHERE  au.UserName NOT IN ('superuser', 'admin', 'anonymoususer')
	
	SELECT DISTINCT roleid INTO     #unwantedroles
	FROM   aspnet_Roles          AS au
	WHERE  au.rolename NOT IN ('Super User', 'Site Admin', 'Registered User', 
	                          'Anonymous User')
	
	DELETE 
	FROM   aspnet_Membership FROM aspnet_Membership AS am
	       INNER JOIN #unwantedusers uu
	            ON  am.UserId = uu.userid
	
	PRINT 'Aspnet_Membership Table Cleaned Successfully.'
	
	DELETE 
	FROM   PortalUser FROM   PortalUser AS pu
	       INNER JOIN #unwantedusers uu
	            ON  pu.UserId = uu.userid
	
	PRINT 'Aspnet_Membership Table Cleaned Successfully.'
	
	DELETE 
	FROM   aspnet_Users FROM aspnet_Users AS au
	       INNER JOIN #unwantedusers uu
	            ON  au.UserId = uu.userid
	
	DELETE 
	FROM   aspnet_UsersInRoles FROM   aspnet_UsersInRoles AS auir
	       INNER JOIN #unwantedusers uu
	            ON  auir.UserId = uu.userid
	
	PRINT 'Aspnet_UsersInRoles Table Cleaned Successfully.'
	
	DELETE
	FROM   Users
	WHERE  UserName NOT IN ('superuser', 'admin', 'anonymoususer')
	
	PRINT 'Users Table Cleaned Successfully.'
	
	
	DELETE
	FROM   Languages
	WHERE  CultureCode <> 'en-US'
	
	PRINT 'Language Table Cleaned Successfully.'
	
	
	DELETE 	FROM   Portal  WHERE PORTALID <> 1	
	PRINT 'Portal Table Cleaned Successfully.'
	
	DELETE 
	FROM   aspnet_UsersInRoles FROM aspnet_UsersInRoles AS auir
	       INNER JOIN #unwantedroles uu
	            ON  auir.RoleId = uu.roleid
	
	DELETE 
	FROM   aspnet_Roles FROM aspnet_Roles AS ar
	       INNER JOIN #unwantedroles uu
	            ON  ar.RoleId = uu.roleid 
	
	PRINT 'Aspnet_Roles Table Cleaned Successfully.'
	
	DELETE 
	FROM   PortalRole FROM   PortalRole AS pr
	       INNER JOIN #unwantedroles uu
	            ON  pr.RoleId = uu.roleid 	
	PRINT 'PortalRole Table Cleaned Successfully.'
	
	-------- Internal contains
	
	DELETE 
	FROM   PageMenu
	WHERE  (PageID <> 1 AND isadmin <> 1) 
	
	
	PRINT 'PageMenu Table Cleaned Successfully.'
	DELETE 
	FROM   MenuItem
	WHERE  PageID <> 1 
	
	PRINT 'Menuitem Table Cleaned Successfully.'  
	DELETE 
	FROM   PagePreview
	WHERE  pageid <> 1 
	
	PRINT 'Pagepreview Table Cleaned Successfully.'
	DELETE 
	FROM   SettingValue
	WHERE  SettingTypeID <> 1 
	
	PRINT 'SettingValue Table Truncated Successfully.'
	TRUNCATE TABLE BannerImage
	PRINT 'BannerImage Table Truncated Successfully.'
	TRUNCATE TABLE cachesearch
	PRINT 'Cachesearch Table Truncated Successfully.'
	TRUNCATE TABLE codes
	PRINT 'Codes Table Cleaned Successfully.'
	TRUNCATE TABLE ContactUs
	PRINT 'ContactUs Table Truncated Successfully.'
	
	TRUNCATE TABLE MenuMgrSettingValue
	PRINT 'MenuMgrSettingValue Table Truncated Successfully.'
	TRUNCATE TABLE SageBanner
	PRINT 'SageBanner Table Truncated Successfully.'
	TRUNCATE TABLE SageBannerSettingValue
	PRINT 'SageBannerSettingValue Table Truncated Successfully.'
	
	TRUNCATE TABLE SageFrameSearchSettingValue
	PRINT 'SageFrameSearchSettingValue Table Truncated Successfully.'
	TRUNCATE TABLE TaskToDo
	PRINT 'Tasktodo Table Truncated Successfully.' 
	
	TRUNCATE TABLE SessionTracker
	PRINT 'SessionTracker Table Truncated successfully.'
	TRUNCATE TABLE PageMenu_History
	PRINT 'PageMenu_History Table Truncated successfully.'
	TRUNCATE TABLE pagemodules_history
	PRINT 'pagemodules_history Table Truncated successfully.'
	TRUNCATE TABLE PagePermission_History
	PRINT 'PagePermission_History Table Truncated successfully.'
	TRUNCATE TABLE Pages_History
	PRINT 'Pages_History Table Truncated successfully.'
	TRUNCATE TABLE UserModules_History
	PRINT 'UserModules_History Table Truncated successfully.'
	
	TRUNCATE TABLE Log
	PRINT 'Log Table Truncated successfully.'
	
	TRUNCATE TABLE Logo
	PRINT 'Logo Table Truncated successfully.'
	
	TRUNCATE TABLE LogActivity 
	PRINT 'LogActivity  Table Truncated successfully.'
	
	TRUNCATE TABLE LocalModuleTitle
	PRINT 'LocalModuleTitle Table Truncated successfully.'

	TRUNCATE TABLE LocalPage
	PRINT 'LocalPage Table Truncated successfully.'

	TRUNCATE TABLE SuspendedIP
	PRINT 'SuspnededIP Table Truncated successfully.'

	COMMIT TRAN




GO
