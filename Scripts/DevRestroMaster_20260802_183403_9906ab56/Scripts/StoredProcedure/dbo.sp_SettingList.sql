SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SettingList]
AS
SELECT
 [SettingID],
 [Name],
 [Value],
 [Description]
FROM 
 [dbo].[Setting]





GO
