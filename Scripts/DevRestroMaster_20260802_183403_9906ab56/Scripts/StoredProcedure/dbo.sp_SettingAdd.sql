SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SettingAdd]
 @SettingID INT = NULL OUTPUT,
 @Name NVARCHAR(200),
 @Value NVARCHAR(2000),
 @Description NTEXT
AS

INSERT INTO [dbo].[Setting] (
 [Name],
 [Value],
 [Description]
) VALUES (
 @Name,
 @Value,
 @Description
)

SET @SettingID= SCOPE_IDENTITY()





GO
