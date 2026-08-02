SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SettingPortalByPortalID]
 @PortalID INT
AS
SELECT
 [dbo].[SettingPortal].[SettingPortalID], 
 [dbo].[SettingPortal].[SettingID],
 [dbo].[SettingPortal].[Value],
 [dbo].[SettingPortal].[PortalID],
 [dbo].[Setting].[Name],
 [dbo].[Setting].[Value] AS DefaultValue
FROM 
 [dbo].[SettingPortal]
RIGHT OUTER JOIN 
 [dbo].[Setting] 
ON 
 [dbo].[SettingPortal].SettingID = [dbo].[Setting].SettingID
WHERE 
 [PortalID]=@PortalID
ORDER BY 
 [dbo].[Setting].[Name]





GO
