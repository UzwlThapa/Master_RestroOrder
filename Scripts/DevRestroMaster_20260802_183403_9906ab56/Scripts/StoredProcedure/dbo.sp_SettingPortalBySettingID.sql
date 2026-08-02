SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SettingPortalBySettingID]
 @SettingID INT,
 @PortalID INT
AS
SELECT
 [SettingPortalID],
 [SettingID],
 [Value],
 [PortalID],
 (
  SELECT 
   [dbo].[Setting].[Name] 
  FROM
   [dbo].[Setting] 
  WHERE 
   [dbo].[Setting].[SettingID]=@SettingID
 ) AS [Name],
 (
  SELECT 
   [dbo].[Setting].[Value]  
  FROM 
   [dbo].[Setting] 
  WHERE 
   [dbo].[Setting].[SettingID]=@SettingID
 ) as [DefaultValue]
FROM 
 [dbo].[SettingPortal]
WHERE 
  PortalID=@PortalID 
 AND [SettingID]=@SettingID





GO
