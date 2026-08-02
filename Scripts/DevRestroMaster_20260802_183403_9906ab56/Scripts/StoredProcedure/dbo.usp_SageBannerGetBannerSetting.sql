SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [dbo].[usp_SageBannerGetBannerSetting]1,47,'en-US'
CREATE PROCEDURE [dbo].[usp_SageBannerGetBannerSetting]
(
 @PortalID INT,
 @UserModuleID INT,
 @CultureCode NVARCHAR(100)
)
AS
SELECT *
 FROM (SELECT bk.SettingKey,
   COALESCE(bv.settingvalue, bk.settingvalue) AS settingvalue
   FROM  SageBannerSettingValue bv RIGHT JOIN SageBannerSettingKey bk
   ON bv.SettingKey = bk.SettingKey AND bv.PortalID=@PortalID AND bv.CultureCode=@CultureCode AND bv.UserModuleID=@UserModuleID )p PIVOT(MAX(SettingValue)
     FOR
     SettingKey IN
     (
    [Auto_Direction],
    [Auto_Hover],
    [Auto_Slide],
    [Caption],
    [DisplaySlideQty],
    [Easing],
    [InfiniteLoop],
    [MoveSlideQty],
    [NavigationImagePager],
    [NumericPager],
    [Pause_Time],
    [RandomStart],
    [Speed],
    [Starting_Slide],
    [EnableControl],
    [TransitionMode],
    [BannerToUse]
   )
 ) AS pivottable





GO
