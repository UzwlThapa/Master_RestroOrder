SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SaveProductionMain]
 @ItemId INT
	,@UnitId INT
	,@StoreId INT
	,@Quantity DECIMAL(10,2)
	,@AddedOn DATETIME
	,@AddedBy VARCHAR(50)

AS
BEGIN
	

		DECLARE @CheckITemID INT =0

	SELECT @CheckITemID = count(1)
	FROM dbo.ROI_ITEMBal where ITId = @ItemID  and STId = @StoreId
	if (@CheckITemID is null) set @CheckITemID=0
	IF (@CheckITemID>= 1)
	BEGIN
		DECLARE @TotalCBl DECIMAL(10,2) = 0
		SELECT @TotalCBl = CLBal
		FROM dbo.ROI_ITEMBal where ITId = @ItemID  and STId = @StoreId
		set @TotalCBl = @TotalCBl + @Quantity
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
			,@StoreId
			,0
			,@Quantity
			,GETDATE()
			)
	END

	INSERT INTO RO_ProductionMain(
		ItemId 
		,UnitId
		,StoreId
		,Quantity
		,AddedOn
		,AddedBy
	
		)
	VALUES (
		@ItemId 
		,@UnitId
		,@StoreId
		,@Quantity
		,@AddedOn
		,@AddedBy	
		)

	SELECT cast(@@IDENTITY as int)
END

GO
