SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashBoardSettingsSelect] 
(
 @PortalID INT, 
 @UserModuleID INT 
) 
AS 
  BEGIN 
      DECLARE @TbltempDashBoardControl TABLE
      ( 
        settingkey   NVARCHAR(500), 
        settingvalue NVARCHAR(500)
        ) 

      INSERT INTO @TbltempDashBoardControl 
      SELECT [dbo].[DashBoardSettingKey].[SettingKey]  AS settingkey, 
             COALESCE([dbo].[DashBoardSettingValue].settingvalue, 
             [dbo].[DashBoardSettingKey].settingvalue) AS settingvalue 
      FROM   [dbo].[DashBoardSettingValue] 
             RIGHT JOIN [dbo].[DashBoardSettingKey] 
               ON [dbo].[DashBoardSettingValue].settingkey = [dbo].[DashBoardSettingKey].settingkey 
                  AND [dbo].[DashBoardSettingValue].usermoduleid = @UserModuleID 
                  AND [dbo].[DashBoardSettingValue].portalid = @PortalID; 

      WITH tracksetting 
           AS (SELECT * 
               FROM (SELECT settingvalue, 
                              CASE [SettingKey] 
                                WHEN 'START_DATE' THEN 'START_DATE' 
                                WHEN 'END_DATE' THEN 'END_DATE' 
                                WHEN 'SELECT_TYPE' THEN 'SELECT_TYPE'
        
                              END AS skey 
                       FROM   @TbltempDashBoardControl)datatable PIVOT ( MAX(settingvalue) 
                      FOR skey 
                      IN ( 
                      start_date, end_date, select_type ))pivottable) 
      SELECT * FROM tracksetting 
  END





GO
