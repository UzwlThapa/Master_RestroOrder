SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetBrowser_Report]
@DashBoardStartDate DATETIME ,
@DashBoardEndDate DATETIME 
AS
BEGIN
SELECT DISTINCT  SessionBrowser AS Browser, COUNT(*) AS [VisitTime] 
FROM SessionTracker WHERE [Start] BETWEEN @DashBoardStartDate AND @DashBoardEndDate
 GROUP BY SessionBrowser
ORDER BY [VisitTime] DESC
END





GO
