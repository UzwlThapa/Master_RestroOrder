SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrGetSetting] 
 @PortalID INT,
 @MenuID INT

AS
BEGIN
 SELECT 
  *
 FROM
  (
   SELECT 
    [dbo].[MenuMgrSettingKey].[SettingKey] AS SettingKey
    ,COALESCE
      (
       [dbo].[MenuMgrSettingValue].SettingValue,
       [dbo].[MenuMgrSettingKey].SettingValue
      ) AS SettingValue     
   FROM 
    [dbo].[MenuMgrSettingValue]
   RIGHT JOIN 
    [dbo].MenuMgrSettingKey 
   ON 
     [dbo].[MenuMgrSettingValue].SettingKey = [dbo].MenuMgrSettingKey.SettingKey 
    AND [dbo].[MenuMgrSettingValue].MenuID = @MenuID 
    AND [dbo].[MenuMgrSettingValue].PortalID=@PortalID
  )p 
 PIVOT 
  (
   MAX(settingvalue)
    FOR
     settingkey IN
         (
          [MenuType],
          [DisplayMode],
          [TopMenuSubType],
          [Caption],
          [SubTitleLevel],
          [SideMenuType]
         )
  ) AS pivottable
END





GO
