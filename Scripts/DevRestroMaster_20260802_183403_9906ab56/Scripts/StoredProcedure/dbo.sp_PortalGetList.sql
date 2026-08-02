SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[sp_PortalGetList]
 AS
 BEGIN
  SELECT Por.PortalID,[Name],LOWER(LTRIM(RTRIM(SEOName))) AS SEOName, IsParent ,Por.ParentID,
    (Select SEOName FROM Portal as port WHERE Por.ParentID = port.PortalID  ) AS ParentPortalName,
    [dbo].[SettingValue].SettingValue AS DefaultPage
  FROM dbo.Portal AS Por
     INNER JOIN [dbo].[SettingValue] ON  Por.PortalID = [dbo].[SettingValue].settingtypeid 
  WHERE SettingType='SiteAdmin' and SettingKey='PortalDefaultPage'
 END





GO
