SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_getOrderDetailByBillNo] @BillNo nvarchar(128)
AS
SELECT DISTINCT OD.OrderDetailsID
	,OD.Quantity
	,OD.Rate
	,OD.Amount
	,0 Bevrage
	,OD.IsCancelled
	,OD.ROI_ItemId
	,OD.OrderMasterId
	,OD.SeatNo
	,OD.Note
	,OD.ExtraCharge
	,OD.BillPaid
	,OD.NetAmount
	,Od.CostCenterId
	,itm.NAME ITName
	,itm.ImagePath
	,itm.SalesPrice SRate
	,itm.ComboCode ITCode
	,0 DSUnitId
	,0 PITId
	,om.RoomId
	,om.BillNo
	,om.DATE
	,om.BasicAmount
	,om.TermAmount
	,om.Remarks
	,om.UserName as Waiter
	,om.IsSplit
	,om.GuestNo
	,rt.restrotableId
	,rt.restrotableTitle
	,rt.restroRoomId
	,rt.restrotablesStatusID
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
FROM RO_OrderMasters OM
INNER JOIN RO_Order_Detail OD ON OD.OrderMasterId = OM.OrderMasterID
INNER JOIN RO_Combo itm ON OD.ROI_ItemId = itm.ComboID
--INNER JOIN RO_ComboDetails itd ON OD.ROI_ItemId = itm.ComboID        
--INNER JOIN ROI_ItemRate ir ON itm.ITId = ir.ItemID        
LEFT JOIN RO_restroTable rt ON rt.restrotableId = om.TableId
LEFT join RO_RestroRoom rm on rt.restroRoomId=rm.restroRoomId
WHERE OM.BillNo = @BillNo
	AND om.IsCancelled = 0
	AND OD.IsCombo = 1
	AND isnull(OD.BillPaid, 0) = 0

	UNION

SELECT OD.OrderDetailsID
	,OD.Quantity
	,OD.Rate
	,CASE 
		WHEN itd.ItemCostCentreID = 1
			OR itd.ItemCostCentreID = 95
			OR itd.ItemCostCentreID = 97
			THEN od.Amount
		ELSE 0
		END AS Amount
	,CASE 
		WHEN itd.ItemCostCentreID = 2
			THEN od.Amount
		ELSE 0
		END AS Bevrage
	,OD.IsCancelled
	,OD.ROI_ItemId
	,OD.OrderMasterId
	,OD.SeatNo
	,OD.Note
	,OD.ExtraCharge
	,OD.BillPaid
	,OD.NetAmount
	,Od.CostCenterId
	,itm.ITName
	,itd.ImagePath
	,ir.SRate
	,itd.ITCode
	,itd.DSUnitId
	,itm.PITId
	,om.RoomId
	,om.BillNo
	,om.DATE
	,om.BasicAmount
	,om.TermAmount
	,om.Remarks
	,om.UserName as Waiter
	,om.IsSplit
	,om.GuestNo
	,rt.restrotableId
	,rt.restrotableTitle
	,rt.restroRoomId
	,rt.restrotablesStatusID
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
FROM RO_OrderMasters OM
INNER JOIN RO_Order_Detail OD ON OD.OrderMasterId = OM.OrderMasterID
INNER JOIN ROI_ITEMMain itm ON OD.ROI_ItemId = itm.ITId
INNER JOIN ROI_ItemDetails itd ON OD.ROI_ItemId = itd.ITId
INNER JOIN ROI_ItemRate ir ON itm.ITId = ir.ItemID
LEFT JOIN RO_restroTable rt ON rt.restrotableId = om.TableId
LEFT join RO_RestroRoom rm on rt.restroRoomId=rm.restroRoomId
WHERE OM.BillNo = @BillNo
	AND om.IsCancelled = 0
	AND OD.IsCombo = 0
	AND isnull(OD.BillPaid, 0) = 0





GO
