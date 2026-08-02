SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_loc_GetLanguageSwitchSettings]
(
@PortalID INT,
@UserModuleID INT
)
AS
BEGIN
 SELECT ISNULL([dbo].[LanguageSettingValue].[LanguageSettingValueID],0) AS LanguageSettingValueID
      ,0 AS [UserModuleID]
      ,[dbo].[LanguageSettingKey].[SettingKey] AS SettingKey
      ,COALESCE([dbo].[LanguageSettingValue].SettingValue,[dbo].[LanguageSettingKey].SettingValue) AS SettingValue
      ,[dbo].[LanguageSettingValue].[IsActive]
      ,[dbo].[LanguageSettingValue].[IsDeleted]
      ,[dbo].[LanguageSettingValue].[IsModified]
      ,[dbo].[LanguageSettingValue].[AddedOn]
      ,[dbo].[LanguageSettingValue].[UpdatedOn]
      ,[dbo].[LanguageSettingValue].[DeletedOn]
      ,[dbo].[LanguageSettingValue].[PortalID]
      ,[dbo].[LanguageSettingValue].[AddedBy]
      ,[dbo].[LanguageSettingValue].[UpdatedBy]
      ,[dbo].[LanguageSettingValue].[DeletedBy]
 FROM [dbo].[LanguageSettingValue]
 RIGHT JOIN [dbo].[LanguageSettingKey] ON [dbo].[LanguageSettingValue].SettingKey = [dbo].[LanguageSettingKey].SettingKey 
    AND [dbo].[LanguageSettingValue].UserModuleID = @UserModuleID AND [dbo].[LanguageSettingValue].PortalID=@PortalID
 
END





GO
