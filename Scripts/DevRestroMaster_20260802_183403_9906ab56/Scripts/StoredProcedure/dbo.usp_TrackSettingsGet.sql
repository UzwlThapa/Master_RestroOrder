SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TrackSettingsGet] (
 @PortalID INT
 ,@UserModuleID INT
 )
AS
BEGIN
 CREATE TABLE #TbltempTrackUser (
  settingkey NVARCHAR(500)
  ,settingvalue NVARCHAR(500)
  )

 INSERT INTO #TbltempTrackUser
 SELECT [dbo].[TrackSettingKey].[SettingKey] AS settingkey
  ,Coalesce([dbo].[TrackSettingValue].settingvalue, [dbo].[TrackSettingKey].settingvalue) AS settingvalue
 FROM [dbo].[TrackSettingValue]
 RIGHT JOIN [dbo].[TrackSettingKey] ON [dbo].[TrackSettingValue].settingkey = [dbo].[TrackSettingKey].settingkey
  AND [dbo].[TrackSettingValue].usermoduleid = @UserModuleID
  AND [dbo].[TrackSettingValue].portalid = @PortalID;

 WITH tracksetting
 AS (
  SELECT *
  FROM (
   SELECT settingvalue
    ,CASE [SettingKey]
     WHEN 'START_DATE'
      THEN 'START_DATE'
     WHEN 'END_DATE'
      THEN 'END_DATE'
     WHEN 'MAP_TYPE'
      THEN 'MAP_TYPE'
     WHEN 'GAEmailAddress'
      THEN 'GAEmailAddress'
     WHEN 'GAPassword'
      THEN 'GAPassword'
     WHEN 'GAProfileID'
      THEN 'GAProfileID'
     END AS skey
   FROM #TbltempTrackUser
   ) datatable
  PIVOT(MAX(settingvalue) FOR skey IN (
     start_date
     ,end_date
     ,map_type
     ,GAEmailAddress
     ,GAPassword
     ,GAProfileID
     )) pivottable
  )
 SELECT *
 FROM tracksetting

 DROP TABLE #TbltempTrackUser
END





GO
