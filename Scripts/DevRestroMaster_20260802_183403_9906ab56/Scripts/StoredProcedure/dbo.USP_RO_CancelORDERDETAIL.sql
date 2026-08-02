SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- DROP PROC [USP_RO_CancelORDERDETAIL] 537,0,1,7,0,1,0
CREATE PROCEDURE [dbo].[USP_RO_CancelORDERDETAIL] 
	@OrderMasterID INT
	,@OrderDetailID INT
	,@Quantity INT
	,@RO_ItemID INT
	,@IsCombo BIT
	,@SeatNo INT
	,@IsRunningOrder BIT
	,@UserName nvarchar(250) = 'waiter'
AS
BEGIN

	IF (@OrderDetailID = 0)
	BEGIN
		DECLARE @orderdetail INT
			,@qnty INT
		DECLARE @continue BIT = 0
		DECLARE @RemainingBalance decimal(18,2) = @quantity

		WHILE (@continue = 0)
		BEGIN
			SELECT TOP (1) @orderdetail = OrderDetailsID
				,@qnty = Quantity
			FROM RO_Order_Detail od
			INNER JOIN RO_OrderItemStatus ois ON ois.OrderDetailID = od.OrderDetailsID
			WHERE ois.StatusID = 1
				AND od.ROI_ItemId = @RO_ItemID
				AND od.IsCombo = @IsCombo
				AND od.IsCancelled = 0
				and isnull(od.BillPaid,0)=0
				AND od.SeatNo = @SeatNo
				and od.OrderMasterId = @OrderMasterID
			ORDER BY OrderDetailsID DESC

				IF (@qnty < @RemainingBalance or @qnty = @RemainingBalance)
			BEGIN
				UPDATE RO_Order_Detail
				SET IsCancelled = 1, UpdatedBy=@UserName
				WHERE OrderDetailsID = @orderdetail
					AND SeatNo = @SeatNo
			


--INSERT INTO [dbo].[Order_Detail_Cancel]
--           ([CanceledBy]
--           ,[OrderBy]
--           ,[Item]
--           ,[Quantity]
--           ,[Reason]
--           ,[Date]
--           ,[Responsible]
--           ,[tableId]
--           ,[orderMasterID])
--SELECT [CanceledBy],od.AddedBy,i.ITName, od.Quantity, [Reason], GETDATE(),[Responsible], om.TableId, om.OrderMasterID
--FROM RO_Order_Detail od
--inner join RO_OrderMasters om on od.OrderMasterId=om.OrderMasterID
--inner join ROI_ITEMMain i on od.ROI_ItemId=i.ITId
--WHERE OrderDetailsID = @orderdetail
--					AND SeatNo = @SeatNo


				SET @RemainingBalance = (@RemainingBalance - @qnty)

				IF (@RemainingBalance > 0)
					SET @continue = 0
				ELSE
					SET @continue = 1
			END
			ELSE
			BEGIN
				
				UPDATE RO_Order_Detail
				SET Quantity = (Quantity - @RemainingBalance), Amount = Rate * (Quantity - @RemainingBalance), UpdatedBy=@UserName
				WHERE OrderDetailsID = @orderdetail
					AND SeatNo = @SeatNo


				
--INSERT INTO [dbo].[Order_Detail_Cancel]
--           ([CanceledBy]
--           ,[OrderBy]
--           ,[Item]
--           ,[Quantity]
--           ,[Reason]
--           ,[Date]
--           ,[Responsible]
--           ,[tableId]
--           ,[orderMasterID])
--SELECT [CanceledBy],od.AddedBy,i.ITName, @Quantity, [Reason], GETDATE(),[Responsible], om.TableId, om.OrderMasterID
--FROM RO_Order_Detail od
--inner join RO_OrderMasters om on od.OrderMasterId=om.OrderMasterID
--inner join ROI_ITEMMain i on od.ROI_ItemId=i.ITId
--WHERE OrderDetailsID = @orderdetail
--					AND SeatNo = @SeatNo


				SET @continue = 1
			END
		END
	END
	ELSE
	BEGIN
		if((select Quantity from RO_Order_Detail
				WHERE OrderDetailsID = @OrderDetailID
					AND SeatNo = @SeatNo) > @Quantity)
					BEGIN
						UPDATE RO_Order_Detail
						SET Quantity = (Quantity - @Quantity), UpdatedBy=@UserName
						WHERE OrderDetailsID = @OrderDetailID
						AND SeatNo = @SeatNo
					END

					else 
					BEGIN
						UPDATE RO_Order_Detail
						SET IsCancelled = 1, UpdatedBy=@UserName
						WHERE OrderDetailsID = @OrderDetailID
							AND SeatNo = @SeatNo

					END

		
--INSERT INTO [dbo].[Order_Detail_Cancel]
--           ([CanceledBy]
--           ,[OrderBy]
--           ,[Item]
--           ,[Quantity]
--           ,[Reason]
--           ,[Date]
--           ,[Responsible]
--           ,[tableId]
--           ,[orderMasterID])
--SELECT [CanceledBy],od.AddedBy,i.ITName, od.Quantity, [Reason], GETDATE(),[Responsible], om.TableId, om.OrderMasterID
--FROM RO_Order_Detail od
--inner join RO_OrderMasters om on od.OrderMasterId=om.OrderMasterID
--inner join ROI_ITEMMain i on od.ROI_ItemId=i.ITId
--WHERE OrderDetailsID = @orderdetail
--					AND SeatNo = @SeatNo
	SET @continue = 1
	END


	/* If there is no items in order details which is not cancelled then cancelled the order master also */
	IF (
			(
				SELECT count(*)
				FROM RO_Order_Detail
				WHERE OrderMasterId = @OrderMasterID
					AND IsCancelled = 0
				) = 0
			)
	BEGIN
		UPDATE RO_OrderMasters
		SET IsCancelled = 1, UserName=@UserName
		WHERE OrderMasterID = @OrderMasterID

		UPDATE dbo.RO_restroTable
		SET restrotablesStatusID = 6
		WHERE restrotableId = (
				SELECT TableId
				FROM RO_OrderMasters
				WHERE OrderMasterID = @OrderMasterID
				)

		UPDATE RO_MergeTable
		SET MergeTableList = 0
		WHERE MergeTableList = (
				SELECT TableId
				FROM RO_OrderMasters
				WHERE OrderMasterID = @OrderMasterID
				)
	END
END


GO
