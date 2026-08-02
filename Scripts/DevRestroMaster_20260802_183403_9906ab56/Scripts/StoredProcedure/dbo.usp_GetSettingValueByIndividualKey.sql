SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetSettingValueByIndividualKey] @PortalID INT
 ,@SettingKey NVARCHAR(256)
AS
BEGIN
 IF (
   EXISTS (
    SELECT *
    FROM SettingValue
    WHERE settingKey = @SettingKey
     AND SettingTypeID = @PortalID
    )
   )
 BEGIN
  SELECT SettingValue as Value
  FROM SettingValue
  WHERE settingKey = @SettingKey
   AND SettingTypeID = @PortalID
 END
 ELSE
 BEGIN
  SELECT SettingValue as Value
  FROM SettingKey
  WHERE settingKey = @SettingKey
   AND PortalID = 1
 END
END





GO
