SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TrackSettingGetAll] 
(@UserModuleID INT,
 @PortalID INT)
  WITH EXECUTE AS CALLER AS
BEGIN
 SELECT
  ISNULL(
   [dbo].[TrackSettingValue].[TrackSettingValueID],
   0
  ) AS TrackSettingValueID ,@UserModuleID AS [UserModuleID],
  [dbo].[TrackSettingKey].[SettingKey] AS SettingKey,
  COALESCE (
   [dbo].[TrackSettingValue].SettingValue,
   [dbo].[TrackSettingKey].SettingValue
  ) AS SettingValue,
  [dbo].[TrackSettingValue].[IsActive],
  [dbo].[TrackSettingValue].[IsDeleted],
  [dbo].[TrackSettingValue].[IsModified],
  [dbo].[TrackSettingValue].[AddedOn],
  [dbo].[TrackSettingValue].[UpdatedOn],
  [dbo].[TrackSettingValue].[DeletedOn],
  [dbo].[TrackSettingValue].[PortalID],
  [dbo].[TrackSettingValue].[AddedBy],
  [dbo].[TrackSettingValue].[UpdatedBy],
  [dbo].[TrackSettingValue].[DeletedBy]
 FROM
  [dbo].[TrackSettingValue]
 RIGHT JOIN [dbo].[TrackSettingKey] ON [dbo].[TrackSettingValue].SettingKey = [dbo].[TrackSettingKey].SettingKey
 AND [dbo].[TrackSettingValue].UserModuleID = @UserModuleID
 AND [dbo].[TrackSettingValue].PortalID =@PortalID
 END





GO
