SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerSettingGetAll]
 @UserModuleID INT,
 @PortalID INT

WITH EXECUTE AS CALLER
AS
BEGIN
 SELECT ISNULL([dbo].[FileManagerSettingValue].[FileManagerSettingValueID],0) AS FileManagerSettingValueID
      ,0 AS [UserModuleID]
      ,[dbo].[FileManagerSettingKey].[SettingKey] AS SettingKey
      ,COALESCE([dbo].[FileManagerSettingValue].SettingValue,[dbo].[FileManagerSettingKey].SettingValue) AS SettingValue
      ,[dbo].[FileManagerSettingValue].[IsActive]
      ,[dbo].[FileManagerSettingValue].[IsDeleted]
      ,[dbo].[FileManagerSettingValue].[IsModified]
      ,[dbo].[FileManagerSettingValue].[AddedOn]
      ,[dbo].[FileManagerSettingValue].[UpdatedOn]
      ,[dbo].[FileManagerSettingValue].[DeletedOn]
      ,[dbo].[FileManagerSettingValue].[PortalID]
      ,[dbo].[FileManagerSettingValue].[AddedBy]
      ,[dbo].[FileManagerSettingValue].[UpdatedBy]
      ,[dbo].[FileManagerSettingValue].[DeletedBy]
 FROM [dbo].[FileManagerSettingValue]
 RIGHT JOIN [dbo].[FileManagerSettingKey] 
        ON [dbo].[FileManagerSettingValue].SettingKey = [dbo].[FileManagerSettingKey].SettingKey 
        AND [dbo].[FileManagerSettingValue].UserModuleID = @UserModuleID 
        AND [dbo].[FileManagerSettingValue].PortalID=@PortalID 
END





GO
