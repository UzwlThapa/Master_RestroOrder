SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_CancelledBillBYWEEKLY] @FromDate DATETIME
	--@ToDate DateTime
AS
BEGIN
	SELECT BillDate
		,om.NetAmount
		,om.Waiter
		,rt.restrotableTitle
		,rr.restroRoom
		,om.billNo
		,om.TableId
		,salesMasterId
		,om.OrderMasterId
		--,om.PrintCount
		,om.Reasons
		,om.ArchivedBy
		,om.IsArchived
		,cast(om.ArchivedOn AS DATE) AS ArchivedOn
	FROM dbo.RO_SalesMaster om
	JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
	LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = om.RoomId
	WHERE cast(ArchivedOn AS DATE) BETWEEN DateAdd(DD, - 7, @FromDate)
			AND @FromDate
		AND IsArchived = 1
END





GO
