SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- ALTER date: 2010-04-18
-- Description:  GoogleAdsense Settings
-- =============================================  
CREATE PROCEDURE [dbo].[sp_AdSenseSettingsCount] @UserModuleID    INT,
                                                @PortalID        INT,
                                                @UserModuleCount INT output
AS
  BEGIN
      SELECT @UserModuleCount = COUNT(usermoduleid)
      FROM   dbo.usermodulesettings
      WHERE  usermoduleid = @UserModuleID
             AND portalid = @PortalID
             AND ( isdeleted IS NULL
                    OR isdeleted = 0 )
  END





GO
