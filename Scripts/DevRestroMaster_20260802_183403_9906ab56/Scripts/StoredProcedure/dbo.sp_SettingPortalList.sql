SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SettingPortalList]
AS
SELECT
 [SettingPortalID],
 [SettingID],
 [Value],
 [PortalID]
FROM 
 [dbo].[SettingPortal]





GO
