SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_AdjustmentDetailsSave]
    @AMId INT ,
    @STID INT ,
    @ITId INT ,
    @UsedUnitId INT ,
    @Qnty BIGINT ,
    @QntyInText VARCHAR (MAX) ,
    @AdType INT ,
    @IsAdd BIT
AS
    BEGIN

        INSERT INTO dbo.ROI_AdjustmentDetls ( AMId ,
                                              ITId ,
                                              UsedUnitId ,
                                              Qnty ,
                                              QntyInText ,
                                              AdType ,
                                              IsAdd )
        VALUES ( @AMId, @ITId, @UsedUnitId, @Qnty, @QntyInText, @AdType, @IsAdd );

        DECLARE @AdjustmentQty DECIMAL (18, 2) ,
                @SmallUnit INT ,
                @AdjustmentRate DECIMAL (18, 2) ,
                @AdjustmentAmt DECIMAL (18, 2) ,
                @AdjustmentTranId INT;

        --DECLARING VALUE FOR INSERT IN PURCHASE
        SET @AdjustmentQty = @Qnty;
        SET @AdjustmentRate = ISNULL (( SELECT   TOP ( 1 ) PurchaseRate
                                        FROM     dbo.ROI_PurchaseStockTransaction PD
                                        WHERE    ItemId = @ITId
                                        AND      StoreId = @STID
                                        ORDER BY PurchaseTranId DESC ) ,
                                      0);

        SELECT @SmallUnit = ISNULL (ID.SmallUnit, 0)
        FROM   dbo.ROI_ItemDetails ID
        WHERE  ITId = @ITId;


        /*
			Main Query To Calculate Details
	    */
        DECLARE @LastBalance DECIMAL (15, 2);
        DECLARE @LastValue DECIMAL (15, 2);
        DECLARE @AvailableQty DECIMAL (15, 2) ,
                @ItemBalance DECIMAL (15, 2) ,
                @ItemValue DECIMAL (15, 2);

        SELECT   TOP ( 1 ) @LastBalance = ItemBalance ,
                           @LastValue = ItemValue
        FROM     [dbo].[ROI_StockTransactionMaster]
        WHERE    ItemId = @ITId
        AND      StoreId = @STID
        ORDER BY TransactionDate DESC;


        SELECT @AvailableQty = CASE WHEN @IsAdd = 1 THEN @LastBalance + @AdjustmentQty
                                    ELSE @LastBalance - @AdjustmentQty
                               END ,
               @ItemBalance = CASE WHEN @IsAdd = 1 THEN @LastBalance + @AdjustmentQty
                                   ELSE @LastBalance - @AdjustmentQty
                              END ,
               @ItemValue = CASE WHEN @IsAdd = 1 THEN @LastValue + ( @AdjustmentQty * @AdjustmentRate )
                                 ELSE @LastValue - ( @AdjustmentQty * @AdjustmentRate )
                            END;


        --INSERT DATA INSIDE PURCHASE TRANSACTIOn
        INSERT INTO [dbo].[ROI_AdjustStockTransaction] ( StoreId ,
                                                         ItemId ,
                                                         AdjQty ,
                                                         AdjUnit ,
                                                         AdjRate ,
                                                         AdjAmt ,
                                                         AvailableQty ,
                                                         TransactionDate )
        VALUES ( @STID, @ITId, @AdjustmentQty, @SmallUnit, @AdjustmentRate, @AdjustmentRate * @AdjustmentQty ,
                 @AvailableQty , GETDATE ());

        SET @AdjustmentTranId = SCOPE_IDENTITY ();

        --INSERT INTO MAIN STOCK TABLE
        INSERT INTO [dbo].[ROI_StockTransactionMaster] ( AdjustTranId ,
                                                         StoreId ,
                                                         ItemId ,
                                                         AvailableQty ,
                                                         [Rate] ,
                                                         ItemBalance ,
                                                         ItemBalUnitId ,
                                                         ItemValue ,
                                                         TransactionDate )
        VALUES ( @AdjustmentTranId, @STID, @ITId, @AvailableQty, @AdjustmentRate, @ItemBalance, @SmallUnit, @ItemValue ,
                 GETDATE ());
    END;

GO
