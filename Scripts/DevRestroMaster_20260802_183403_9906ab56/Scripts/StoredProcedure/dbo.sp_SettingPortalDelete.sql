SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SettingPortalDelete]
 @SettingID INT,
 @PortalID INT
AS

DELETE FROM 
 [dbo].[SettingPortal]
WHERE
  [SettingID]=@SettingID 
 AND [PortalID] = @PortalID





GO
