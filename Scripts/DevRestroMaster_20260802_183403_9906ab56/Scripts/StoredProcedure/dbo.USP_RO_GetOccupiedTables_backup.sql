SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GetOccupiedTables_backup]
@isTable bit
AS
SELECT DISTINCT rr.*
	,r.restroRoom
	,(
		SELECT TOP (1) convert(CHAR(5), DATE, 108) [time]
		FROM dbo.RO_OrderMasters
		WHERE TableId = rr.restrotableId
			AND BillPaid != 1
			AND IsCancelled != 1
		ORDER BY OrderMasterID DESC
		) AS tabletime
	,(
		SELECT TOP (1) DATE
		FROM dbo.RO_OrderMasters
		WHERE TableId = rr.restrotableId
			AND BillPaid != 1
			AND IsCancelled != 1
		ORDER BY OrderMasterID DESC
		) AS tableDate
	,mt.*
	,(
		SELECT STUFF((
SELECT '/' + restrotableTitle
FROM RO_restroTable mrt
inner join RO_MergeTable mtm on mrt.restrotableId=mtm.TableID
WHERE mtm.MergeTableList =rr.restrotableId
FOR XML PATH('')
	,TYPE
).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
		) AS MergeTableName
	,(
		SELECT TOP (1) OrderMasterId
		FROM dbo.RO_OrderMasters
		WHERE TableId = rr.restrotableId
			AND BillPaid != 1
			AND IsCancelled != 1
		ORDER BY OrderMasterID DESC
		) AS OrderMasterId
FROM dbo.RO_restroTable rr
inner join RO_RestroRoom r on r.restroRoomId=rr.restroRoomId
INNER JOIN dbo.RO_OrderMasters om ON om.TableId = rr.restrotableId
INNER JOIN ro_order_detail od ON om.OrderMasterID = od.OrderMasterId
LEFT JOIN dbo.RO_MergeTable mt ON mt.TableID = rr.restrotableId
WHERE om.BillPaid = 0
	AND rr.restrotableId != 0
	AND om.IsCancelled = 0
	AND om.OrderMasterID = dbo.fn_getMaxMasterId(rr.restrotableId)
	and rr.IsTable=@isTable



GO
