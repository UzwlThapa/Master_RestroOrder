SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SettingPortalAddUpdateList]
 @strKeyes NVARCHAR(4000),
 @strValues nvarchar(4000),
 @PortalID INT,
 @Return INT OUTPUT 
As
BEGIN
 
 DECLARE @TblKeyes TABLE (SettingID INT)
 DECLARE @TblValues TABLE (SettingValues NVARCHAR(2000))
 DECLARE @Pos INT
 SET @Pos = 0
 DECLARE @KeyCount INT
 SET @KeyCount = 0
 DECLARE @ValueCount INT
 SET @ValueCount = 0
 
 WHILE CHARINDEX('#', @strKeyes, 1) > 0 
  BEGIN
   SET @Pos = CHARINDEX('#', @strKeyes, 1)
   INSERT @TblKeyes VALUES (CAST(SUBSTRING(@strKeyes, 1, @Pos-1) AS INT))
   SET @strKeyes = SUBSTRING(@strKeyes, @Pos+1, DATALENGTH(@strKeyes)-@Pos)
  END
 INSERT @TblKeyes VALUES (CAST(@strKeyes AS INT))
 
 
 SET @Pos = 0
 WHILE CHARINDEX('#', @strValues, 1) > 0 
  BEGIN
   SET @Pos = CHARINDEX('#', @strValues, 1)
   INSERT @TblValues VALUES (CAST(SUBSTRING(@strValues, 1, @Pos-1) AS NVARCHAR(2000)))
   SET @strValues = SUBSTRING(@strValues, @Pos+1, DATALENGTH(@strValues)-@Pos)
  END
 INSERT @TblValues VALUES (CAST(@strValues AS NVARCHAR(2000)))
 
 SELECT @KeyCount = COUNT(SettingID) FROM @TblKeyes
 SELECT @ValueCount = COUNT(SettingValues) FROM @TblValues
 
 IF @KeyCount = @ValueCount
  BEGIN
   WHILE @KeyCount <> 0
    BEGIN

     DECLARE @SettingID INT
     DECLARE @SettingValue NVARCHAR(2000)

     SELECT TOP 1 @SettingID = SettingID FROM @TblKeyes
     SELECT TOP 1 @SettingValue = SettingValues FROM @TblValues
     
     EXEC [dbo].[sp_SettingPortalUpdate] @SettingID,@SettingValue,@PortalID

     
     DELETE TOP(1) FROM @TblKeyes
     DELETE TOP(1) FROM @TblValues

     
     SELECT @KeyCount = COUNT(SettingID) FROM @TblKeyes
    End
   SET @Return = 0
  END
 ELSE
  BEGIN
   SET @Return = 1
  END
END





GO
