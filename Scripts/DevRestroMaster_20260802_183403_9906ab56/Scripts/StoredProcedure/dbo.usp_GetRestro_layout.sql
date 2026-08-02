SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetRestro_layout] 
@UserModuleID int
As begin 
--select rl.id, rl.RoomID, rl.TableID, rt.restrotableTitle, rm.restroRoom from Restro_Layout rl 
--inner join RO_restroTable rt on rl.TableID = rt.restrotableId
--inner join RO_RestroRoom rm on rm.restroRoomId = rl.RoomID where rl.UserModuleID = @UserModuleID


IF OBJECT_ID('tempdb..#MaxOrderMaster') IS NOT NULL
	DROP TABLE #MaxOrderMaster

IF OBJECT_ID('tempdb..#RoomBooking') > 0
	DROP TABLE #RoomBooking


SELECT om.TableId
	,MaX(om.OrderMasterID) OrderMasterId
INTO #MaxOrderMaster
FROM dbo.RO_OrderMasters om
where isnull(BillPaid,0)=0 and isnull(IsCancelled,0)=0
GROUP BY TableId

SELECT rb.TableId,  rb.OrderMasterId, rb.BookedFrom, rb.BookedTo
INTO #RoomBooking
FROM Ro_RoomBookings rb
INNER JOIN (
		SELECT rb.TableId,MAX(rb.OrderMasterId) OrderMasterId
		FROM Ro_RoomBookings rb
		INNER JOIN RO_OrderMasters om ON om.OrderMasterID = rb.OrderMasterId
		WHERE rb.BookedFrom <= GETDATE()
			AND rb.BookedTo >= GETDATE()
			AND om.BillPaid != 1
			AND om.IsCancelled != 1
		GROUP BY rb.TableId
		) as mrb 
		ON rb.TableId=mrb.TableId and rb.OrderMasterId=mrb.OrderMasterId



SELECT rt.restrotableId, rt.restrotableTitle, rt.restroRoomId, 
--CASE WHEN om.OrderCount >0 THEN 7 ELSE rt.restrotablesStatusID END restrotablesStatusID, 
rt.restrotablesStatusID,
rt.Seatcap, rt.IsTable, rt.Rate
	,convert(CHAR(5), Coalesce(om.[DATE], rb.BookedFrom), 108) TableTime
	,coalesce(om.[Date], rb.BookedFrom) TableDate
	,(case when (rt.restrotablesStatusID = 7 and om.BillPaid is null and rt.IsTable=1) then 1
	   when (rt.restrotablesStatusID = 7 and (GETDATE() BETWEEN rb.BookedFrom AND rb.BookedTo)) THEN 0
	else isnull(om.BillPaid,0) end) as BillPaid
	,isnull(om.IsCancelled, 0) as IsCancelled
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
	,rb.OrderMasterId
	,om.GuestNo
	,isnull(rl.UserModuleID, 0) as UserModuleID
FROM dbo.RO_restroTable rt
INNER JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId = rt.restroRoomId
LEFT JOIN dbo.RO_MergeTable mt ON mt.TableID = rt.restrotableId
LEFT JOIN (
	SELECT m.OrderMasterID, m.TableId,m.BillPaid, m.[Date], m.IsCancelled, count(d.OrderDetailsID) as OrderCount,m.GuestNo
	FROM dbo.RO_OrderMasters m
	INNER JOIN #MaxOrderMaster mom ON mom.TableId = m.TableId
	INNER JOIN RO_Order_Detail d on d.OrderMasterId=mom.OrderMasterID and d.IsCancelled=0
		AND mom.OrderMasterId = m.OrderMasterID
	GROUP BY m.OrderMasterID, m.TableId,m.BillPaid, m.[Date], m.IsCancelled,m.GuestNo
	) om ON om.TableId = rt.restrotableid
LEFT JOIN #RoomBooking rb ON rt.restrotableId = rb.TableId
LEFT JOIN dbo.RO_restroTable mrt ON mrt.restrotableId = mt.MergeTableList
Inner JOIN  Restro_Layout rl on rl.TableID = rt.restrotableId
where rl.UserModuleID = @UserModuleID
END

GO
