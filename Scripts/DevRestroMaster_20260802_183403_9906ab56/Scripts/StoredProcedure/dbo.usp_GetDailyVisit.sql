SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetDailyVisit] 
@DashBoardStartDate DATETIME ,
@DashBoardEndDate DATETIME
AS
BEGIN
SELECT   DATENAME(YEAR,[start]) +  '-' + CAST(DATEPART(MONTH,[start])
AS NVARCHAR(4))+  '-' + CAST(DATEPART(DAY,[start]) 
         AS VARCHAR(4)) AS VisitedDate,
        COUNT(*) AS [VisitTime]
        FROM    SessionTracker  
        WHERE [start] BETWEEN @DashBoardStartDate AND @DashBoardEndDate
        GROUP BY  DATENAME(YEAR,[start]) +  '-' +CAST(DATEPART(MONTH,[start])
AS NVARCHAR(4)) + '-' + CAST(DATEPART(DAY,[start]) AS VARCHAR(4))
ORDER BY [VisitTime]
DESC
END





GO
