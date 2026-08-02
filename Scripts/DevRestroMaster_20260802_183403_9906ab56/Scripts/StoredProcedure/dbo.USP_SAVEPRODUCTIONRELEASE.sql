SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SAVEPRODUCTIONRELEASE]
@ProductionInstantID int,
@ItemID int,
@StoreID int,
@UnitID int,
@Quantity decimal(16, 4)
AS
BEGIN
insert into PR_ProductRelease (
	
	ProductionInstantID,
	ItemID,
	StoreID,
	UnitID ,
	Quantity)
	values(
	@ProductionInstantID,
	@ItemID,
	@StoreID,
	@UnitID ,
	@Quantity)

	IF(@ProductionInstantID !=0)
	BEGIN
	UPDATE PR_ProductionInstant SET State = 2 WHERE ProductionInstantID = @ProductionInstantID
	END
	DECLARE @TotalCBl bigint =0
	SELECT @TotalCBl = CLBal
	FROM dbo.ROI_ITEMBal where ITId = @ItemID 
	set @TotalCBl = @TotalCBl + @Quantity
	UPDATE ROI_ITEMBal
	SET CLBal = @TotalCBl
	WHERE ITId = @ItemID 
	
	
END



GO
