SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashboardQuickLinkGet]  --'superuser',1
(
 @UserName NVARCHAR(50),
 @PortalID INT
)
AS

 BEGIN 
      SELECT DISTINCT p.pageid, p.pagename, p.tabpath AS URL, 
                      p.iconfile, ds.imagepath, p.title, 
                      p.seoname, ds.DisplayName, ds.DisplayOrder,
      ds.QuickLinkID
      FROM   dbo.pagepermission pp 
             INNER JOIN dashboardquicklinks ds ON pp.pageid = ds.pageid 
             INNER JOIN pages p ON ds.pageid = p.pageid 
      WHERE  pp.roleid IN (SELECT roleid FROM   dbo.aspnet_usersinroles 
                               INNER JOIN dbo.aspnet_users ON dbo.aspnet_usersinroles.userid = dbo.aspnet_users.userid 
                           WHERE  dbo.aspnet_users.username = @UserName)
   AND (p.PortalID=@PortalID OR p.PortalID=-1) AND ds.IsActive=1
   ORDER BY ds.DisplayOrder ASC
  END





GO
