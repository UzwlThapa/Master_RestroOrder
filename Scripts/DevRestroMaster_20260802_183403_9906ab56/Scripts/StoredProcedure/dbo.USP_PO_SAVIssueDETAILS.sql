SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[USP_PO_SAVIssueDETAILS] 0,1033,3,5,'','superuser','2023-08-14',1,3
CREATE PROCEDURE [dbo].[USP_PO_SAVIssueDETAILS]
    @IMId INT,
    @ITID INT,
    @UsedUnitId INT,
    @Qnty DECIMAL(18, 2),
    @QntyInText VARCHAR(250),
    @ReceivedBy VARCHAR(250),
    @ReceivedOn DATETIME,
    @IssuedToSTId INT,
    @IssuedFrSTId INT
AS
BEGIN
    INSERT INTO dbo.ROI_IssueDetails
    (
        IMId,
        ITID,
        UsedUnitId,
        Qnty,
        QntyInText,
        ReceivedBy,
        ReceivedOn
    )
    VALUES
    (@IMId, @ITID, @UsedUnitId, @Qnty, @QntyInText, @ReceivedBy, @ReceivedOn);

	DECLARE @IssuedDetailId INT = @@IDENTITY


END;

DECLARE @ItemCount INT = 0;
DECLARE @Conversion INT;
DECLARE @itemSmallUnitId INT;
SELECT @itemSmallUnitId = SmallUnit
FROM ROI_ItemDetails
WHERE ITId = @ITID;

IF (@UsedUnitId = @itemSmallUnitId)
BEGIN
    SET @Conversion = 1;
END;
ELSE
BEGIN
    SET @Conversion =
    (
        SELECT ISNULL(Conversion, 1)
        FROM ROI_Unit2
        WHERE FirstUnit = @UsedUnitId
              AND SecondUnit = @itemSmallUnitId
              AND IsArchived = 0
    );
END;

/*
Updated Bishal Raj parajuli
Expected Input
IssuedFrom
IssuedTo
IssueDetailId
IssuedItem
IssuedQty
*/
DECLARE @OutPurchaseRate DECIMAL(18,2) =  ISNULL((SELECT TOP(1)Rate From [ROI_StockTransactionMaster] PD WHERE ItemId=@ITID AND StoreId=@IssuedFrSTId AND AvailableQty > 0),0)



--Issue Out
BEGIN
	DECLARE @SItemId INT = @ITID,
			@SQty DECIMAL = @Qnty,
			@SUnitName INT,
			@OutStoreId INT


			select  @SUnitName = ID.SmallUnit from ROI_ItemDetails ID
				Where Id.ITId=@SItemId

						SET @OutStoreId = @IssuedFrSTId

						DECLARE @RemainingSQty DECIMAL = @SQty

						DECLARE
						@AvailableQty DECIMAL,
						@PurchaseRate DECIMAL,
						@SalesMasterTranId INT,
						@TotalSellAmt DECIMAL = 0,
						@LastBalance DECIMAL(15,2),
						@LastValue DECIMAL(15,2),
						@OpeningTranId INT,
						@OpeningRate DECIMAL

						SET @LastBalance = ISNULL((SELECT TOP(1) ItemBalance From [dbo].[ROI_StockTransactionMaster] WHERE ItemId=@SItemId AND StoreId=@OutStoreId ORDER BY StockTranMasterId DESC),0)
						SET @LastValue = ISNULL((SELECT TOP(1) ItemValue From [dbo].[ROI_StockTransactionMaster] WHERE ItemId=@SItemId AND StoreId=@OutStoreId ORDER BY StockTranMasterId DESC),0)

						
							
						--Declare
						DECLARE crusor_transaction CURSOR
							FOR (SELECT StockTranMasterId,AvailableQty,Rate From [dbo].[ROI_StockTransactionMaster] WHERE ItemId=@SItemId AND StoreId=@OutStoreId AND AvailableQty IS NOT NULL);


						--Open Crusor
						OPEN crusor_transaction;

						--Fetch From Declare
						FETCH NEXT FROM crusor_transaction INTO @SalesMasterTranId,@AvailableQty,@PurchaseRate;

						WHILE @@FETCH_STATUS = 0  
							BEGIN

								IF (@RemainingSQty > @AvailableQty)
								BEGIN 

									SET @RemainingSQty = @RemainingSQty - @AvailableQty; -- Calculation of Remaining Selling Qty

									SET @TotalSellAmt = @TotalSellAmt + (@AvailableQty * @PurchaseRate); --Calculation of Total Selling Value
								
									UPDATE [dbo].[ROI_StockTransactionMaster] SET AvailableQty=0 WHERE StockTranMasterId=@SalesMasterTranId

								END
								ELSE --If RemainingSelling Qty is Less than Available Balance 
								BEGIN
			
									SET @TotalSellAmt = @TotalSellAmt + (@RemainingSQty * @PurchaseRate); --Calculation of Total Selling Value
			
									UPDATE [dbo].[ROI_StockTransactionMaster] SET AvailableQty=@AvailableQty-@RemainingSQty WHERE StockTranMasterId=@SalesMasterTranId
									BREAK;
								END
		

									FETCH NEXT FROM crusor_transaction 
									INTO
									@SalesMasterTranId,@AvailableQty,@PurchaseRate
									;

							END;
							CLOSE crusor_transaction;

							DEALLOCATE crusor_transaction;


							INSERT INTO [dbo].[ROI_IssueStockTransaction]
							(IssueDetailId,FromStoreId,ToStoreId,ItemId,IssueQty,IssueUnit,IssueAmt,TransactionDate)
							VALUES
							(@IssuedDetailId,@IssuedFrSTId,@IssuedToSTId,@SItemId,@SQty,@SUnitName,@TotalSellAmt,GETDATE())

							DECLARE @SalesTranId INT = @@IDENTITY
		
							INSERT INTO [dbo].[ROI_StockTransactionMaster]
							(IssueTranId,StoreId,ItemId,ItemBalance,ItemBalUnitId,ItemValue,TransactionDate)
							VALUES
							(@SalesTranId,@OutStoreId,@SItemId,@LastBalance-@SQty,@SUnitName,@LastValue-@TotalSellAmt,GETDATE())

	SELECT * FROM ROI_StockTransactionMaster


--Issue IN

		DECLARE @PurchaseQty DECIMAL(18,2) = @Qnty,
		@SmallUnit INT,
		
		@PurchaseAmt DECIMAL(18,2),
		@PurchaseTranId INT



		SELECT @SmallUnit=ISNULL(ID.SmallUnit,0) From ROI_ItemDetails ID WHERE ITId=@ITID

		/*
		Main Query To Calculate Details
		*/
		DECLARE @OutLastBalance DECIMAL(15,2)
		DECLARE @OutLastValue DECIMAL(15,2)
		DECLARE @MasterTranId INT


		SET @OutLastBalance = ISNULL((SELECT TOP(1) ItemBalance From [dbo].[ROI_StockTransactionMaster] WHERE ItemId=@ITID AND StoreId=@IssuedToSTId ORDER BY StockTranMasterId DESC),0)
		SET @OutLastValue = ISNULL((SELECT TOP(1) ItemValue From [dbo].[ROI_StockTransactionMaster] WHERE ItemId=@ITID AND StoreId=@IssuedToSTId ORDER BY StockTranMasterId DESC),0)


		SELECT @OutLastBalance
		SELECT @PurchaseQty

		--INSERT INTO MAIN STOCK TABLE
		INSERT INTO [dbo].[ROI_StockTransactionMaster]
		(IssueTranId,StoreId,ItemId,AvailableQty,[Rate],ItemBalance,ItemBalUnitid,ItemValue,TransactionDate)
		VALUES
		(@IssuedDetailId,
		@IssuedToSTId,
		@ITID,
		CASE 
		WHEN @LastBalance < 0 THEN 0 
		ELSE @PurchaseQty 
		END,
		@OutPurchaseRate,
		@OutLastBalance+@PurchaseQty,
		@SmallUnit,
		CASE WHEN @OutLastBalance < 0 THEN 0 ELSE @OutLastValue+(@PurchaseQty * @OutPurchaseRate) END,
		DATEADD(SECOND,1,GETDATE())
		)

		SET @MasterTranId = @@IDENTITY

		--When Last Balance is Zero and new Balance Creates Positive Balance

		DECLARE @LastTranBalance DECIMAL(18,2) = ISNULL((SELECT ItemBalance FROM [dbo].[ROI_StockTransactionMaster] WHERE StockTranMasterId=@MasterTranId),0)

		SELECT @LastTranBalance

		IF (@LastBalance < 0 AND @LastTranBalance > 0 )
		BEGIN
			UPDATE [dbo].[ROI_StockTransactionMaster] SET AvailableQty=@LastTranBalance, [Rate]=@OutPurchaseRate,
				ItemValue=ISNULL((SELECT IssueAmt FROM [dbo].[ROI_IssueStockTransaction] WHERE IssueTranId=@SalesTranId),0)
			WHERE StockTranMasterId=@MasterTranId
		END
END










--Old Query
--BEGIN

	

--    SELECT @ItemCount = COUNT(1)
--    FROM ROI_ITEMBal
--    WHERE ITId = @ITID
--          AND STId = @IssuedFrSTId;
--    SET @ItemCount = ISNULL(@ItemCount, 0);
--    IF @ItemCount >= 1
--        UPDATE ROI_ITEMBal
--        SET CLBal = CLBal - (@Qnty * ISNULL(@Conversion, 1))
--        WHERE ITId = @ITID
--              AND STId = @IssuedFrSTId;
--    ELSE
--        INSERT INTO ROI_ITEMBal
--        (
--            ITId,
--            PDId,
--            STId,
--            CLBal,
--            OPBal,
--			CLRate
--        )
--        VALUES
--        (@ITID, '0', @IssuedFrSTId, - (@Qnty * ISNULL(@Conversion, 1)), 0,0);
--END;
--BEGIN

--declare @Rate decimal(14,4) = 0

--	select top(1) @Rate = CLRate from ROI_ITEMBal order by PDId desc
--    SET @ItemCount = 0;
--    SELECT @ItemCount = COUNT(1)
--    FROM ROI_ITEMBal
--    WHERE ITId = @ITID
--          AND STId = @IssuedToSTId;
--    SET @ItemCount = ISNULL(@ItemCount, 0);
--    IF @ItemCount >= 1
--        UPDATE ROI_ITEMBal

--        SET CLBal = CLBal + (@Qnty * ISNULL(@Conversion, 1)), CLRate = @Rate
--        WHERE ITId = @ITID
--              AND STId = @IssuedToSTId;
--    ELSE
--        INSERT INTO ROI_ITEMBal
--        (
--            ITId,
--            PDId,
--            STId,
--			CLRate,
--            CLBal,
--            OPBal
--        )
--        VALUES
--        (@ITID, '0', @IssuedToSTId,@Rate, (@Qnty * ISNULL(@Conversion, 1)), 0);
--END;



GO
