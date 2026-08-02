SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetRefPage_Report] --'2009/01/01' , '2015/01/01' 
@DashBoardStartDate DATETIME ,
@DashBoardEndDate DATETIME 
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


 SELECT DISTINCT RefPage, COUNT(*) AS [VisitTime]  FROM @Temp1
  GROUP BY RefPage
ORDER BY [VisitTime] DESC 
 END





GO
