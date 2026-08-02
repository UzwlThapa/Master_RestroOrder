SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetTopvisitedPageSearch] 
@DashBoardStartDate DATETIME ,
@DashBoardEndDate DATETIME

AS
BEGIN
DECLARE @TempTable TABLE
(VisitPage NVARCHAR(250),VisitTime  INT )

INSERT INTO @TempTable 
SELECT
DISTINCT
   CASE CHARINDEX( '?', SessionURL)
       WHEN 0 THEN SessionURL 
       ELSE LEFT(SessionURL, CHARINDEX( '?', SessionURL) - 1) END AS VisitPage , COUNT(*) AS [VisitTime] 
FROM SessionTracker  WHERE SessionURL NOT LIKE '%Admin%' AND SessionURL NOT LIKE '%Super-User%' 
AND  [Start] BETWEEN @DashBoardStartDate AND @DashBoardEndDate
GROUP BY SessionURL 
ORDER BY [VisitTime] DESC
DECLARE @Count INT
SET @Count =(SELECT COUNT(*) FROM @TempTable)
SELECT @Count AS [Count], * FROM  @TempTable
  ORDER BY [Count] ASC
END





GO
