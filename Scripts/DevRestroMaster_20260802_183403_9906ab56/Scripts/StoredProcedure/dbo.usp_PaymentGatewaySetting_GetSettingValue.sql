SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PaymentGatewaySetting_GetSettingValue]
--@UserModuleID int,
@PortalID int
AS
select UserModuleID , PortalID , PaymentID , SettingValue ,PaymentID
FROM PaymentGateWaySetting 
where PortalID  = @PortalID 
--and UserModuleID = @UserModuleID





GO
