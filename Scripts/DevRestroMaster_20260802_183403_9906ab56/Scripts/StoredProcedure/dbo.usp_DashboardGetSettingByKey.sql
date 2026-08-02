SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashboardGetSettingByKey]
(
 @SettingKey NVARCHAR(256),
 @UserName NVARCHAR(256),
 @PortalID INT
) 
AS
BEGIN
 SELECT SettingValue FROM DashboardSettingsKeyValue
 WHERE SettingKey=@SettingKey
 AND PortalID=@PortalID
 AND UserName=@UserName
END





GO
