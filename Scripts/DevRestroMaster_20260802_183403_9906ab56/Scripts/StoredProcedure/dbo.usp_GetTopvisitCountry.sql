SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetTopvisitCountry]
@DashBoardStartDate DATETIME ,
@DashBoardEndDate DATETIME ,
@Range INT,
@PageNo INT
AS
BEGIN 

DECLARE @TempTable TABLE
(RowNum INT IDENTITY(1,1) ,SessionUserHostAddress NVARCHAR(250),VisitTime  INT )

INSERT INTO @TempTable 
SELECT DISTINCT SessionUserHostAddress, COUNT(*) AS [VisitTime] 
  FROM SessionTracker
  WHERE [Start] BETWEEN @DashBoardStartDate AND @DashBoardEndDate
 GROUP BY SessionUserHostAddress 
ORDER BY [VisitTime] DESC
DECLARE @Count INT
SET @Count =(SELECT COUNT(*) FROM @TempTable)
SELECT @Count AS [Count], * FROM  @TempTable
  WHERE RowNum BETWEEN (@PageNo - 1) * @Range + 1 
       AND @PageNo * @Range
  ORDER BY RowNum ASC
END





GO
