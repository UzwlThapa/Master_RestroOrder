SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_getOrderDetailByOrderMaster_bkup] @orderMasterId INT
AS
SELECT DISTINCT --OD.OrderDetailsID
	sum(OD.Quantity) Quantity
	,OD.Rate
	,sum(OD.Amount) Amount
	,0 Bevrage
	,OD.ROI_ItemId
	,OD.OrderMasterId
	,Od.CostCenterId
	,itm.NAME ITName
	,om.RoomId
	,om.BillNo
	,om.DATE
	,om.BasicAmount
	,om.TermAmount
	,om.Remarks
	,om.UserName as Waiter
	,rt.restrotableId
	,rt.restrotableTitle
	,rt.restroRoomId
	,rm.restroRoom
	,1 AS IsCombo
	,(
				SELECT STUFF((
							SELECT '/' + restrotableTitle
							FROM RO_restroTable
							WHERE restrotableId IN (
									SELECT TableID
									FROM RO_MergeTable
									WHERE MergeTableList = (
											SELECT MergeTableList
											FROM RO_MergeTable
											WHERE TableID = rt.restrotableId
												AND MergeTableList != 0
											)
									)
							FOR XML PATH('')
								,TYPE
							).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
				) AS MergeTableName
				--,'' as ExtraItem
				--,0 as ExtraCharge
FROM RO_Order_Detail OD
INNER JOIN RO_OrderMasters OM ON OD.OrderMasterId = OM.OrderMasterID
INNER JOIN RO_Combo itm ON OD.ROI_ItemId = itm.ComboID
--INNER JOIN RO_ComboDetails itd ON OD.ROI_ItemId = itm.ComboID        
--INNER JOIN ROI_ItemRate ir ON itm.ITId = ir.ItemID        
LEFT JOIN RO_restroTable rt ON rt.restrotableId = om.TableId
LEFT join RO_RestroRoom rm on rt.restroRoomId=rm.restroRoomId
WHERE OD.OrderMasterId = @orderMasterId
	AND om.IsCancelled = 0
	AND OD.IsCancelled = 0
	AND OD.IsCombo = 1
	AND isnull(OD.BillPaid, 0) = 0
	group by OD.ROI_ItemId
	,OD.OrderMasterId
	,Od.CostCenterId
	,itm.NAME 
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
	,OD.Rate
UNION

SELECT --OD.OrderDetailsID
	--sum(isnull(oei.Quantity,OD.Quantity)) Quantity
	sum(OD.Quantity) Quantity
	,OD.Rate
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
	,(
				SELECT STUFF((
							SELECT '/' + restrotableTitle
							FROM RO_restroTable
							WHERE restrotableId IN (
									SELECT TableID
									FROM RO_MergeTable
									WHERE MergeTableList = (
											SELECT MergeTableList
											FROM RO_MergeTable
											WHERE TableID = rt.restrotableId
												AND MergeTableList != 0
											)
									)
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
--left join RO_Order_ExtraItem oei on oei.OrderDetailsID=OD.OrderDetailsID
LEFT JOIN RO_restroTable rt ON rt.restrotableId = om.TableId
LEFT join RO_RestroRoom rm on rt.restroRoomId=rm.restroRoomId
WHERE OD.OrderMasterId = @orderMasterId
	AND om.IsCancelled = 0
	AND OD.IsCancelled = 0
	AND OD.IsCombo = 0
	AND isnull(OD.BillPaid, 0) = 0

	group by OD.ROI_ItemId
	,OD.OrderMasterId
	,Od.CostCenterId
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
	,OD.Rate
	--,oei.ExtraItem
			--	,oei.ExtraPrice
	

GO
