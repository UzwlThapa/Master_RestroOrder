SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_loc_AddLanguageSwitchSettings] 
 @UserModuleID [INT],
 @SettingKey [NVARCHAR](256),
 @SettingValue [NVARCHAR](256),
 @IsActive [BIT],
 @PortalID [INT],
 @UpdatedBy [NVARCHAR](256),
 @AddedBy NVARCHAR(256)
WITH EXECUTE AS CALLER
AS
BEGIN
IF(EXISTS(SELECT * FROM dbo.LanguageSettingValue WHERE  
 [UserModuleID] = @UserModuleID
 AND [SettingKey] = @SettingKey
 AND PortalID = @PortalID))
BEGIN
UPDATE dbo.LanguageSettingValue SET 
 [SettingValue] = @SettingValue,
 [IsActive] = @IsActive,
 [IsModified] = 1,
 [UpdatedOn] = GETDATE(),
 [PortalID] = @PortalID,
 [UpdatedBy] = @UpdatedBy
WHERE  
 [UserModuleID] = @UserModuleID
 AND [SettingKey] = @SettingKey
 AND PortalID = @PortalID
END
ELSE
BEGIN
 INSERT INTO dbo.LanguageSettingValue ( 
 [UserModuleID],
 [SettingKey],
 [SettingValue],
 [IsActive],
 [AddedOn],
 [PortalID],
 [AddedBy]
) VALUES (
 @UserModuleID,
 @SettingKey,
 @SettingValue,
 @IsActive,
 GETDATE(),
 @PortalID,
 @AddedBy
)
END
END





GO
