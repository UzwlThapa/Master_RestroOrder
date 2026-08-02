SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[usp_GetRefPage] '2010/01/01','2015/01/01', 5,1
CREATE PROCEDURE [dbo].[usp_GetRefPage] 
@DashBoardStartDate DATETIME ,
@DashBoardEndDate DATETIME,
@range INT,
@pageNo INT
AS
BEGIN
DECLARE @Temp1 TABLE(RefPage NVARCHAR(200))

INSERT INTO @Temp1
SELECT
    CASE WHEN CHARINDEX('/',SessionOriginalReferrer,9) = 0 
  THEN SessionOriginalReferrer
  ELSE LEFT(SessionOriginalReferrer, CHARINDEX('/',SessionOriginalReferrer,9)-1)
  END AS RefPage FROM SessionTracker 
 WHERE [Start] BETWEEN @DashBoardStartDate and @DashBoardEndDate 
 AND  SessionOriginalReferrer <> ''

DECLARE @Temp2 TABLE(RowNum INT IDENTITY(1,1), RefPage NVARCHAR(200), VisitTime INT)
INSERT INTO @Temp2
 SELECT DISTINCT RefPage, COUNT(*) AS [VisitTime]  FROM @Temp1
  GROUP BY RefPage
ORDER BY [VisitTime] DESC 

DECLARE @Count INT
SET @Count =(SELECT COUNT(*) FROM @Temp2)
SELECT @Count AS [Count], * FROM  @Temp2
  WHERE RowNum BETWEEN (@PageNo - 1) * @Range + 1 
       AND @PageNo * @Range
  ORDER BY RowNum ASC
END





GO
