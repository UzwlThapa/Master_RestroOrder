SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageMenuSettingGetAll] 
 @UserModuleID [INT],
 @PortalID [INT]

WITH EXECUTE AS CALLER
AS
BEGIN

DECLARE @MenuID INT

IF EXISTS(SELECT SettingValue FROM SageMenuSettingValue WHERE SettingKey='MenuID' AND UserModuleID=@UserModuleID)
BEGIN
SELECT @MenuID=SettingValue FROM SageMenuSettingValue WHERE SettingKey='MenuID' AND UserModuleID=@UserModuleID
END
ELSE
BEGIN
SELECT @MenuID=MenuID FROM Menu WHERE IsDefault=1
END


SELECT *
FROM (

SELECT [dbo].[MenuMgrSettingKey].[SettingKey] AS SettingKey,@MenuID AS MenuID
      ,COALESCE([dbo].[MenuMgrSettingValue].SettingValue,[dbo].[MenuMgrSettingKey].SettingValue) AS SettingValue
    
 FROM [dbo].[MenuMgrSettingValue]
  RIGHT JOIN [dbo].MenuMgrSettingKey ON [dbo].[MenuMgrSettingValue].SettingKey = [dbo].MenuMgrSettingKey.SettingKey AND 
  [dbo].[MenuMgrSettingValue].MenuID = @MenuID AND [dbo].[MenuMgrSettingValue].PortalID=@PortalID

 )p PIVOT ( MAX(settingvalue)
FOR
settingkey IN([MenuType],[DisplayMode],[TopMenuSubType],[Caption],[SubTitleLevel],[SideMenuType])) AS pivottable
END





GO
