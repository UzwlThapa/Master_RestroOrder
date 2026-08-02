SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Template_ParentIDUpdate] (
 @newMenuItemIDstring NVARCHAR(MAX)
 ,@newMenuParentIDstring NVARCHAR(MAX)
 )
AS
BEGIN
 CREATE TABLE #TblMenuItemID (
  RowNum INT IDENTITY(1, 1)
  ,MenuItemID NVARCHAR(100)
  )

 INSERT INTO #TblMenuItemID
 SELECT *
 FROM dbo.Split(@newMenuItemIDstring, ',')

 DECLARE @TblMenuItemParentID TABLE (
  RowNum INT IDENTITY(1, 1)
  ,ParentID NVARCHAR(100)
  )

 INSERT INTO @TblMenuItemParentID
 SELECT *
 FROM dbo.Split(@newMenuParentIDstring, ',')

 DECLARE @Count INT
  ,@Counter INT

 SET @Counter = (
   SELECT COUNT(1)
   FROM #TblMenuItemID
   )
 SET @Count = 1

 WHILE (@Count <= @Counter)
 BEGIN
  DECLARE @MenuItemID_ INT
  DECLARE @ParentID_ INT

  SET @MenuItemID_ = (
    SELECT MenuItemID
    FROM #TblMenuItemID
    WHERE RowNum = @Count
    )
  SET @ParentID_ = (
    SELECT ParentID
    FROM @TblMenuItemParentID
    WHERE RowNum = @Count
    )

  UPDATE MenuItem
  SET ParentID = @ParentID_
  WHERE MenuItemID = @MenuItemID_

  SET @Count = @Count + 1
 END

 DROP TABLE #TblMenuItemID
END





GO
