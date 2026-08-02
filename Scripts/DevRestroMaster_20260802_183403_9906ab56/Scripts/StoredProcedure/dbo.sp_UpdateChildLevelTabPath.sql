SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED DATE: 2010-07-21
CREATE PROCEDURE [dbo].[sp_UpdateChildLevelTabPath]
@ParentID INT,
@NewParentLevel INT,
@NewParentTabPath nvarchar(4000),
@UpdatedBy nvarchar(256),
@PortalID INT
AS

BEGIN
 DECLARE @TblChildPages TABLE 
  ( 
   RowNum INT IDENTITY(1,1), 
   ChildPageID INT,
   ChildPageSEOName NVARCHAR(1000)
  )

 INSERT INTO @TblChildPages
  (
   ChildPageID,
   ChildPageSEOName
  ) 
 SELECT 
  PageID,
  SEOName 
 FROM 
  [dbo].Pages 
 WHERE 
   ParentID=@ParentID 
  AND (IsDeleted=0 OR IsDeleted IS NULL)

 DECLARE @Counter INT, @Count INT, @NewPageLevel INT, @NewTabPath NVARCHAR(4000)
 SET @Counter=1
 SELECT @Count=COUNT(*) FROM @TblChildPages
 WHILE @Counter<=@Count
 BEGIN
  DECLARE @ChildPageID INT,@SEOName NVARCHAR(1000)
  SELECT 
   @ChildPageID=ChildPageID,
   @SEOName=ChildPageSEOName 
  FROM 
   @TblChildPages 
  WHERE 
   RowNum=@Counter

  SET @NewPageLevel=@NewParentLevel+1
  SET @NewTabPath=@NewParentTabPath+'/'+@SEOName

  EXECUTE [dbo].[sp_UpdateChildLevelTabPath] @ChildPageID,@NewPageLevel,@NewTabPath,@UpdatedBy,@PortalID

  UPDATE 
   [dbo].Pages 
  SET 
   [Level]=@NewPageLevel,
   TabPath= @NewTabPath 
  WHERE 
   PageID=@ChildPageID

  SET @Counter=@Counter+1
 END
END





GO
