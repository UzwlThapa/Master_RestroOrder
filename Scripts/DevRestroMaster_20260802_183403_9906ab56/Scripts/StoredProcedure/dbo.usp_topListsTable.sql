SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_topListsTable]
AS
DECLARE @date DATE

SET @date = (
		CASE 
			WHEN cast(getdate() AS TIME) > '4:00'
				THEN cast(getdate() AS DATE)
			ELSE cast(dateadd(day, - 1, getdate()) AS DATE)
			END
		)

SELECT TOP 6 rt.restrotableTitle
	,count(rt.restrotableTitle) AS cntTable
FROM RO_SalesMaster sm
LEFT JOIN RO_restroTable rt ON rt.restrotableId = sm.TableId
WHERE (
		sm.BillDate BETWEEN DATEADD(hour, 4, cast(@date AS DATETIME))
			AND DATEADD(hour, 28, cast(@date AS DATETIME))
		)
GROUP BY rt.restrotableTitle
ORDER BY cntTable DESC

GO
