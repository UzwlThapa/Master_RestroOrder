SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Template_PageIDUpdates] (
 @pageID NVARCHAR(MAX)
 ,@parentID NVARCHAR(MAX)
 ,@userModuleID NVARCHAR(MAX)
 ,@ShowInAllPages NVARCHAR(MAX)
 )
AS
BEGIN
 CREATE TABLE #TblPageID (
  RowNum INT IDENTITY(1, 1)
  ,PageID INT
  )

 INSERT INTO #TblPageID
 SELECT *
 FROM dbo.Split(@pageID, ',')

 CREATE TABLE #TblParentID (
  RowNum INT IDENTITY(1, 1)
  ,ParentID INT
  )

 INSERT INTO #TblParentID
 SELECT *
 FROM dbo.Split(@parentID, ',')

 DECLARE @COUNT INT
  ,@Counter INT

 SET @Counter = (
   SELECT COUNT(*)
   FROM #TblPageID
   )
 SET @COUNT = 1

 WHILE (@COUNT <= @Counter)
 BEGIN
  DECLARE @PageID_ INT
  DECLARE @ParentID_ INT

  SET @PageID_ = (
    SELECT PageID
    FROM #TblPageID
    WHERE RowNum = @COUNT
    )
  SET @ParentID_ = (
    SELECT ParentID
    FROM #TblParentID
    WHERE RowNum = @COUNT
    )

  UPDATE Pages
  SET ParentID = @ParentID_
  WHERE PageID = @PageID_

  SET @COUNT = @COUNT + 1
 END

 CREATE TABLE #TbluserModeleID (
  RowNum INT IDENTITY(1, 1)
  ,UserModuleID INT
  )

 INSERT INTO #TbluserModeleID
 SELECT *
 FROM dbo.Split(@userModuleID, ':')

 CREATE TABLE #TblshowInAllPages (
  RowNum INT IDENTITY(1, 1)
  ,ShowInAllPages VARCHAR(100)
  )

 INSERT INTO #TblshowInAllPages
 SELECT *
 FROM dbo.Split(@ShowInAllPages, ':')

 DECLARE @Count2 INT
  ,@Counter2 INT

 SET @Counter2 = (
   SELECT COUNT(*)
   FROM #TbluserModeleID
   )
 SET @Count2 = 1

 WHILE (@Count2 <= @Counter2)
 BEGIN
  DECLARE @UserModuleID_ INT
  DECLARE @ShowInAllPages_ VARCHAR(100)

  SET @UserModuleID_ = (
    SELECT UserModuleID
    FROM #TbluserModeleID
    WHERE RowNum = @Count2
    )
  SET @ShowInAllPages_ = (
    SELECT ShowInAllPages
    FROM #TblshowInAllPages
    WHERE RowNum = @Count2
    )

  UPDATE UserModules
  SET ShowInPages = @ShowInAllPages_
  WHERE UserModuleID = @UserModuleID_

  SET @Count2 = @Count2 + 1
 END

 DROP TABLE #TblPageID

 DROP TABLE #TblParentID

 DROP TABLE #TbluserModeleID

 DROP TABLE #TblshowInAllPages
END





GO
