SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[sp_SettingBySettingID]
 @SettingID INT
AS
SELECT
 [SettingID],
 [Name],
 [Value],
 [Description]
FROM 
 [dbo].[Setting]
WHERE
 [SettingID] = @SettingID





GO
