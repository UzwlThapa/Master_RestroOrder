SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_SAVECAKEORDERDETAIL] (
	@LoopCount int
	,@OrderMasterID INT
	,@ItemId INT
	,@ItemName NVARCHAR(512)
	,@Quantity FLOAT
	,@Rate DECIMAL(18, 2)
	,@Amount DECIMAL(18, 2)
	,@AddedBy nvarchar(500)
	,@IsUpdated BIT
	,@UpdatedBy NVARCHAR(512)
	,@IsArchived BIT
	,@ArchivedBy NVARCHAR(512)
	,@ArchivedOn DATETIME
	,@SalesType VARCHAR(30)	
	)
AS
BEGIN
IF(@LoopCount=0)
BEGIN
DELETE FROM dbo.RO_CakeOrder_Detail
WHERE OrderMasterId=@OrderMasterID
END

	DECLARE @val INT
	DECLARE @Amount1 DECIMAL(18, 2)
	DECLARE @CostCenterID INT

	SELECT @Amount1 = @Rate * @Quantity;

	SELECT @CostCenterID = ItemCostCentreID
		FROM ROI_ItemDetails
		WHERE ITId = @ItemId

	BEGIN
		INSERT INTO dbo.RO_CakeOrder_Detail (
			OrderMasterID
			,ItemId
			,ItemName
			,Quantity
			,Rate
			,Amount
			,AddedBy
			,AddedOn
			,IsUpdated
			,UpdatedBy
			,UpdatedOn
			,IsArchived 
			,ArchivedBy
			,ArchivedOn
			,SalesType
			,CostCenterID
			)
		VALUES (
			@OrderMasterID
			,@ItemId
			,@ItemName
			,@Quantity
			,@Rate
			,@Amount
			,@AddedBy
			,GETDATE()
			,@IsUpdated
			,@UpdatedBy
			,GETDATE()
			,@IsArchived 
			,@ArchivedBy
			,@ArchivedOn
			,@SalesType
			,@CostCenterID
			)

		SELECT @@IDENTITY

		--SET @val = @@IDENTITY

		--INSERT INTO dbo.RO_OrderItemStatus (
		--	OrderDetailID
		--	,StatusID
		--	,TIMESTAMP
		--	)
		--VALUES (
		--	@val
		--	,(
		--		SELECT StatusID
		--		FROM dbo.RO_ItemStatus
		--		WHERE ItemStatus = @Status
		--		)
		--	,GETDATE()
		--	)

	--	UPDATE od
	--	SET od.SeatNo = om.GuestNo
	--	FROM RO_Order_Detail od
	--	INNER JOIN RO_OrderMasters om ON om.OrderMasterID = od.OrderMasterId
	--	WHERE od.SeatNo > om.GuestNo
	--		AND od.OrderMasterId = @OrderMasterID
	END
END

GO
