SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [USP_RO_GetPreviousItemByID] 23
-- @ID = TableId
--DROP PROCEDURE USP_RO_GetPreviousItemByID 85
CREATE PROCEDURE [dbo].[USP_RO_GetPreviousItemByID]  
@ID INT 
AS
	DECLARE @val VARCHAR(90)

		SET @val = dbo.fn_getMaxMasterId(@ID)

	SELECT ITName AS ItemName
		,ROI_ItemID AS ItemId
		,sum(OD.Quantity) as Quantity
		,OD.ExtraItem
		,OD.SeatNo
		,OD.OrderMasterId
		,om.TableId
		,iss.ItemStatus
		--,od.ExtraCharge
		,isnull(om.GuestNo, 1) GuestNo
		,om.UserName  as Waiter	
		,(SELECT  t1.Note +CASE WHEN t1.Note IS NOT NULL AND t1.Note<>'' THEN '('+ CAST(t1.Quantity as VARCHAR(3))+');' END
		FROM RO_Order_Detail t1
		WHERE (t1.OrderMasterId=od.OrderMasterId and t1.ROI_ItemID = od.ROI_ItemID and t1.iscancelled=0 and t1.IsCombo=0) 
		FOR XML PATH('')) AS  Note
		,od.BillPaid
		,om.IsSplit
		,0 isCombo
		,id.IsOutOfStock
		,ot.CustomerID
		,ot.CustomerName
		,ot.Phone
		,isnull(ot.TokenNo,0) TokenNo 
		,isnull(om.OrderNo,0) OrderNo
		,isnull(od.Rate,ir.SRate) SRate
		,ot.Address
		--,od.OrderDetailsID
	FROM RO_Order_Detail od
	INNER JOIN RO_OrderMasters om ON od.OrderMasterId = om.OrderMasterId
	INNER JOIN ROI_ITEMMain im ON im.ITId = od.ROI_ItemId
	INNER JOIN ROI_ItemDetails id ON im.ITId = id.ITId
	LEFT JOIN dbo.RO_OrderItemStatus os ON os.OrderDetailID = od.OrderDetailsID
	LEFT JOIN dbo.RO_ItemStatus iss ON iss.StatusID = os.StatusID
	LEFT JOIN RO_OrderToken ot on ot.OrderMasterId = om.OrderMasterId
	LEFT JOIN ROI_ItemRate ir on ir.ItemID = im.ITId
	WHERE om.TableId = @ID
		AND isnull(od.BillPaid,0) = 0
		AND om.BillPaid = 0
		and od.IsCancelled = 0
		AND om.IsCancelled = 0
		AND om.OrderMasterID = @val
		AND od.Quantity > 0
		AND ISCombo = 0
		and od.Quantity > 0
	group by ITName 
		,ROI_ItemID 
		,OD.ExtraItem
		,OD.SeatNo
		,om.GuestNo
		,OD.OrderMasterId
		,om.TableId
		,om.UserName
		,iss.ItemStatus
		,od.BillPaid
		,om.IsSplit
		,id.IsOutOfStock
		,ot.CustomerID
		,ot.CustomerName
		,ot.Phone
		,ot.TokenNo
		,om.OrderNo
		,od.Rate
		,ot.Address
		,ir.SRate
		--,od.OrderDetailsID
	UNION
	
	SELECT NAME AS ItemName
		,ROI_ItemID AS ItemId
		,sum(OD.Quantity) as Quantity
		,OD.ExtraItem
		,OD.SeatNo
		,OD.OrderMasterId
		,om.TableId
		,iss.ItemStatus
		,isnull(om.GuestNo, 1) GuestNo
		,om.UserName as Waiter
		,(SELECT  t1.Note +CASE WHEN t1.Note IS NOT NULL AND t1.Note<>'' THEN '('+ CAST(t1.Quantity as VARCHAR(3))+');' END
    FROM RO_Order_Detail t1
    WHERE (t1.OrderMasterId=od.OrderMasterId and t1.ROI_ItemID = od.ROI_ItemID and t1.iscancelled=0 and t1.IsCombo=1) 
    FOR XML PATH('')) AS  Note
		,od.BillPaid
		,om.IsSplit
		,1 isCombo
		,0 as IsOutOfStock
		,ot.CustomerID
		,ot.CustomerName
		,ot.Phone
		,isnull(ot.TokenNo,0) TokenNo 
		,isnull(om.OrderNo,0) OrderNo
		,isnull(od.Rate,ir.SRate) SRate
		,ot.Address
		--,od.OrderDetailsID
	FROM RO_Order_Detail od
	INNER JOIN RO_OrderMasters om ON od.OrderMasterId = om.OrderMasterId
	INNER JOIN RO_Combo cm ON cm.ComboID = od.ROI_ItemId
	LEFT JOIN dbo.RO_OrderItemStatus os ON os.OrderDetailID = od.OrderDetailsID
	LEFT JOIN dbo.RO_ItemStatus iss ON iss.StatusID = os.StatusID
	LEFT JOIN RO_OrderToken ot on ot.OrderMasterId = om.OrderMasterId
		LEFT JOIN ROI_ItemRate ir on ir.ItemID = od.ROI_ItemId
	WHERE om.TableId = @ID
		AND om.BillPaid = 0
		AND isnull(od.BillPaid,0) = 0
		and od.IsCancelled = 0
		AND om.IsCancelled = 0
		AND om.OrderMasterID = @val
		AND ISCombo = 1
		and od.Quantity > 0
		group by NAME
		,ROI_ItemID 
		,OD.ExtraItem
		,OD.SeatNo
		,OD.OrderMasterId
		,om.GuestNo
		,om.TableId
		,iss.ItemStatus
		,om.UserName
		,od.BillPaid
		,om.IsSplit
		,ot.CustomerID
		,ot.CustomerName
		,ot.Phone
		,ot.TokenNo
		,om.OrderNo
		,od.Rate
		,ot.Address
		,ir.SRate
		--,od.OrderDetailsID

GO
