SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SettingDelete]
 @SettingID INT, 
 @PortalID INT 
AS
DELETE FROM 
 [dbo].[Setting] 
WHERE 
 [SettingID] = @SettingID





GO
