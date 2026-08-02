SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PageMgr_UpdSettingKeyValue] 
@Page NVARCHAR(200),
@PortalID INT
AS
BEGIN
 --UPDATE dbo.SettingKey SET SettingValue=@Page WHERE SettingKey='PortalDefaultPage' 
 UPDATE dbo.SettingValue SET SettingValue=@Page WHERE SettingKey='PortalDefaultPage' and SettingTypeID = @PortalID

END





GO
