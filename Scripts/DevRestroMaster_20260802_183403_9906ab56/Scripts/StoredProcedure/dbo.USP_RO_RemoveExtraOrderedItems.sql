SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_RemoveExtraOrderedItems] @OrderMasterId INT
	,@ItemID INT
	,@ExtraItemID INT
	,@ExtraItem NVARCHAR(256)
	,@Quantity INT
	,@ExtraPrice DECIMAL(10, 2)
	,@SeatNo INT
AS
BEGIN
	DECLARE @ExtraOrderID INT
		,@qnty INT
	DECLARE @continue BIT = 0

	WHILE (@continue = 0)
	BEGIN
		SELECT TOP (1) @ExtraOrderID = ed.ExtraOrderID
			,@qnty = ed.Quantity
		FROM RO_Order_ExtraItem ed
		INNER JOIN RO_Order_Detail od ON od.OrderDetailsID = ed.OrderDetailsID and od.SeatNo = ed.SeatNo 
		WHERE ed.OrderMasterId = @OrderMasterID
			AND ed.ItemID = @ItemID
			and ed.ExtraItemID = @ExtraItemID
			AND od.IsCancelled = 0
			and ed.SeatNo = @SeatNo
		ORDER BY od.OrderDetailsID DESC

		IF (@qnty <= @Quantity)
		BEGIN
			DELETE
			FROM RO_Order_ExtraItem
			WHERE ExtraOrderID = @ExtraOrderID

			SET @Quantity = (@Quantity - @qnty)

			IF (@Quantity > 0)
				SET @continue = 0
			ELSE
				SET @continue = 1
		END
		ELSE
		BEGIN
			UPDATE RO_Order_ExtraItem
			SET Quantity = (Quantity - @Quantity)
			WHERE ExtraOrderID = @ExtraOrderID

			SET @continue = 1
		END
	END
END


GO
