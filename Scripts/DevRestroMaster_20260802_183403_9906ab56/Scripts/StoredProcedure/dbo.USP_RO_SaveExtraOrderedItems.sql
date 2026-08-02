SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_SaveExtraOrderedItems] @OrderMasterId INT
	,@ItemID INT
	,@ExtraItemID INT
	,@ExtraItem NVARCHAR(256)
	,@Quantity INT
	,@ExtraPrice DECIMAL(10, 2)
	,@SeatNo INT
AS

BEGIN
	DECLARE @OrderDetailsID INT
		,@qnty INT
	DECLARE @continue BIT = 0
	


	WHILE (@continue = 0)
	BEGIN

		SELECT TOP (1) @OrderDetailsID=od.OrderDetailsID
			,@qnty= (od.Quantity - isnull(sum(ed.Quantity),0))
		FROM  RO_Order_Detail od
		left join RO_Order_ExtraItem ed on ed.OrderDetailsID = od.OrderDetailsID and ed.SeatNo = @SeatNo
		WHERE od.IsCancelled = 0
			AND od.OrderMasterId = @OrderMasterId
			AND od.ROI_ItemId = @ItemID
			AND od.IsCombo = 0
			and od.SeatNo = @SeatNo
			and (od.Quantity > isnull((select sum(ed.Quantity) from RO_Order_ExtraItem ed
			 where ed.OrderDetailsID = od.OrderDetailsID and ed.SeatNo = @SeatNo),0))
		group by od.OrderDetailsID, od.Quantity
		ORDER BY od.OrderDetailsID DESC
		
		IF (@qnty <= @Quantity)
		BEGIN
			INSERT INTO [dbo].[RO_Order_ExtraItem] (
				[OrderMasterId]
				,[OrderDetailsID]
				,[ItemID]
				,[ExtraItemID]
				,[ExtraItem]
				,[Quantity]
				,[ExtraPrice]
				,[SeatNo]
				)
			VALUES (
				@OrderMasterId
				,@OrderDetailsID
				,@ItemID
				,@ExtraItemID
				,@ExtraItem
				,@qnty
				,@ExtraPrice
				,@SeatNo
				)
			SET @Quantity = (@Quantity - @qnty)

			IF (@Quantity > 0)
				SET @continue = 0
			ELSE
				SET @continue = 1
		END
		ELSE
		BEGIN
			INSERT INTO [dbo].[RO_Order_ExtraItem] (
				[OrderMasterId]
				,[OrderDetailsID]
				,[ItemID]
				,[ExtraItemID]
				,[ExtraItem]
				,[Quantity]
				,[ExtraPrice]
				,[SeatNo]
				)
			VALUES (
				@OrderMasterId
				,@OrderDetailsID
				,@ItemID
				,@ExtraItemID
				,@ExtraItem
				,@Quantity
				,@ExtraPrice
				,@SeatNo
				)
			SET @continue = 1
		END
	END
END

GO
