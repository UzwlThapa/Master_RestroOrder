SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ro_getOrderDetailByOrderMasterID] @OrderMasterID INT
AS
BEGIN
	SELECT od.ROI_ItemId AS ItemID
		,id.ITName AS Item
		,od.Quantity
		,om.UserName AS OrderBy
		,od.IsCombo
		,ois.StatusID as OrderStatus
	FROM RO_Order_Detail od
	INNER JOIN RO_OrderMasters om ON om.OrderMasterID = od.OrderMasterId
	INNER JOIN ROI_ITEMMain id ON id.ITId = od.ROI_ItemId
	inner join RO_OrderItemStatus ois on ois.OrderDetailID = od.OrderDetailsID
	WHERE od.OrderMasterId = @OrderMasterID
		AND od.IsCombo = 0
		and od.iscancelled=0
	
	UNION
	
	SELECT od.ROI_ItemId AS ItemID
		,rc.NAME AS Item
		,od.Quantity
		,om.UserName AS OrderBy
		,od.IsCombo
		,ois.StatusID as OrderStatus
	FROM RO_Order_Detail od
	INNER JOIN RO_OrderMasters om ON om.OrderMasterID = od.OrderMasterId
	INNER JOIN RO_Combo rc ON rc.ComboID = od.ROI_ItemId
	inner join RO_OrderItemStatus ois on ois.OrderDetailID = od.OrderDetailsID
	WHERE od.OrderMasterId = @OrderMasterID
		AND od.IsCombo = 1
		and od.iscancelled=0
END



GO
