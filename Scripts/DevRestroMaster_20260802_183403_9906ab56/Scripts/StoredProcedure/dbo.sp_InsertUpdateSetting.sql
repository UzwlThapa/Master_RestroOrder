SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED BY: 
--CREATED DATE: 2010-04-04
CREATE PROCEDURE [dbo].[sp_InsertUpdateSetting]
 @SettingType NVARCHAR(500),
 @SettingKey NVARCHAR(500),
 @SettingValue NVARCHAR(500),
 @UserName NVARCHAR(256),
 @PortalID INT
WITH EXECUTE AS CALLER
AS
BEGIN
 IF(EXISTS(SELECT * FROM [dbo].[SettingValue] WHERE [dbo].[SettingValue].SettingType=@SettingType AND [dbo].[SettingValue].SettingKey=@SettingKey AND [dbo].[SettingValue].SettingTypeID=@PortalID))
 BEGIN
  UPDATE [dbo].[SettingValue] SET [SettingValue]=@SettingValue, IsModified=1, UpdatedOn=GETDATE(),UpdatedBy=@UserName 
  WHERE [dbo].[SettingValue].SettingType=@SettingType 
  AND [dbo].[SettingValue].SettingKey=@SettingKey 
  AND [dbo].[SettingValue].SettingTypeID=@PortalID
 END
 ELSE
 BEGIN
  INSERT INTO [dbo].[SettingValue]([SettingType]
          ,[SettingTypeID]
          ,[SettingKey]
          ,[SettingValue]
          ,[IsActive]
          ,[AddedOn]
          ,[PortalID]
          ,[AddedBy])
    VALUES(@SettingType,@PortalID,@SettingKey,@SettingValue,1,GETDATE(),@PortalID,@UserName)
 END 
END





GO
