SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PortalModulesUpdate] 
 @ModuleIDs NVARCHAR (4000),
 @IsActives NVARCHAR(4000),
 @PortalID INT,
 @UpdatedBy NVARCHAR(256)
WITH EXECUTE AS CALLER
AS
BEGIN 
 DECLARE @TblModuleIDs AS TABLE (
        RowNo INT IDENTITY(1,1), 
        ModuleID INT
        )
        
 DECLARE @TblIsActive AS TABLE(
        RowNo INT IDENTITY(1,1), 
        IsActive BIT
       )
 DECLARE @Counter INT
 DECLARE @Count INT

 INSERT INTO @TblModuleIDs(ModuleID)
   SELECT RTRIM(LTRIM(items)) FROM split(@ModuleIDs,',')
 
 INSERT INTO @TblIsActive(IsActive)
   SELECT RTRIM(LTRIM(items)) FROM split(@IsActives,',')
 
 SELECT @Count=COUNT(RowNo) FROM @TblModuleIDs
 SET @Counter=1
 WHILE(@Counter<=@Count or @Counter=1)
 BEGIN
IF(EXISTS(SELECT * FROM dbo.PortalModules WHERE PortalID=@PortalID AND 
[ModuleID] = (SELECT [ModuleID] FROM @TblModuleIDs WHERE RowNo=@Counter )))
 BEGIN
   UPDATE dbo.PortalModules SET 
        IsActive=(SELECT IsActive FROM @TblIsActive WHERE RowNo=@Counter)
        ,UpdatedOn=GETDATE()
        ,UpdatedBy=@UpdatedBy
   WHERE PortalID=@PortalID AND [ModuleID] = (SELECT [ModuleID] FROM @TblModuleIDs WHERE RowNo=@Counter )
 END
ELSE
 BEGIN
  DECLARE @ModuleID INT, @IsActive BIT
  SELECT @ModuleID=[ModuleID] FROM @TblModuleIDs WHERE RowNo=@Counter
  SELECT @IsActive=IsActive FROM @TblIsActive WHERE RowNo=@Counter
  INSERT INTO dbo.PortalModules (
  [PortalID],
  [ModuleID],
  [IsActive],
  [AddedOn],
  [AddedBy]
 ) VALUES (
  @PortalID,
  @ModuleID,
  @IsActive,
  GETDATE(),
  @UpdatedBy
 )
 END
  SET @Counter=@Counter+1
 END
END





GO
