SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TaskToDo_GetTask] @offset INT
 ,@STR NVARCHAR(50)
 ,@PortalID INT
 ,@ModuleId INT
 ,@Date DATE
 ,@UserName NVARCHAR(200)
 ,@CultureField NVARCHAR(200)
AS
BEGIN
 IF @UserName <> 'anonymoususer'
 BEGIN
  DECLARE @RowTotal INT

  CREATE TABLE #Temptbl (
   RowNum INT identity(1, 1)
   ,TaskId INT
   ,Note NVARCHAR(max)
   ,DATE DATE
   )

  IF @Date = ''
  BEGIN
   IF (@STR = 'PREVIOUS')
   BEGIN
    INSERT INTO #Temptbl
    SELECT TaskId
     ,Note
     ,DATE
    FROM dbo.TaskToDo
    WHERE PortalID = @PortalID
     AND ModuleID = @ModuleId
     AND CultureField = @CultureField
     AND IsDeleted = 0
     AND AddedBy = @UserName
     AND DATE < CONVERT(DATE, GETDATE())
    ORDER BY DATE DESC

    SELECT @RowTotal = COUNT(TaskId)
    FROM #Temptbl

    SELECT TaskID
     ,Note
     ,DATE
     ,@RowTotal AS total
    FROM #Temptbl
    WHERE RowNum > @offset
     AND RowNum <= (@offset + 5)
   END
   ELSE
    IF (@STR = 'TODAY')
    BEGIN
     INSERT INTO #Temptbl
     SELECT TaskId
      ,Note
      ,DATE
     FROM dbo.TaskToDo
     WHERE ModuleID = @ModuleId
      AND CultureField = @CultureField
      AND IsDeleted = 0
      AND AddedBy = @UserName
      AND DATE = CONVERT(DATE, GETDATE())

     SELECT @RowTotal = COUNT(TaskId)
     FROM #Temptbl

     SELECT TaskID
      ,Note
      ,DATE
      ,@RowTotal AS total
     FROM #Temptbl
    END
    ELSE
     IF (@STR = 'UPCOMING')
     BEGIN
      INSERT INTO #Temptbl
      SELECT TaskId
       ,Note
       ,[Date]
      FROM dbo.TaskToDo
      WHERE PortalID = @PortalID
       AND ModuleID = @ModuleId
       AND CultureField = @CultureField
       AND IsDeleted = 0
       AND AddedBy = @UserName
       AND [Date] > CONVERT(DATE, GETDATE())
      ORDER BY DATE

      SELECT @RowTotal = COUNT(TaskId)
      FROM #Temptbl

      SELECT TaskID
       ,Note
       ,DATE
       ,@RowTotal AS total
      FROM #Temptbl
      WHERE RowNum > @offset
       AND RowNum <= (@offset + 5)
     END
     ELSE
     BEGIN
      INSERT INTO #Temptbl
      SELECT TaskId
       ,Note
       ,DATE
      FROM dbo.TaskToDo
      WHERE PortalID = @PortalID
       AND ModuleID = @ModuleId
       AND CultureField = @CultureField
       AND IsDeleted = 0
       AND AddedBy = @UserName
      ORDER BY DATE

      SELECT @RowTotal = COUNT(TaskId)
      FROM #Temptbl

      SELECT TaskID
       ,Note
       ,DATE
       ,@RowTotal AS total
      FROM #Temptbl
      WHERE RowNum > @offset
       AND RowNum <= (@offset + 5)
     END
  END
  ELSE
  BEGIN
   INSERT INTO #Temptbl
   SELECT TaskId
    ,Note
    ,DATE
   FROM dbo.TaskToDo
   WHERE PortalID = @PortalID
    AND ModuleID = @ModuleId
    AND CultureField = @CultureField
    AND IsDeleted = 0
    AND AddedBy = @UserName
    AND DATE = @Date
   ORDER BY DATE DESC

   SELECT @RowTotal = COUNT(TaskId)
   FROM #Temptbl

   SELECT TaskID
    ,Note
    ,DATE
    ,@RowTotal AS total
   FROM #Temptbl
  END

  DROP TABLE #Temptbl
 END
END





GO
