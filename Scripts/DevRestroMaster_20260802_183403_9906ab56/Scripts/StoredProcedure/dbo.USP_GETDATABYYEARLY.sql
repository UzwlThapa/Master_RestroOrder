SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GETDATABYYEARLY] @year VARCHAR(10)
AS
BEGIN
	SELECT om.BillDate
		,om.NetAmount
		,om.Waiter
		,rt.restrotableTitle
		,rr.restroRoom
		,'RO' + fy.fyName + '-' + cast((om.salesMasterId - fy.FirstSalesMasterID) AS VARCHAR(20)) AS billNo
		,om.TableId
		,salesMasterId
		,om.OrderMasterId
		,om.PrintCount
	FROM dbo.RO_SalesMaster om
	LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
	LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = om.RoomId
	INNER JOIN RO_fiscalYear fy ON fy.fyId = om.FiscalYearID
	--where EXTRACT(Year FROM om.Date), EXTRACT(Month FROM om.Date)  = '2015-11'
	WHERE Year(om.BillDate) = @year
		AND om.IsArchived = 0
END



GO
