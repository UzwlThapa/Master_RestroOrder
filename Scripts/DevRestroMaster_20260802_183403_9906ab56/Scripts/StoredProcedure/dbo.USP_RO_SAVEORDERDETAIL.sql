SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_RO_SAVEORDERDETAIL] 
CREATE PROCEDURE [dbo].[USP_RO_SAVEORDERDETAIL] (
	@OrderMasterID INT = 5021
	,@RO_ItemID INT = 6192
	,@Rate DECIMAL(18, 2) = 0
	,@IsCancelled BIT = 0
	,@Quantity FLOAT = 1
	,@Amount DECIMAL(18, 2) = 0
	,@Note VARCHAR(256) = ''
	,@ExtraCharge DECIMAL(18, 2) =0
	,@IsHomeDelivery BIT =0
	,@HomeDeliveyNumber INT =0
	,@SeatNo INT = 1
	,@Status NVARCHAR(50) = 'Ordered'
	,@IsRunningOrder INT = 0
	,@IsCombo BIT = 0
	,@AddedBy nvarchar(250) = 'superuser'
	)
AS
BEGIN
	-- IF(@OrderDetailID=0)    
	DECLARE @val INT
	DECLARE @Amount1 DECIMAL(18, 2)
	DECLARE @Rate1 DECIMAL(18, 2)
	DECLARE @CostCenterID INT

	IF @IsCombo = 0
	BEGIN
		SELECT @CostCenterID = ItemCostCentreID
		FROM ROI_ItemDetails
		WHERE ITId = @RO_ItemID

		SELECT @Rate1 = it.SRate
		FROM ROI_ItemRate it
		WHERE it.ItemID = @RO_ItemID
	END
	ELSE
	BEGIN
		SELECT @Rate1 = it.SalesPrice
			,@CostCenterID = it.CostCenterID
		FROM RO_Combo it
		WHERE it.ComboID = @RO_ItemID
	END

	SELECT @Amount1 = @Rate1 * @Quantity

	BEGIN
		INSERT INTO dbo.RO_Order_Detail (
			OrderMasterID
			,ROI_ItemId
			,Rate
			,DATE
			,IsCancelled
			,Quantity
			,Amount
			,Note
			,ExtraCharge
			,IsHomeDelivery
			,HomeDeliveyNumber
			,SeatNo
			,CostCenterId
			,IsRunningOrder
			,IsCombo
			,AddedBy
			)
		VALUES (
			@OrderMasterID
			,@RO_ItemID
			,@Rate1
			,GETDATE()
			,@IsCancelled
			,@Quantity
			,@Amount1
			,@Note
			,@ExtraCharge
			,@IsHomeDelivery
			,@HomeDeliveyNumber
			,@SeatNo
			,@CostCenterID
			,@IsRunningOrder
			,@IsCombo
			,@AddedBy
			)

		--SELECT cast(@@IDENTITY as int)

		SET @val = @@IDENTITY

		INSERT INTO dbo.RO_OrderItemStatus (
			OrderDetailID
			,StatusID
			,TIMESTAMP
			)
		VALUES (
			@val
			,(
				SELECT StatusID
				FROM dbo.RO_ItemStatus
				WHERE ItemStatus = @Status
				)
			,GETDATE()
			)

		--UPDATE od
		--SET od.SeatNo = om.GuestNo
		--FROM RO_Order_Detail od
		--INNER JOIN RO_OrderMasters om ON om.OrderMasterID = od.OrderMasterId
		--WHERE od.SeatNo > om.GuestNo
		--	AND od.OrderMasterId = @OrderMasterID

			select @val
	END
END

GO
