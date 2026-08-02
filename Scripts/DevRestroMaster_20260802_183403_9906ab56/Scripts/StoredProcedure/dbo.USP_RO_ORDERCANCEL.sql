SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_RO_ORDERCANCEL]
CREATE PROCEDURE [dbo].[USP_RO_ORDERCANCEL] @OrderMasterID INT
	,@IsCancelled BIT
	,@TableId NVARCHAR(50)
	,@CancelReason NVARCHAR(max)
	,@CancelBy NVARCHAR(250)
	,@SeatNo INT
AS
BEGIN

	UPDATE RO_Order_Detail
	SET IsCancelled = 1
	WHERE OrderMasterId = @OrderMasterID
		AND (
			SELECT ois.StatusID
			FROM RO_OrderItemStatus ois
			WHERE ois.OrderDetailID = OrderDetailsID
			) = 1
		AND SeatNo = @SeatNo

	IF (
			(
				SELECT count(*)
				FROM RO_Order_Detail
				WHERE OrderMasterId = @OrderMasterID
					AND IsCancelled = 0
					AND isnull(BillPaid, 0) = 0
				) = 0
			)
	BEGIN
		DECLARE @isTable BIT

		SET @isTable = (
				SELECT IsTable
				FROM RO_restroTable
				WHERE restrotableId = @TableId
				)

		UPDATE dbo.RO_OrderMasters
		SET IsCancelled = 1
			,CancelReason = @CancelReason
			,CancelBy = @CancelBy
			,CancelDate = getdate()
		WHERE OrderMasterID = @OrderMasterID

		DECLARE @IsGeneratedBillPaid INT

		SET @IsGeneratedBillPaid = (
				SELECT count(*)
				FROM RO_SalesMaster
				WHERE OrderMasterId = @OrderMasterID
					AND ISNULL(IsUpdated, 0) = 0
				)

		IF (
				@isTable = 1
				AND ISNULL(@IsGeneratedBillPaid, 0) = 0
				)

		-- or RO_restroTable.restrotableId = @val;

		BEGIN


			UPDATE RO_MergeTable
			SET MergeTableList = 0
			WHERE MergeTableList = @tableId
		END
		ELSE
		BEGIN

			UPDATE Ro_RoomBookings
			SET IsCancelled = 1
			WHERE OrderMasterId = @OrderMasterID
		END

			UPDATE dbo.RO_restroTable
			SET restrotablesStatusID = 6
			WHERE restrotableId = @TableId 
	END

	select 200
END

GO
