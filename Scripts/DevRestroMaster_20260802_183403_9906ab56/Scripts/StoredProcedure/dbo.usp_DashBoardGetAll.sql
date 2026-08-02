SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashBoardGetAll] 
(
 @UserModuleID INT,
 @PortalID INT
)
WITH EXECUTE AS CALLER
AS
BEGIN
 SELECT ISNULL([dbo].[DashBoardSettingValue].[DashBoardSettingValueID],0) AS DashBoardSettingValueID
      ,@UserModuleID AS [UserModuleID]
      ,[dbo].[DashBoardSettingKey].[SettingKey] AS SettingKey
      ,COALESCE([dbo].[DashBoardSettingValue].SettingValue,[dbo].[DashBoardSettingKey].SettingValue) AS SettingValue
      ,[dbo].[DashBoardSettingValue].[IsActive]
      ,[dbo].[DashBoardSettingValue].[IsDeleted]
      ,[dbo].[DashBoardSettingValue].[IsModified]
      ,[dbo].[DashBoardSettingValue].[AddedOn]
      ,[dbo].[DashBoardSettingValue].[UpdatedOn]
      ,[dbo].[DashBoardSettingValue].[DeletedOn]
      ,[dbo].[DashBoardSettingValue].[PortalID]
      ,[dbo].[DashBoardSettingValue].[AddedBy]
      ,[dbo].[DashBoardSettingValue].[UpdatedBy]
      ,[dbo].[DashBoardSettingValue].[DeletedBy]
 FROM [dbo].[DashBoardSettingValue]
  RIGHT JOIN [dbo].[DashBoardSettingKey] ON [dbo].[DashBoardSettingValue].SettingKey = [dbo].[DashBoardSettingKey].SettingKey
  AND [dbo].[DashBoardSettingValue].UserModuleID = @UserModuleID 
  AND [dbo].[DashBoardSettingValue].PortalID=@PortalID 
END





GO
