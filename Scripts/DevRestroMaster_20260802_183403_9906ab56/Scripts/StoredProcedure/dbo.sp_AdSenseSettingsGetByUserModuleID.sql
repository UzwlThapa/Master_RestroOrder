SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- ALTER date: 2010-04-18
-- Description:  Adsense Settings
-- =============================================  
CREATE PROCEDURE [dbo].[sp_AdSenseSettingsGetByUserModuleID] 
 @UserModuleID INT,
    @PortalID     INT
AS
  BEGIN
      SELECT *
      FROM   dbo.usermodulesettings
      WHERE  usermoduleid = @UserModuleID
             AND portalid = @PortalID
             AND ( isdeleted IS NULL
                    OR isdeleted = 0 )
  END





GO
