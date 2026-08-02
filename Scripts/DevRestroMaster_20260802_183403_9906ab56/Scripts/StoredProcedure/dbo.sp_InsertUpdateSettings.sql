SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_InsertUpdateSettings]
 @SettingTypes NVARCHAR(4000),
 @SettingKeys NVARCHAR(4000),
 @SettingValues NVARCHAR(4000),
 @UserName NVARCHAR(256),
 @PortalID INT
WITH EXECUTE AS CALLER
AS
BEGIN
  DECLARE @TypeCount INT,@KeyCount INT, @ValueCount INT,@Counter INT
  DECLARE @TblSettingType TABLE ( RowNum INT IDENTITY(1,1),SettingType NVARCHAR(100))
  DECLARE @TblSettingKey TABLE( RowNum INT IDENTITY(1,1), SettingKey NVARCHAR(256))
  DECLARE @TblSettingValue TABLE(  RowNum INT IDENTITY(1,1),SettingValue NVARCHAR(256))
  
  INSERT INTO @TblSettingType(SettingType)
  SELECT RTRIM(LTRIM(items)) FROM split(@SettingTypes,',')
  
  INSERT INTO @TblSettingKey(SettingKey)
  SELECT RTRIM(LTRIM(items)) FROM split(@SettingKeys,',')
  
  INSERT INTO @TblSettingValue(SettingValue)
  SELECT RTRIM(LTRIM(items)) FROM split(@SettingValues,',')
  
  
  SELECT @TypeCount = COUNT(RowNum) FROM @TblSettingType
  SELECT @KeyCount = COUNT(RowNum) FROM @TblSettingKey
  SELECT @ValueCount = COUNT(RowNum) FROM @TblSettingValue
  
  IF(@TypeCount<>@KeyCount OR @KeyCount<>@ValueCount)
   BEGIN
    RAISERROR ('Invalid number of key,value or keytype', 16, 1);  
   END
  ELSE
  BEGIN
   SET @Counter=1
   WHILE(@Counter<=@KeyCount OR @Counter=1)
   BEGIN
    DECLARE @key NVARCHAR(256),@value NVARCHAR(256),@type NVARCHAR(100)
    
    SELECT @type=SettingType FROM @TblSettingType WHERE RowNum=@Counter
    SELECT @Key=SettingKey FROM @TblSettingKey WHERE RowNum=@Counter
    SELECT @value=SettingValue FROM @TblSettingValue WHERE RowNum=@Counter
    
    IF(EXISTS(SELECT 1 FROM [dbo].[SettingValue] WHERE [dbo].[SettingValue].SettingType=@type AND [dbo].[SettingValue].SettingKey=@key AND [dbo].[SettingValue].SettingTypeID=@PortalID))
    BEGIN
     UPDATE [dbo].[SettingValue] SET [SettingValue]=@value, IsModified=1, UpdatedOn=GETDATE(),UpdatedBy=@UserName 
     WHERE [dbo].[SettingValue].SettingType=@type 
       AND [dbo].[SettingValue].SettingKey=@key 
       AND [dbo].[SettingValue].SettingTypeID=@PortalID
    END
    ELSE
     BEGIN
      INSERT INTO [dbo].[SettingValue]([SettingType]
              ,[SettingTypeID]
              ,[SettingKey]
              ,[SettingValue]
              ,[IsActive]
              ,[AddedOn]
              ,[PortalID]
              ,[AddedBy])
        VALUES(@type,@PortalID,@key,@value,1,GETDATE(),@PortalID,@UserName)
     END
    
    SET @Counter=@Counter+1
  END
 END
END





GO
