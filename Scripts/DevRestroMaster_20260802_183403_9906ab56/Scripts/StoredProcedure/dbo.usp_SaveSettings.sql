SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SaveSettings]
(
@SettingKey NVARCHAR(256),
@SettingValue NVARCHAR(50)
)
AS
BEGIN
SET NOCOUNT ON;
UPDATE MembershipSettings
SET SettingValue=@SettingValue
WHERE SettingKey=@SettingKey
END;





GO
