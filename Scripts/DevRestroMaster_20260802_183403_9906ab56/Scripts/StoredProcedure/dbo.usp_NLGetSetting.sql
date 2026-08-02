SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_NLGetSetting]
@UserModuleID INT,
@PortalID INT
AS
SELECT *
FROM   (SELECT nk.SettingKey,
               Coalesce(nv.SettingValue, nk.SettingValue) AS settingvalue
        FROM  NL_SettingValue nv
              RIGHT JOIN NL_SettingKey nk
                 ON nv.SettingKey = nk.SettingKey AND nv.PortalID=@PortalID AND nv.UserModuleID=@UserModuleID )p PIVOT ( MAX(settingvalue)
       FOR
       settingkey  IN([ModuleHeader],[ModuleDescription],[UnSubscribePageName],[IsMobileSubscription])) AS pivottable
       
--       SELECT *
--FROM   (SELECT ak.settingkey,
--               Coalesce(av.settingvalue, ak.settingvalue) AS settingvalue
--        FROM   AdvertisementSettingvalue av
--              RIGHT JOIN AdvertisementSettingkey ak
--                 ON av.settingkey = ak.settingkey AND av.PortalID=@PortalID AND av.UserModuleID=@UserModuleID )p PIVOT ( MAX(settingvalue)
--       FOR
--       settingkey  IN([AdsHeight],[AdsWidth],[AdsType],[ViewType],[NumberOfAds],[IsDimension],[ListType],[AdsNextLineAfter])) AS pivottable





GO
