SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UserModulesGetDetails] (
 @UserModuleID INT,
 @PortalID INT
) AS
BEGIN
 SELECT
  m.FriendlyName,
  pm.PaneName,
  pm.PageID,
  um.UserModuleID,
  um.UserModuleTitle,
  um.AllPages,
  um.SEOName,
  um.ShowInPages,
  um.IsHandheld,
  um.SuffixClass,
  um.HeaderText,
  um.IsActive,
  um.InheritViewPermissions,
  um.ShowHeaderText
 FROM
  UserModules um
 INNER JOIN ModuleDefinitions md ON um.ModuleDefID = md.ModuleDefID
 INNER JOIN Modules m ON md.ModuleID = m.ModuleID
 INNER JOIN PageModules pm ON um.UserModuleID = pm.UserModuleID
 WHERE
  um.UserModuleID =@UserModuleID
 AND um.PortalID =@PortalID 
 END





GO
