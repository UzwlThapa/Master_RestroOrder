SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SALSEREPORTBYWEEKLY] @FromDate DATETIME
	--@ToDate DateTime
AS
BEGIN
	SELECT BillDate
		,om.NetAmount
		,om.Waiter
		,rt.restrotableTitle
		,rr.restroRoom
		--,om.billNo
		,'RO' + fy.fyName + '-' + cast((om.salesMasterId - fy.FirstSalesMasterID) AS VARCHAR(20)) AS billNo
		,om.TableId
		,salesMasterId
		,om.OrderMasterId
		,om.PrintCount
	FROM dbo.RO_SalesMaster om
	JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
	LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = om.RoomId
	INNER JOIN RO_fiscalYear fy ON fy.fyId = om.FiscalYearID
	WHERE cast(BillDate AS DATE) BETWEEN DateAdd(DD, - 7, @FromDate)
			AND @FromDate
		AND IsArchived = 0
END



GO
