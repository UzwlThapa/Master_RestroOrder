SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Modified By: Dinesh Hona
CREATE PROCEDURE [dbo].[sp_ModulesRollBack] 
 @ModuleID int,
 @PortalID INT
AS
BEGIN
DECLARE @ModuleDefID INT
SELECT @ModuleDefID=ISNULL(ModuleDefID,0) FROM [dbo].[ModuleDefinitions] WHERE ModuleID=@ModuleID
DELETE FROM [dbo].[PageModules] WHERE UserModuleID IN (SELECT ISNULL(UserModuleID,0) FROM [dbo].[UserModules] WHERE ModuleDefID=@ModuleDefID)
DELETE FROM [dbo].[UserModulePermission] WHERE UserModuleID IN (SELECT ISNULL(UserModuleID,0) FROM [dbo].[UserModules] WHERE ModuleDefID=@ModuleDefID)
DELETE FROM [dbo].[UserModules] WHERE ModuleDefID=@ModuleDefID
DELETE FROM [dbo].[Packages] WHERE ModuleID=@ModuleID
DELETE FROM [dbo].[ModuleControls]  WHERE ModuleDefID = @ModuleDefID
DELETE FROM [dbo].[PortalModulePermission] WHERE PortalModuleID IN (SELECT PortalModuleID FROM [dbo].[PortalModules] WHERE ModuleID=@ModuleID) --AND PortalID=@PortalID)
DELETE FROM [dbo].[ModuleDefPermission] WHERE ModuleDefID = @ModuleDefID
DELETE FROM [dbo].[PortalModules] WHERE ModuleID=@ModuleID 
DELETE FROM [dbo].[ModuleDefinitions] WHERE ModuleID=@ModuleID
DELETE FROM [dbo].[CoreModules] WHERE ModuleID=@ModuleID
DELETE FROM [dbo].[Modules] WHERE ModuleID=@ModuleID
END





GO
