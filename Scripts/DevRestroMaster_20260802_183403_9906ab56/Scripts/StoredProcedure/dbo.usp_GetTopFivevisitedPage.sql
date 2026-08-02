SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetTopFivevisitedPage]
@DashBoardStartDate DATETIME,
@DashBoardEndDate DATETIME 
AS
BEGIN 


SELECT TOP(5) SessionUserHostAddress AS Country , COUNT(*) AS [VisitTime] 
  FROM SessionTracker
WHERE [Start] BETWEEN @DashBoardStartDate AND @DashBoardEndDate
 GROUP BY SessionUserHostAddress 
ORDER BY [VisitTime] DESC
END





GO
