SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetAllSettings] @PortalID    INT,  
                                          @SettingType NVARCHAR(100)  
AS  
    IF( @SettingType = 'SuperUser' )  
      BEGIN  
          SELECT [dbo].[settingvalue].settingtype,  
                 LOWER(Ltrim(Rtrim(dbo.portal.seoname))) + '.'  
                 + [dbo].[settingkey].settingkey  
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
          WHERE  ( [dbo].[settingvalue].settingtype = 'SuperUser' and [dbo].[settingvalue].IsCacheable =1 )  
      END  
    ELSE IF ( @SettingType = 'SiteAdmin' )  
    BEGIN  
     SELECT [dbo].[settingvalue].settingtype,  
      LOWER(Ltrim(Rtrim(dbo.portal.seoname))) + '.'  
      + [dbo].[settingkey].settingkey  
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
     WHERE  ( [dbo].[settingvalue].settingtype = 'SiteAdmin'  and [dbo].[settingvalue].IsCacheable =1 )  
    END  
    ELSE  
      BEGIN  
          SELECT settingtype, LOWER(Ltrim(Rtrim(dbo.portal.seoname))) + '.'   + settingkey AS [SettingKey],      settingvalue  
       
          FROM   (SELECT [dbo].[settingvalue].settingtype,  
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
                  WHERE  ( [dbo].[settingvalue].settingtype = 'SuperUser' and [dbo].[settingvalue].IsCacheable =1)) x  
                 CROSS JOIN dbo.portal  
              
          UNION ALL                 
       
          SELECT [dbo].[settingvalue].settingtype,  
                 LOWER(Ltrim(Rtrim(dbo.portal.seoname))) + '.'  
                 + [dbo].[settingkey].settingkey  
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
          WHERE  ( [dbo].[settingvalue].settingtype = 'SiteAdmin'  and [dbo].[settingvalue].IsCacheable =1 )  
  

      END  

	  
	  




GO
