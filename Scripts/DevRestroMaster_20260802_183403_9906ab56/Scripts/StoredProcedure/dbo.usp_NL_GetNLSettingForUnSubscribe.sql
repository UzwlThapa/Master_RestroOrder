SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_NL_GetNLSettingForUnSubscribe]

AS
SELECT *
FROM   (SELECT nk.SettingKey,
               Coalesce(nv.SettingValue, nk.SettingValue) AS settingvalue
        FROM  NL_SettingValue nv
              RIGHT JOIN NL_SettingKey nk
                 ON nv.SettingKey = nk.SettingKey )p PIVOT ( MAX(settingvalue)
       FOR
       settingkey  IN([ModuleHeader],[ModuleDescription],[UnSubscribePageName],[IsMobileSubscription])) AS pivottable





GO
