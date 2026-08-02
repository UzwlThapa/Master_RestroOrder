SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetTopFiveBrowser]
@DashBoardStartDate DATETIME ,
@DashBoardEndDate DATETIME
AS
BEGIN
SELECT DISTINCT TOP(5)  SessionBrowser AS Browser , COUNT(*) AS [VisitTime] 
  FROM SessionTracker  WHERE [Start] BETWEEN @DashBoardStartDate AND @DashBoardEndDate
 GROUP BY SessionBrowser
ORDER BY [VisitTime] DESC
END





GO
