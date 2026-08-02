SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- DROP PROC [usp_ro_updateOrderMaster] 
CREATE PROCEDURE [dbo].[usp_ro_updateOrderMaster] @OrderMasterId INT
	,@termAmount DECIMAL(18, 2)
	,@NetAmount DECIMAL(18, 2)
	,@seatNo INT
AS
BEGIN
	UPDATE RO_Order_Detail
	SET BillPaid = 1
	WHERE IsCancelled = 0
		AND SeatNo = @seatNo
		AND OrderMasterId = @OrderMasterId

	UPDATE RO_OrderItemStatus
	SET StatusID = 3
	WHERE OrderDetailID IN (
			SELECT OrderDetailsID
			FROM RO_Order_Detail od
			join RO_OrderMasters om on om.OrderMasterID = od.OrderMasterId
			WHERE od.IsCancelled = 0
				AND SeatNo = @seatNo
				AND od.OrderMasterId = @OrderMasterId
				and om.TableId > 0
			)

	DECLARE @remaning INT

	SELECT @remaning = Count(orderdetailsid)
	FROM dbo.ro_order_detail od
	INNER JOIN dbo.ro_ordermasters om ON om.ordermasterid = od.ordermasterid
	WHERE od.ordermasterid = @OrderMasterId
		AND Isnull(od.billpaid, 0) = 0
		AND od.IsCancelled = 0

	IF (@remaning = 0)
	BEGIN
		UPDATE dbo.ro_ordermasters
		SET termamount = @termAmount
			,netamount = @NetAmount
			,billpaid = 1
			,isprinted = 0
		WHERE ordermasterid = @OrderMasterId
	END
END
	--SELECT * FROM dbo.RO_OrderMasters where OrderMasterId = 6806 

GO
