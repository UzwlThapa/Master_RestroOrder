SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetAllSettings] @PortalID    INT,
                                          @SettingType NVARCHAR(100)
AS
    IF( @SettingType = 'SuperUser' )
      BEGIN
          SELECT [dbo].[settingkey].settingkey
                 AS [SettingKey],
                 COALESCE([dbo].[settingvalue].settingvalue,
                 [dbo].[settingkey].settingvalue) AS
                 [SettingValue]
          FROM   [dbo].[settingvalue]
                 INNER JOIN [dbo].[settingkey]
                         ON [dbo].[settingvalue].settingkey =
                            [dbo].[settingkey].settingkey
                            AND [dbo].[settingvalue].settingtype =
                                [dbo].[settingkey].settingtype,
                 dbo.portal
          WHERE  ( [dbo].[settingvalue].settingtype = 'SuperUser'  )
      END
    ELSE IF ( @SettingType = 'SiteAdmin' )
      BEGIN
          SELECT [dbo].[settingkey].settingkey
                 AS [SettingKey],
                 COALESCE([dbo].[settingvalue].settingvalue,
                 [dbo].[settingkey].settingvalue) AS
                 [SettingValue]
          FROM   [dbo].[settingvalue]
                 INNER JOIN [dbo].[settingkey]
                         ON [dbo].[settingvalue].settingkey =
                            [dbo].[settingkey].settingkey
                            AND [dbo].[settingvalue].settingtype =
                                [dbo].[settingkey].settingtype
                 INNER JOIN dbo.portal
                         ON dbo.portal.portalid =
                            [dbo].[settingvalue].settingtypeid
          WHERE  ( [dbo].[settingvalue].settingtype = 'SiteAdmin' )
      END
    ELSE
      BEGIN
	  CREATE TABLE  #tmp
	  (
	  [SettingKey] NVARCHAR(MAX),
	  settingvalue NVARCHAR(MAX)
	  )
          --SELECT settingkey AS [SettingKey],
          --       settingvalue
         INSERT INTO   #tmp
             SELECT 
                         [dbo].[settingkey].settingkey,
                         COALESCE([dbo].[settingvalue].settingvalue,
                         [dbo].[settingkey].settingvalue) AS
                         [SettingValue]
                  FROM   [dbo].[settingvalue]
                         INNER JOIN [dbo].[settingkey]
                                 ON [dbo].[settingvalue].settingkey =
                                    [dbo].[settingkey].settingkey
                                    AND [dbo].[settingvalue].settingtype =
                                        [dbo].[settingkey].settingtype
                  WHERE  ( [dbo].[settingvalue].settingtype = 'SuperUser' and 
                  [dbo].[settingvalue].settingtypeid= 1 ) 
                 --CROSS JOIN dbo.portal


          INSERT INTO #tmp
                    
          SELECT [dbo].[settingkey].settingkey
                 AS [SettingKey],
                 COALESCE([dbo].[settingvalue].settingvalue,
                 [dbo].[settingkey].settingvalue) AS
                 [SettingValue]
          FROM   [dbo].[settingvalue]
                 INNER JOIN [dbo].[settingkey]
                         ON [dbo].[settingvalue].settingkey =
                            [dbo].[settingkey].settingkey
                            AND [dbo].[settingvalue].settingtype =
                                [dbo].[settingkey].settingtype
                 INNER JOIN dbo.portal
                         ON dbo.portal.portalid =
                            [dbo].[settingvalue].settingtypeid
          WHERE  ( [dbo].[settingvalue].settingtype = 'SiteAdmin' and [dbo].[settingvalue].settingtypeid=@PortalID )

          SELECT *
          FROM   #tmp
		       
          DROP TABLE #tmp
      END





GO
