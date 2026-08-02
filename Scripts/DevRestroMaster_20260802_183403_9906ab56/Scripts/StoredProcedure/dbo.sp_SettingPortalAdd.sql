SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SettingPortalAdd]
 @SettingPortal INT=null OUTPUT,
 @SettingID INT,
 @Value NVARCHAR(2000),
 @PortalID INT
AS

INSERT INTO [dbo].[SettingPortal]
(
 [SettingID],
 [Value],
 [PortalID]
) VALUES (
 @SettingID,
 @Value,
 @PortalID
)

SET @SettingPortal= SCOPE_IDENTITY()





GO
