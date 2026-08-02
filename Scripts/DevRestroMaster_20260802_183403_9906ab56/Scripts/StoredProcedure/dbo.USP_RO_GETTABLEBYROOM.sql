SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_RO_GETTABLEBYROOM] 3
CREATE PROCEDURE [dbo].[USP_RO_GETTABLEBYROOM] (@RoomID INT)
AS
BEGIN
	IF OBJECT_ID('tempdb..#MaxOrderMaster') IS NOT NULL
		DROP TABLE #MaxOrderMaster

	IF OBJECT_ID('tempdb..#RoomBooking') > 0
		DROP TABLE #RoomBooking

	SELECT TableId
		,MaX(OrderMasterID) OrderMasterId
	INTO #MaxOrderMaster
	FROM dbo.RO_OrderMasters
	WHERE isnull(BillPaid, 0) = 0
		AND isnull(IsCancelled, 0) = 0
	GROUP BY TableId

	SELECT rb.TableId
		,MAX(rb.OrderMasterId) OrderMasterId
	INTO #RoomBooking
	FROM Ro_RoomBookings rb
	INNER JOIN RO_OrderMasters om ON om.OrderMasterID = rb.OrderMasterId
	WHERE rb.BookedFrom <= GETDATE()
		AND rb.BookedTo >= GETDATE()
		AND om.BillPaid != 1
		AND om.IsCancelled != 1
	GROUP BY rb.TableId

	SELECT rt.*
		,convert(CHAR(5), om.[DATE], 108) TableTime
		,om.[Date] TableDate
		,(
			CASE 
				WHEN (
						rt.restrotablesStatusID = 7
						AND om.BillPaid IS NULL
						)
					THEN 1
				ELSE isnull(om.BillPaid, 0)
				END
			) AS BillPaid
		,om.IsCancelled
		,rr.restroRoom
		,mt.MergeID
		,mt.TableID
		,rt.IsTable
		,isnull(mt.MergeTableList, 0) AS MergeTableList
		,(
			SELECT STUFF((
						SELECT '/' + restrotableTitle
						FROM RO_restroTable mrt
						INNER JOIN RO_MergeTable mtm ON mrt.restrotableId = mtm.TableID
						WHERE mtm.MergeTableList = mt.TableID
						FOR XML PATH('')
							,TYPE
						).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
			) AS MergeTableName
	,isnull(rb.OrderMasterId, omm.OrderMasterId) OrderMasterId
	,om.GuestNo
	FROM dbo.RO_restroTable rt
	INNER JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId = rt.restroRoomId
	LEFT JOIN dbo.RO_MergeTable mt ON mt.TableID = rt.restrotableId
	LEFT JOIN (
		SELECT m.*
		FROM dbo.RO_OrderMasters m
		INNER JOIN #MaxOrderMaster mom ON mom.TableId = m.TableId
			AND mom.OrderMasterId = m.OrderMasterID
		) om ON om.TableId = rt.restrotableid
	LEFT JOIN #RoomBooking rb ON rt.restrotableId = rb.TableId
	Left JOIN #MaxOrderMaster omm ON omm.TableId = rt.restrotableId 
	LEFT JOIN dbo.RO_restroTable mrt ON mrt.restrotableId = mt.MergeTableList
	WHERE rt.restroRoomId = @RoomID
END

GO
