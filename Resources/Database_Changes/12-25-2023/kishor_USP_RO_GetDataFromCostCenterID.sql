USE [RO-CHICKENSTATION]
GO

/****** Object:  StoredProcedure [dbo].[USP_RO_GetDataFromCostCenterID]    Script Date: 12/25/2023 4:45:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--[USP_RO_GetDataFromCostCenterID] 1

CREATE OR ALTER PROCEDURE [dbo].[USP_RO_GetDataFromCostCenterID] @CostCenterId INT
AS
SELECT DISTINCT it.ITId
	,
	-- ROI_ItemId as ItemId,  
	itd.ImagePath
	,od.OrderDetailsID
	,(od.Note + 'Extra : ' + stuff( (SELECT ','+ p2.ExtraItem + '('+CAST(p2.Quantity as varchar(10))  +')' 
               FROM RO_Order_ExtraItem p2
               WHERE p2.OrderDetailsID = od.OrderDetailsID
               ORDER BY OrderDetailsID
               FOR XML PATH(''), TYPE).value('.', 'varchar(max)')
            ,1,1,'')) as Note

	,iis.ItemStatus
	,iis.StatusID
	,od.ROI_ItemId
	,it.ITName
	,od.Quantity
	,om.BillPaid
	,od.IsCancelled
	,rr.restroRoom
	,rt.restrotableTitle
	,od.IsRunningOrder
	,od.DATE
	,CAST(LEFT(CONVERT(TIME(0), od.DATE), 5) AS VARCHAR(128)) AS billtime
	,om.OrderMasterID
	,om.UserName as Waiter
	,IsCombo = 0
	,od.SeatNo,
	itd.ItemCostCentreID
FROM ROI_ITEMMain it
JOIN dbo.RO_Order_Detail od ON it.ITId = od.ROI_ItemId
INNER JOIN ROI_ItemDetails itd ON it.ITId = itd.ITId
LEFT JOIN ROI_ItemRate ir ON it.ITId = ir.ItemID
JOIN dbo.RO_OrderMasters om ON om.OrderMasterID = od.OrderMasterId
JOIN RO_OrderItemStatus os ON os.OrderDetailID = od.OrderDetailsID
JOIN dbo.RO_ItemStatus iis ON iis.StatusID = os.StatusID
LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
LEFT JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId = om.RoomId
where CONVERT(DATE, od.DATE) = CONVERT(DATE, getdate())
	--AND om.BillPaid = 0
	--AND iis.StatusID != 3
	AND IsCombo = 0

UNION

SELECT DISTINCT
	--it.ITId,
	cm.ComboID
	,
	--ROI_ItemId as ItemId,  
	--itd.ImagePath,
	cm.ImagePath
	,od.OrderDetailsID
	,od.Note
	,iis.ItemStatus
	,iis.StatusID
	,od.ROI_ItemId
	--it.ITName,

	,cm.NAME
	,od.Quantity
	,om.BillPaid
	,od.IsCancelled
	,rr.restroRoom
	,rt.restrotableTitle
	,od.IsRunningOrder
	,od.DATE
	,CAST(LEFT(CONVERT(TIME(0), od.DATE), 5) AS VARCHAR(128)) AS billtime
	,om.OrderMasterID
	,om.UserName as Waiter
	,IsCombo = 1
	,od.SeatNo
	,od.SeatNo
FROM
	--ROI_ITEMMain it join
	dbo.RO_Order_Detail od
--ON it.ITId = od.ROI_ItemId
JOIN RO_Combo cm ON cm.ComboID = od.ROI_ItemId
--Inner Join ROI_ItemDetails itd ON it.ITId = itd.ITId
--left JOIN ROI_ItemRate ir ON it.ITId = ir.ItemID
JOIN dbo.RO_OrderMasters om ON om.OrderMasterID = od.OrderMasterId
JOIN RO_OrderItemStatus os ON os.OrderDetailID = od.OrderDetailsID
JOIN dbo.RO_ItemStatus iis ON iis.StatusID = os.StatusID
LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
LEFT JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId = om.RoomId
--WHERE itd.ItemCostCentreID=@CostCenterId AND om.BillPaid = 0 
where CONVERT(DATE, od.DATE) = CONVERT(DATE, getdate())
	--AND om.BillPaid = 0
	--AND iis.StatusID != 3
	AND IsCombo = 1
ORDER BY od.DATE DESC
GO

