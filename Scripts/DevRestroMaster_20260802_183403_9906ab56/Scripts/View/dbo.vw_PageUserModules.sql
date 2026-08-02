SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*------------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE VIEW [dbo].[vw_PageUserModules]
AS
SELECT DISTINCT 
                      p.PageID, p.SEOName, p.PortalID, pm.UserModuleID, um.UserModuleTitle, um.ModuleDefID, pm.PaneName, pm.ModuleOrder, um.IsHandheld, um.UserModuleTitle AS Expr1, um.SuffixClass, 
                      um.ShowHeaderText, um.HeaderText, um.IsInAdmin, mc.ControlSrc, mc.SupportsPartialRendering, ump.RoleID, ump.Username, um.AllPages, um.ShowInPages, mc.ControlType, um.IsDeleted, 
                      um.IsActive,
                          (SELECT     COUNT(1) AS Expr1
                            FROM          dbo.ModuleControls AS mc1
                            WHERE      (ModuleDefID = um.ModuleDefID) AND (IsDeleted <> 1)) AS ControlsCount
FROM         dbo.Pages AS p LEFT OUTER JOIN
                      dbo.PageModules AS pm ON p.PageID = pm.PageID AND p.PortalID = pm.PortalID LEFT OUTER JOIN
                      dbo.UserModules AS um ON pm.UserModuleID = um.UserModuleID LEFT OUTER JOIN
                      dbo.ModuleControls AS mc ON mc.ModuleDefID = um.ModuleDefID AND p.IsDeleted <> 1 AND mc.ControlType = 1 LEFT OUTER JOIN
                      dbo.UserModulePermission AS ump ON ump.UserModuleID = um.UserModuleID
WHERE     (ISNULL(p.IsDeleted, 0) = 0) AND (ISNULL(um.IsDeleted, 0) = 0) AND (um.IsActive = 1)





GO
