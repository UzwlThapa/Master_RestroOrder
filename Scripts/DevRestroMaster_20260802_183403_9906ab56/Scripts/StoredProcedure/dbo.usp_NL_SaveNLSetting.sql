SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_NL_SaveNLSetting]
@SettingKeys NVARCHAR(128),
@SettingValues NVARCHAR(128),
@UserModuleID INT,
@PortalID INT
AS
DECLARE @IsActive AS BIT
SET @IsActive='true'
BEGIN
  DECLARE @tblKey TABLE
  (
  RowNum INT IDENTITY(1,1),
  SettingKey NVARCHAR(500)
  )
  DECLARE @tblValue TABLE
  (
  RowNum INT IDENTITY(1,1),
  SettingValue NVARCHAR(500)
  )
  INSERT INTO @tblKey 
  SELECT RTRIM(LTRIM(items)) FROM split(@SettingKeys,',')
  INSERT into @tblValue 
  SELECT RTRIM(LTRIM(items)) FROM split(@SettingValues,',')
  DECLARE @counter INT,@RowCount INT
  SELECT @RowCount=COUNT(RowNum) FROM @tblKey
  SET @counter=1
  WHILE(@counter<=@RowCount or @counter=1)
   BEGIN 
    DECLARE @key NVARCHAR(500),@value NVARCHAR(500)
  SELECT @key=SettingKey FROM @tblKey WHERE RowNum=@counter
  SELECT @value=SettingValue FROM @tblValue WHERE RowNum=@counter

IF(EXISTS(SELECT * FROM dbo.NL_SettingValue WHERE  
 [UserModuleID] = @UserModuleID
 AND [SettingKey] = @key))
      BEGIN
      UPDATE  dbo.NL_SettingValue SET 
   [SettingValue] = @value,
 [IsActive] = @IsActive,
 [IsModified] = 1,
 [UpdatedOn] = GETDATE()

 
      WHERE  
  [UserModuleID] = @UserModuleID
 AND [SettingKey] = @key
 
     END
  ELSE
  BEGIN
 INSERT INTO dbo.NL_SettingValue ( 
 [UserModuleID],
 [PortalID],
 [SettingKey],
 [SettingValue],
 [IsActive],
 [AddedOn]
 

) VALUES (
 @UserModuleID, 
 @PortalID,
 @key,
 @value,
 @IsActive,
 GETDATE()
 
 
)
END
SET @counter=@counter+1
END
END





GO
