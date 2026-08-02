SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SettingUpdate]
 @SettingID INT, 
 @Name NVARCHAR(200), 
 @Value NVARCHAR(2000), 
 @Description NTEXT
AS

UPDATE 
 [dbo].[Setting] 
SET
 [Name] = @Name,
 [Value] = @Value,
 [Description] = @Description
WHERE 
 [SettingID] = @SettingID





GO
