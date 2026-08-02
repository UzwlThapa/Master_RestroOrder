SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetCountry_Report]
@DashBoardStartDate DATETIME ,
@DashBoardEndDate DATETIME 
AS
BEGIN
SELECT DISTINCT SessionUserHostAddress, COUNT(*) AS [VisitTime] 
  FROM SessionTracker
  WHERE [Start] BETWEEN @DashBoardStartDate AND @DashBoardEndDate
 GROUP BY SessionUserHostAddress 
ORDER BY [VisitTime] DESC
END


/****** Object:  StoredProcedure [dbo].[usp_GetBrowser_Report]    Script Date: 12/17/2012 16:10:33 ******/
SET ANSI_NULLS ON





GO
