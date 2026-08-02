SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SageFrameSearchSettingValueAddUpdate]
 @SettingKeys NVARCHAR(4000),
 @SettingValues NVARCHAR(4000),
 @AddedBy NVARCHAR(256),
 @PortalID INT,
 @CultureName NVARCHAR(256)

AS
BEGIN
 TRUNCATE TABLE CacheSearch 
 DECLARE @TblSettingKeys TABLE
 (
  RowNum INT IDENTITY(1,1),
  SettingKey NVARCHAR(100)
 )
 DECLARE @TblSettingValues TABLE
 (
  RowNum INT IDENTITY(1,1),
  SettingValue NVARCHAR(256)
 )

 INSERT INTO @TblSettingKeys(SettingKey)
 SELECT RTRIM(LTRIM(items)) FROM split(@SettingKeys,'#')
 INSERT INTO @tblSettingValues(SettingValue)
 SELECT RTRIM(LTRIM(items)) FROM split(@SettingValues,'#')

 DECLARE @KeyCount INT
 DECLARE @ValueCount INT
 DECLARE @Counter INT
 SELECT @KeyCount=COUNT(RowNum) from @TblSettingKeys
 SELECT @ValueCount=COUNT(RowNum) from @TblSettingValues
 
 SET @Counter=1
 WHILE(@Counter<=@KeyCount or @Counter=1)
  BEGIN
   DECLARE @Key NVARCHAR(256),@Value NVARCHAR(256)
   SELECT @Key=[SettingKey] FROM @TblSettingKeys WHERE RowNum=@Counter
   SELECT @Value=[SettingValue] FROM @TblSettingValues WHERE RowNum=@Counter
   IF(EXISTS(
     SELECT * FROM [dbo].[SageFrameSearchSettingValue] 
     WHERE 
      [dbo].[SageFrameSearchSettingValue].[SettingKey]=@Key 
     AND [dbo].[SageFrameSearchSettingValue].[PortalID]=@PortalID 
     AND [dbo].[SageFrameSearchSettingValue].[CultureName] = @CultureName
    ))
    BEGIN
     UPDATE [dbo].[SageFrameSearchSettingValue] SET
      [SettingValue] = @Value,
      [UpdatedOn] = GETDATE(),
      [UpdatedBy] = @AddedBy
     WHERE
       [dbo].[SageFrameSearchSettingValue].[SettingKey]=@Key 
      AND [dbo].[SageFrameSearchSettingValue].[PortalID]=@PortalID 
      AND [dbo].[SageFrameSearchSettingValue].[CultureName] = @CultureName
    END
   ELSE
    BEGIN
     INSERT INTO [dbo].[SageFrameSearchSettingValue]
      (
       [SettingKey],
       [SettingValue],
       [CultureName],
       [PortalID],
       [AddedBy]
      )
     VALUES
      (
       @Key,
       @Value,
       @CultureName,
       @PortalID,
       @AddedBy
      )
    END
   SET @counter=@counter+1
  END
END





GO
