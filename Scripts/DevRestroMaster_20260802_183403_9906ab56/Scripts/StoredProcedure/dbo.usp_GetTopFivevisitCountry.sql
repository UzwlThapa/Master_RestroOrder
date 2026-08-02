SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetTopFivevisitCountry]
@DashBoardStartDate NVARCHAR(50),
@DashBoardEndDate NVARCHAR(50) 
AS
BEGIN 


SELECT TOP(5) SessionUserHostAddress AS Country , COUNT(*) AS [VisitTime] 
  FROM SessionTracker
WHERE [Start] BETWEEN GETDATE()-20 AND GETDATE()
 GROUP BY SessionUserHostAddress 
ORDER BY [VisitTime] DESC
END





GO
