SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_GetOrderedExtraItemByOrderMaster] @OrderMasterId INT
AS
BEGIN
	SELECT oe.OrderMasterId
		,oe.ItemID
		,oe.ExtraItemID
		,oe.ExtraItem
		,sum(oe.Quantity) AS Quantity
		,oe.ExtraPrice
		,its.ItemStatus
		,oe.SeatNo
	FROM RO_Order_ExtraItem oe
	JOIN RO_Order_Detail od ON od.OrderDetailsID = oe.OrderDetailsID
	JOIN RO_OrderItemStatus ois ON od.OrderDetailsID = ois.OrderDetailID
	JOIN RO_ItemStatus its ON ois.StatusID = its.StatusID
	WHERE oe.OrderMasterId = @OrderMasterId
		AND od.IsCancelled = 0
		--AND ois.StatusID = 1
	GROUP BY oe.OrderMasterId
		,oe.ItemID
		,oe.ExtraItemID
		,oe.ExtraItem
		,oe.ExtraPrice
		,oe.SeatNo
		,its.ItemStatus
		order by oe.ExtraItem asc
END


GO
