SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  DINESH HONA
-- Create date: <Create Date, ,>
-- Description: <Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_GetSettingValueBySettingKey]
(
@SettingType nvarchar(100),
@SettingTypeID int,
@SettingKey nvarchar(256)
)
RETURNS nvarchar(256)
AS
BEGIN
 -- Declare the return variable here
 DECLARE @SettingValue nvarchar(256)
 SELECT @SettingValue=Coalesce([dbo].[SettingValue].SettingValue,[dbo].[SettingKey].SettingValue)
 FROM [dbo].[SettingValue]
  INNER JOIN [dbo].[SettingKey] ON [dbo].[SettingValue].SettingKey = [dbo].[SettingKey].SettingKey AND [dbo].[SettingValue].SettingType = [dbo].[SettingKey].SettingType
 WHERE [dbo].[SettingValue].SettingType=@SettingType AND [dbo].[SettingValue].SettingTypeID = @SettingTypeID AND [dbo].[SettingValue].SettingKey=@SettingKey

 RETURN @SettingValue
END





GO
