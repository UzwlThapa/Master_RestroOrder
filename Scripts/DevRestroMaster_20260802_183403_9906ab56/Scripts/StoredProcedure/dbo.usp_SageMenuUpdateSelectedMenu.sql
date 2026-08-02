SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageMenuUpdateSelectedMenu]
(
@UserModuleID INT,
@PortalID INT,
@SettingKey NVARCHAR(250),
@SettingValue NVARCHAR(250)
)
AS
BEGIN
IF EXISTS(SELECT * FROM SageMenuSettingValue WHERE UserModuleID=@UserModuleID AND PortalID=@PortalID)
BEGIN
UPDATE SageMenuSettingValue
SET SettingValue=@SettingValue
WHERE UserModuleID=@UserModuleID
AND PortalID=@PortalID
END
ELSE
BEGIN
INSERT INTO SageMenuSettingValue
(
SettingKey,SettingValue,PortalID,UserModuleID
)
VALUES
(
@SettingKey,@SettingValue,@PortalID,@UserModuleID
)
END
END





GO
