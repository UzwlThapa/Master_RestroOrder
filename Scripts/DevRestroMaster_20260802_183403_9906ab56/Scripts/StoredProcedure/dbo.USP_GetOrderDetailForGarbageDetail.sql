SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetOrderDetailForGarbageDetail] 
@tableID  int
as
BEGIN
SELECT      
 it.ITId as ItemId ,it.ITName, 
			od.OrderMasterId, od.OrderDetailsID, od.Quantity
			, od.Date, od.ROI_ItemId,  od.IsCombo
			, om.RoomId, om.TableId as restrotableId, 
              rt.restrotableTitle
FROM         dbo.RO_Order_Detail od 
				JOIN  ROI_ITEMMain it ON it.ITId = od.ROI_ItemId
				INNER JOIN RO_OrderMasters AS om ON om.OrderMasterID = od.OrderMasterId 
				INNER JOIN RO_OrderItemStatus AS os ON os.OrderDetailID = od.OrderDetailsID 
				INNER JOIN RO_ItemStatus AS iis ON iis.StatusID = os.StatusID 
				INNER JOIN RO_restroTable AS rt ON rt.restrotableId = om.TableId 
				--INNER JOIN RO_RestroRoom AS rm ON rm.RoomTypeID = rt.restroRoomId
WHERE         CONVERT(DATE, od.DATE) = CONVERT(DATE, getdate())
				and os.StatusID = 3
				and od.IsCancelled=0
				and isnull(od.BillPaid,0) = 0
				AND IsCombo = 0
				and (om.TableId = @tableID or @tableID=0)

				UNION 
SELECT DISTINCT
	cm.ComboID as ItemId,cm.NAME as ITName ,om.OrderMasterID as  OrderMasterId
	,od.OrderDetailsID ,od.Quantity, od.Date,od.ROI_ItemId,od.IsCombo
	, om.RoomId, om.TableId as restrotableId
	,rt.restrotableTitle
	--,CAST(LEFT(CONVERT(TIME(0), od.DATE), 5) AS VARCHAR(128)) AS billtime
FROM
	dbo.RO_Order_Detail od
JOIN RO_Combo cm ON cm.ComboID = od.ROI_ItemId
JOIN dbo.RO_OrderMasters om ON om.OrderMasterID = od.OrderMasterId
JOIN RO_OrderItemStatus os ON os.OrderDetailID = od.OrderDetailsID
JOIN dbo.RO_ItemStatus iis ON iis.StatusID = os.StatusID
LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
LEFT JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId = om.RoomId
WHERE CONVERT(DATE, od.DATE) = CONVERT(DATE, getdate())
	and os.StatusID = 3
	and od.IsCancelled=0
	and isnull(od.BillPaid,0) = 0
	AND IsCombo = 1
ORDER BY od.DATE DESC
END



			

GO
