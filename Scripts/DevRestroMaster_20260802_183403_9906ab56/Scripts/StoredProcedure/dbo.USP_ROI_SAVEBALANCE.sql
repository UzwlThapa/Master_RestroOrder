SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_ROI_SAVEBALANCE] @ITId INT
	,@STId INT
	,@OPBal INT
	,@OPRate DECIMAL(18,2)
AS
/*
Updated Query Bishal Raj Parajuli
Expected INPUT
ItemId
Store Id
OpeningQty
OpeningRate
*/
BEGIN 

	DECLARE
	@SmallUnit INT,
	@OpeningTranId INT

	SELECT @SmallUnit=ISNULL(ID.SmallUnit,0) From ROI_ItemDetails ID WHERE ITId=@ITId

	/*
	Main Query To Calculate Details
	*/
	DECLARE @LastBalance DECIMAL(15,2)
	DECLARE @LastValue DECIMAL(15,2)
	DECLARE @MasterTranId INT


	SET @LastBalance = ISNULL((SELECT TOP(1) ItemBalance From [dbo].[ROI_StockTransactionMaster] WHERE ItemId=@ITId AND StoreId=@STId ORDER BY StockTranMasterId DESC),0)
	SET @LastValue = ISNULL((SELECT TOP(1) ItemValue From [dbo].[ROI_StockTransactionMaster] WHERE ItemId=@ITId AND StoreId=@STId ORDER BY StockTranMasterId DESC),0)
	

	--INSERT DATA INSIDE PURCHASE TRANSACTIOn
	INSERT INTO [dbo].[ROI_OpeningStockTransaction]
	([StoreId],[ItemId],[OpeningQty],[OpeningUnit],[OpeningRate],[OpeningAmt],[AvailableQty],[TransactionDate])
	VALUES
	(@STId,
	@ItId,
	@OPBal,
	@SmallUnit,
	@OPRate,
	@OPBal*@OPRate,
	CASE 
	WHEN @LastBalance < 0 THEN 0 
	ELSE @OPBal
	END,
	GETDATE())

	SET @OpeningTranId = @@IDENTITY


	--INSERT INTO MAIN STOCK TABLE
	INSERT INTO [dbo].[ROI_StockTransactionMaster]
	(OpeningTranId,StoreId,ItemId,AvailableQty,[Rate],ItemBalance,ItemBalUnitid,ItemValue,TransactionDate)
	VALUES
	(@OpeningTranId,
	@STId,
	@ITId,
	CASE 
	WHEN @LastBalance < 0 THEN 0 
	ELSE @OPBal
	END,
	@OPRate,
	@LastBalance+@OPBal,
	@SmallUnit,
	CASE WHEN @LastBalance < 0 THEN 0 ELSE @LastValue+(@OPBal*@OPRate) END,
	GETDATE()
	)

	SET @MasterTranId = @@IDENTITY

	--When Last Balance is Zero and new Balance Creates Positive Balance

	DECLARE @LastTranBalance DECIMAL(18,2) = ISNULL((SELECT ItemBalance FROM [dbo].[ROI_StockTransactionMaster] WHERE StockTranMasterId=@MasterTranId),0)

	IF (@LastBalance < 0 AND @LastTranBalance > 0 )
	BEGIN
		UPDATE [dbo].[ROI_OpeningStockTransaction] SET AvailableQty=@LastTranBalance WHERE OpeningTranId=@OpeningTranId
		UPDATE [dbo].[ROI_StockTransactionMaster] SET AvailableQty=@LastTranBalance, Rate= @OPRate,
			ItemValue=ISNULL((SELECT AvailableQty*OpeningRate FROM [dbo].[ROI_OpeningStockTransaction] WHERE OpeningTranId=@OpeningTranId),0)
		WHERE StockTranMasterId=@MasterTranId
	END

END





/*
Old Query
*/

--BEGIN
--DECLARE @code int
--DECLARE @PDId INT = 0
--	IF not EXISTS (
--			SELECT TOP(1) 1
--			FROM ROI_ITEMBal
--			WHERE ITId = @ITId and STId=@STId
--			)
--		BEGIN
--		INSERT INTO ROI_ITEMBal (
--			ITId
--			,PDId
--			,STId
--			,OPBal
--			,CLBal
--			,PostedDate
--			,OPRate
--			,CLRate
--			,TotalValue
--			)
--		VALUES (
--			@ITId
--			,'0'
--			,@STId
--			,@OPBal
--			,@OPBal
--			,GETDATE()
--			,@OPRate
--			,@OPRate
--			,(ISNULL(@OPBal,0) * ISNULL(@OPRate,0))
--			)
--			set @code = 200
	
--			END
--	ELSE 
--	 select @PDId= isnull(PDId,0) from ROI_ITEMBal WHERE ITId = @ITId and STId=@STId 
--	  if( @PDId = 0 )
--	  	BEGIN
--				UPDATE ROI_ITEMBal
--			SET    STId = @STId
--					,OPBal = @OPBal
--					,CLBal = @OPBal
--					,OPRate = @OPRate
--					,CLRate = @OPRate
--					,TotalValue = (ISNULL(@OPBal,0) * ISNULL(@OPRate,0))
--					where ITId=@ITId and STId=@STId
--				set @code = 200
--	END
--		else
--		BEGIN
	

--			set @code = 100
--		END

--			select @code
--END

GO
