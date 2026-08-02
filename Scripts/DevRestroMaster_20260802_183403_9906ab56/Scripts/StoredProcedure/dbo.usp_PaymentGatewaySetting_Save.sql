SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  [usp_PaymentGatewaySetting_Save]
CREATE PROCEDURE [dbo].[usp_PaymentGatewaySetting_Save]
@SettingValue nvarchar(max),
@PortalID int,
@UserModuleID int,
@UserName nvarchar(256),
@CultureCode nvarchar(100)
AS
BEGIN
IF(EXISTS(select 1 from [PaymentGateWaySetting] where PortalID = @PortalID and  UserModuleID = @UserModuleID))
	BEGIN
		UPDATE [PaymentGateWaySetting]
		SET [SettingValue] = @SettingValue
		where PortalID = @PortalID and
		[UserModuleID] = @UserModuleID	
	END
ELSE
	BEGIN
	INSERT INTO [dbo].[PaymentGateWaySetting]
			   ([UserModuleID]
			   ,[PortalID]
			   ,[Culture]
			   ,[SettingValue]
			   ,[AddedBy]
			   ,[ModifiedOn])
		 VALUES
			   ( @UserModuleID, @PortalID , @CultureCode , @SettingValue , @UserName , GETDATE())
	END
END





GO
