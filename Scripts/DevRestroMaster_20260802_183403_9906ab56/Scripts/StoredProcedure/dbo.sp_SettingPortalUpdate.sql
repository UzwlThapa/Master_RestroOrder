SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SettingPortalUpdate]
 @SettingID INT, 
 @Value NVARCHAR(2000), 
 @PortalID INT 
AS
BEGIN
 IF(EXISTS(
   SELECT * 
   FROM 
    [dbo].[SettingPortal] 
   WHERE 
     [PortalID]=@PortalID 
    AND [SettingID] = @SettingID
  ))
  BEGIN 
    UPDATE 
     [dbo].[SettingPortal] 
    SET
     [SettingID] = @SettingID,
     [Value] = @Value,
     [PortalID] = @PortalID
    WHERE 
      [PortalID]=@PortalID 
     AND [SettingID] = @SettingID
  END
 ELSE
  BEGIN
   INSERT INTO [dbo].[SettingPortal]
     (
      [SettingID],
      [Value],
      [PortalID]
     ) 
    VALUES 
     (
      @SettingID,
      @Value,
      @PortalID
     )
  END
END





GO
