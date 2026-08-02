SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_AdSenseCount] @UserModuleID    INT,
                                        @PortalID        INT,
                                        @UserModuleCount [INT] output
WITH EXECUTE AS caller
AS
  BEGIN
      DECLARE @AdsenseShow NVARCHAR(256)

      SELECT @AdsenseShow = settingvalue
      FROM   usermodulesettings
      WHERE  settingname = 'AdsenseShow'
             AND portalid = @PortalID
             AND usermoduleid = @UserModuleID
             AND ( isdeleted IS NULL
                    OR isdeleted = 0 )
             AND isactive = 1

      IF( UPPER(@AdsenseShow) = 'TRUE' )
        BEGIN
            SELECT @UserModuleCount = COUNT(usermoduleid)
            FROM   dbo.usermodulesettings
            WHERE  usermoduleid = @UserModuleID
                   AND portalid = @PortalID
                   AND ( isdeleted IS NULL
                          OR isdeleted = 0 )
                   AND isactive = 1
        END
      ELSE
        BEGIN
            SET @UserModuleCount=0
        END
  END





GO
