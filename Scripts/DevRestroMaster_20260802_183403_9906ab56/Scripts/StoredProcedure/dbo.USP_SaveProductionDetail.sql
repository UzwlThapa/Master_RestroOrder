SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_SaveProductionDetail]
@ProductionMainID int,
@ItemId int,
@ItemUnitId int,
@Quantity decimal(18,2),
@StoreID int

as
begin


	INSERT INTO RO_ProductionDetails(ProductionMainID, ItemId, ItemUnitId, Quantity, StoreID) 
	VALUES (@ProductionMainID, @ItemId, @ItemUnitId, @Quantity, @StoreID) 

		DECLARE @CheckITemID INT =0

	SELECT @CheckITemID = ItemBalID
	FROM dbo.ROI_ITEMBal where ITId = @ItemID  and STId = @StoreId
	if (@CheckITemID is null) set @CheckITemID=0
	IF (@CheckITemID>= 1)
	BEGIN
		DECLARE @TotalCBl DECIMAL(18, 2) =0
		SELECT @TotalCBl = CLBal
		FROM dbo.ROI_ITEMBal where ITId = @ItemID  and STId = @StoreId
		set @TotalCBl = @TotalCBl - @Quantity
		UPDATE ROI_ITEMBal
		SET CLBal = @TotalCBl
		WHERE ITId = @ItemID and STId = @StoreId
	END
	ELSE
	BEGIN
		INSERT INTO dbo.ROI_ITEMBal (
			ITId
			,PDId
			,STId
			,OPBal
			,CLBal
			,PostedDate
			)
		VALUES (
			@ItemID
			,0
			,@StoreID
			,0
			,-@Quantity
			,GETDATE()
			)
	END
END



GO
