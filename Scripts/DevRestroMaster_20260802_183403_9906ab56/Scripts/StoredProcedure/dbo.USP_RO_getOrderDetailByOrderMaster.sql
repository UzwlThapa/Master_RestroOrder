SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROC [USP_RO_getOrderDetailByOrderMaster]
--[USP_RO_getOrderDetailByOrderMaster] 7
CREATE PROCEDURE [dbo].[USP_RO_getOrderDetailByOrderMaster] @orderMasterId INT
AS
SELECT * FROM
(
SELECT DISTINCT --OD.OrderDetailsID
	SUM(OD.Quantity) Quantity
	,ISNULL(OD.Rate,0) AS Rate
	,SUM(OD.Amount) Amount
	,0 Bevrage
	,OD.ROI_ItemId
	,OD.OrderMasterId
	,Od.CostCenterId
	,CCG.GroupId
	,itm.NAME ITName
	,om.RoomId
	,om.BillNo
	,om.DATE
	,om.BasicAmount
	,om.TermAmount
	,om.Remarks
	,om.UserName AS Waiter
	,rt.restrotableId
	,rt.restrotableTitle
	,rt.restroRoomId
	,rm.restroRoom
	,1 AS IsCombo
	,ISNULL(om.GuestNo, 1) GuestNo
	,ISNULL(od.SeatNo, 1) SeatNo
	,OT.TokenNo
	,(
		SELECT STUFF((
SELECT '/' + restrotableTitle
FROM RO_restroTable mrt
INNER JOIN RO_MergeTable mtm ON mrt.restrotableId=mtm.TableID
WHERE mtm.MergeTableList =rt.restrotableId
FOR XML PATH('')
	,TYPE
).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
		) AS MergeTableName
				--,'' as ExtraItem
				--,0 as ExtraCharge
FROM RO_Order_Detail OD
INNER JOIN RO_OrderMasters OM ON OD.OrderMasterId = OM.OrderMasterID
INNER JOIN RO_Combo itm ON OD.ROI_ItemId = itm.ComboID
LEFT JOIN RO_OrderToken OT ON Ot.OrderMasterID=OM.OrderMasterID
--INNER JOIN RO_ComboDetails itd ON OD.ROI_ItemId = itm.ComboID        
--INNER JOIN ROI_ItemRate ir ON itm.ITId = ir.ItemID        
LEFT JOIN RO_restroTable rt ON rt.restrotableId = om.TableId
LEFT join RO_RestroRoom rm on rt.restroRoomId=rm.restroRoomId
Left JOIN CostCenterInfo CC on CC.CostCenterId = Od.CostCenterId
Left JOIN RO_CostCenterGroup CCG on CCG.GroupId = CC.GroupId
WHERE OD.OrderMasterId = @orderMasterId
	AND om.IsCancelled = 0
	AND OD.IsCancelled = 0
	AND OD.IsCombo = 1
	AND isnull(OD.BillPaid, 0) = 0
	AND OD.Quantity > 0
	group by OD.ROI_ItemId
	,OD.OrderMasterId
	,Od.CostCenterId
	,CCG.GroupId
	,itm.NAME 
	,om.RoomId
	,om.BillNo
	,om.GuestNo
	,od.SeatNo
	,om.DATE
	,OT.TokenNo
	,om.BasicAmount
	,om.TermAmount
	,om.Remarks
	,om.UserName 
	,rt.restrotableId
	,rt.restrotableTitle
	,rt.restroRoomId
	,rm.restroRoom
	,OD.Rate
UNION

SELECT --OD.OrderDetailsID
	--sum(isnull(oei.Quantity,OD.Quantity)) Quantity
	sum(OD.Quantity) Quantity
	,isnull(OD.Rate,0) as Rate
	,sum(CASE 
		WHEN itd.ItemCostCentreID = 1
			OR itd.ItemCostCentreID = 95
			OR itd.ItemCostCentreID = 97
			THEN od.Amount
		ELSE 0
		END) AS Amount
	,sum(CASE 
		WHEN itd.ItemCostCentreID = 2
			THEN od.Amount
		ELSE 0
		END) AS Bevrage
	,OD.ROI_ItemId
	,OD.OrderMasterId
	,Od.CostCenterId
	,CCG.GroupId
	,itm.ITName
	,om.RoomId
	,om.BillNo
	,om.DATE
	,om.BasicAmount
	,om.TermAmount
	,om.Remarks
	,om.UserName 
	,rt.restrotableId
	,rt.restrotableTitle
	,rt.restroRoomId
	,rm.restroRoom
	,0 AS IsCombo
	,isnull(om.GuestNo, 1) GuestNo
	,isnull(od.SeatNo, 1) SeatNo
	,OT.TokenNo
	,(
		SELECT STUFF((
SELECT '/' + restrotableTitle
FROM RO_restroTable mrt
inner join RO_MergeTable mtm on mrt.restrotableId=mtm.TableID
WHERE mtm.MergeTableList =rt.restrotableId
FOR XML PATH('')
	,TYPE
).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
		) AS MergeTableName
				--,isnull(oei.ExtraItem,'') as ExtraItem
				--,ISNULL(oei.ExtraPrice,0) as ExtraCharge

FROM RO_Order_Detail OD
INNER JOIN RO_OrderMasters OM ON OD.OrderMasterId = OM.OrderMasterID
INNER JOIN ROI_ITEMMain itm ON OD.ROI_ItemId = itm.ITId
INNER JOIN ROI_ItemDetails itd ON OD.ROI_ItemId = itd.ITId
INNER JOIN ROI_ItemRate ir ON itm.ITId = ir.ItemID
LEFT JOIN RO_OrderToken OT ON Ot.OrderMasterID=OM.OrderMasterID
--left join RO_Order_ExtraItem oei on oei.OrderDetailsID=OD.OrderDetailsID
LEFT JOIN RO_restroTable rt ON rt.restrotableId = om.TableId
LEFT join RO_RestroRoom rm on rt.restroRoomId=rm.restroRoomId
Left JOIN CostCenterInfo CC on CC.CostCenterId = Od.CostCenterId
Left JOIN RO_CostCenterGroup CCG on CCG.GroupId = CC.GroupId
WHERE OD.OrderMasterId = @orderMasterId
	AND om.IsCancelled = 0
	AND OD.IsCancelled = 0
	AND OD.IsCombo = 0
	AND isnull(OD.BillPaid, 0) = 0
	AND OD.Quantity > 0
	group by OD.ROI_ItemId
	,OD.OrderMasterId
	,Od.CostCenterId
	,CCG.GroupId
	,itm.ITName
	,om.RoomId
	,om.BillNo
	,om.DATE
	,om.GuestNo
	,OT.TokenNo
	,od.SeatNo
	,om.BasicAmount
	,om.TermAmount
	,om.Remarks
	,om.UserName 
	,rt.restrotableId
	,rt.restrotableTitle
	,rt.restroRoomId
	,rm.restroRoom
	,OD.Rate
	--,oei.ExtraItem
			--	,oei.ExtraPrice
	
	) x
	ORDER BY GroupId

GO
