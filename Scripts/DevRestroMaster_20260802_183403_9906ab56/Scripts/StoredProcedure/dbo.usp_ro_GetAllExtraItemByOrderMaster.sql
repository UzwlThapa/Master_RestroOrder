SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ro_GetAllExtraItemByOrderMaster] @OrderMasterId INT
AS
BEGIN
	SELECT oe.OrderMasterId
		,oe.ItemID
		,oe.ExtraItemID
		,oe.ExtraItem
		,sum(oe.Quantity) AS Quantity
		,oe.ExtraPrice
		,oe.SeatNo
	FROM RO_Order_ExtraItem oe
	JOIN RO_Order_Detail od ON od.OrderDetailsID = oe.OrderDetailsID and od.SeatNo = oe.SeatNo
	JOIN RO_OrderItemStatus ois ON od.OrderDetailsID = ois.OrderDetailID
	WHERE oe.OrderMasterId = @OrderMasterId
		AND od.IsCancelled = 0
	GROUP BY oe.OrderMasterId
		,oe.ItemID
		,oe.ExtraItemID
		,oe.ExtraItem
		,oe.SeatNo
		,oe.ExtraPrice
END

GO
