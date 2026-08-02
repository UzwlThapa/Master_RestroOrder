SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashBoardSettingAddUpdate]
(
 @SettingKey NVARCHAR(256),
 @SettingValue NVARCHAR(256),
 @UserName NVARCHAR(50),
 @PortalID INT
) 
AS
BEGIN
 SET NOCOUNT ON;
 IF(EXISTS(SELECT DashboardSettingKeyID FROM DashboardSettingsKeyValue
     WHERE @SettingKey=SettingKey AND PortalID=@PortalID 
     AND UserName=@UserName))
  BEGIN
   UPDATE DashboardSettingsKeyValue
   SET SettingValue=@SettingValue
   WHERE UserName=@UserName AND PortalID=@PortalID AND SettingKey=@SettingKey
  END
 ELSE
  BEGIN
   INSERT INTO DashboardSettingsKeyValue
   (
    SettingKey,SettingValue,IsActive,AddedOn,PortalID,UserName
   )
   VALUES
   (
    @SettingKey,@SettingValue,1,GETDATE(),@PortalID,@UserName
   )
  END
END





GO
