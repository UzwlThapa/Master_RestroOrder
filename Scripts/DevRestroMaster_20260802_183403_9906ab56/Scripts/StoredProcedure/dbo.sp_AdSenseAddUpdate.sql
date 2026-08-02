SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- ALTER date: 2010-04-18
-- Description:  Adsense Settings
-- =============================================  
CREATE PROCEDURE [dbo].[sp_AdSenseAddUpdate] @UserModuleID INT,
                                            @SettingName  NVARCHAR(256),
                                            @SettingValue NVARCHAR(256),
                                            @IsActive     BIT,
                                            @PortalID     INT,
                                            @UpdatedBy    NVARCHAR(256),
                                            @UpdateFlag   BIT
AS
  BEGIN
      IF( @UpdateFlag = 1 )
        BEGIN
            UPDATE dbo.usermodulesettings
            SET    [settingvalue] = @SettingValue,
                   [updatedby] = @UpdatedBy,
                   [isactive] = @IsActive,
                   [ismodified] = 1,
                   [updatedon] = GETDATE()
            WHERE  settingname = @SettingName
                   AND usermoduleid = @UserModuleID
                   AND portalid = @PortalID
        END
      ELSE
        BEGIN
            INSERT INTO dbo.usermodulesettings
                        ([usermoduleid],
                         [settingname],
                         [settingvalue],
                         [isactive],
                         [addedon],
                         [portalid],
                         [addedby])
            VALUES      ( @UserModuleID,
                          @SettingName,
                          @SettingValue,
                          @IsActive,
                          GETDATE(),
                          @PortalID,
                          @UpdatedBy )
        END
  END





GO
