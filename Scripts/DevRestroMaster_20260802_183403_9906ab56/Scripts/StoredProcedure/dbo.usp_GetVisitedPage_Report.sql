SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetVisitedPage_Report]
@DashBoardStartDate DATETIME ,
@DashBoardEndDate DATETIME 

AS
BEGIN
SELECT
DISTINCT
   CASE CHARINDEX( '?', SessionURL)
       WHEN 0 THEN SessionURL 
       ELSE LEFT(SessionURL, CHARINDEX( '?', SessionURL) - 1) END AS VisitPage , COUNT(*) AS [VisitTime] 
FROM SessionTracker  WHERE SessionURL NOT LIKE '%Admin%' AND SessionURL NOT LIKE '%Super-User%' 
AND  [Start] BETWEEN @DashBoardStartDate AND @DashBoardEndDate 
GROUP BY SessionURL 
ORDER BY [VisitTime] DESC
END

/****** Object:  StoredProcedure [dbo].[usp_GetRefPage_Report]    Script Date: 12/17/2012 16:10:47 ******/
SET ANSI_NULLS ON





GO
