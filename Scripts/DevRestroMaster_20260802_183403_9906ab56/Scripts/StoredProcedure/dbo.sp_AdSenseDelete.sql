SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- ALTER date: 2010-04-19
-- Description:  GoogleAdsense Settings
-- Modified date: 2010-05-25
-- =============================================  
CREATE PROCEDURE [dbo].[sp_AdSenseDelete] @UserModuleID INT,
                                         @PortalID     INT
AS
  BEGIN
      DELETE dbo.usermodulesettings
      WHERE  portalid = @PortalID
             AND usermoduleid = @UserModuleID
  END





GO
