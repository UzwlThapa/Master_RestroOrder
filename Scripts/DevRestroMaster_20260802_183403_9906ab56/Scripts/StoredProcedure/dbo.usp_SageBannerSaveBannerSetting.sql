SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [dbo].[usp_SageBannerSaveBannerSetting]'BannerToUse','4','superuser','superuser',47,1,'ne-NP'
CREATE PROCEDURE [dbo].[usp_SageBannerSaveBannerSetting]
(
 @SettingKey NVARCHAR(256),
    @SettingValue NVARCHAR(256),
    @Updatedby NVARCHAR(256),
    @AddedBy NVARCHAR(256),
    @usermoduleid INT,
    @PortalID INT,
    @CultureCode NVARCHAR(100)
 )
WITH EXECUTE AS CALLER
AS
DECLARE @IsActive AS BIT
SET @IsActive='true'
BEGIN
 IF(EXISTS(SELECT * FROM dbo.SageBannerSettingValue WHERE  
  [UserModuleID] = @usermoduleid
  AND [SettingKey] = @SettingKey
  AND PortalID = @PortalID
  AND CultureCode=@CultureCode
  ))
 BEGIN
 print 'update'
  UPDATE dbo.SageBannerSettingValue SET 
   [SettingValue] = @SettingValue,
   [IsActive] = @IsActive,
   [IsModified] = 1,
   [UpdatedOn] = GETDATE(),
   [PortalID] = @PortalID,
   [UpdatedBy] = @Updatedby
  WHERE  
   [UserModuleID] = @usermoduleid
   AND [SettingKey] = @SettingKey
   AND PortalID = @PortalID
   AND CultureCode=@CultureCode
   
 END
 ELSE
 BEGIN
 print 'insert'
   INSERT INTO dbo.SageBannerSettingValue 
   ( 
   [UserModuleID],
   [SettingKey],
   [SettingValue],
   [IsActive],
   [AddedOn],
   [PortalID],
   [AddedBy],
   [CultureCode]
   ) 
  VALUES 
   (
   @usermoduleid,
   @SettingKey,
   @SettingValue,
   @IsActive,
   GETDATE(),
   @PortalID,
   @AddedBy,
   @CultureCode
  )
 END;
END;





GO
