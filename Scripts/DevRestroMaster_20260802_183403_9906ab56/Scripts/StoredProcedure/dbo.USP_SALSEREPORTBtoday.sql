SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SALSEREPORTBtoday] @Todaydate DATETIME
AS
BEGIN
	SELECT cast(CONVERT(VARCHAR(16), om.BillDate, 20) AS VARCHAR(120)) AS BillDate
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
	LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
	LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = om.RoomId
	INNER JOIN RO_fiscalYear fy ON fy.fyId = om.FiscalYearID
	WHERE cast(om.BillDate AS DATE) = @Todaydate
		AND IsArchived = 0
	ORDER BY BillDate DESC
		-- where CONVERT(date,om.BillDate)=CONVERT(DATE,getdate())
END



GO
