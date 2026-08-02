SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_topLists]
AS
DECLARE @date DATE

SET @date = (
		CASE 
			WHEN cast(getdate() AS TIME) > '4:00'
				THEN cast(getdate() AS DATE)
			ELSE cast(dateadd(day, - 1, getdate()) AS DATE)
			END
		)

DECLARE @tbl TABLE (
	itname NVARCHAR(max)
	,cntItem DECIMAL(10, 2)
	,[order] INT
	)

INSERT INTO @tbl
SELECT 'Total' AS itname
	,sum(od.Quantity) AS cntItem
	,1 AS [order]
FROM ro_order_detail od
WHERE (
		od.DATE BETWEEN DATEADD(hour, 4, cast(@date AS DATETIME))
			AND DATEADD(hour, 28, cast(@date AS DATETIME))
		)
	AND od.IsCancelled = 0

--UNION
INSERT INTO @tbl
SELECT TOP 6 i.itname
	,sum(od.Quantity) AS cntItem
	,2 AS [order]
FROM ro_order_detail od
LEFT JOIN ROI_ITEMMain I ON I.ITId = od.ROI_ItemId
WHERE (
		od.DATE BETWEEN DATEADD(hour, 4, cast(@date AS DATETIME))
			AND DATEADD(hour, 28, cast(@date AS DATETIME))
		)
	AND od.IsCancelled = 0
GROUP BY i.itname
--ORDER BY Count(DISTINCT i.ITId) desc
ORDER BY cntItem DESC

--,[order] ASC
SELECT *
FROM @tbl

GO
