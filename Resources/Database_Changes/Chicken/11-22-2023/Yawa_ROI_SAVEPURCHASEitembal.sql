SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 11/22/2023
====================================

 EXEC dbo.ROI_SAVEPURCHASEitembal @ItemID = 0 , -- int
                                  @PDId = 0 ,   -- int
                                  @STId = 0 ,   -- int
                                  @OPBal = 0 ,  -- int
                                  @CLBal = NULL -- decimal(18, 2)
  
*/
ALTER PROCEDURE [dbo].ROI_SAVEPURCHASEitembal
    @ItemID INT ,
    @PDId INT ,
    @STId INT ,
    @OPBal INT ,
    @CLBal DECIMAL (18, 2) ,
    @BillDate DATETIME = NULL
AS
    BEGIN
	 
        --Updated Stock Valuation Bishal Raj Parajuli
        /*
		Input Paramaters
		@ItemID INT
		,@PurchaseDetailId INT
		,@StoreId INT
		,@OPBal INT NOT REQUIRED
		,@CLBal decimal(18,2) NOT REQUIRED

	*/
        DECLARE @PurchaseQty DECIMAL (18, 2) ,
                @SmallUnit INT ,
                @PurchaseRate DECIMAL (18, 2) ,
                @PurchaseAmt DECIMAL (18, 2) ,
                @PurchaseTranId INT;

        --DECLARING VALUE FOR INSERT IN PURCHASE
        SELECT @PurchaseQty = ISNULL (( PD.Quentity * Conversion ), 0) ,
               @PurchaseRate = ISNULL (ROUND ((( PD.Total - PD.Discount ) / @PurchaseQty ), 2, 1), 0)
        FROM   ROI_PurchaseDetails PD
        WHERE  PurchaseDetailsID = @PDId;

        SELECT @SmallUnit = ISNULL (ID.SmallUnit, 0)
        FROM   ROI_ItemDetails ID
        WHERE  ITId = @ItemID;


        /*
	Main Query To Calculate Details
	*/
        DECLARE @LastBalance DECIMAL (15, 2);
        DECLARE @LastValue DECIMAL (15, 2);
        DECLARE @MasterTranId INT;


        SET @LastBalance = ISNULL (( SELECT   TOP ( 1 ) ItemBalance
                                     FROM     [dbo].[ROI_StockTransactionMaster]
                                     WHERE    ItemId = @ItemID
                                     AND      StoreId = @STId
                                     ORDER BY StockTranMasterId DESC ) ,
                                   0);
        SET @LastValue = ISNULL (( SELECT   TOP ( 1 ) ItemValue
                                   FROM     [dbo].[ROI_StockTransactionMaster]
                                   WHERE    ItemId = @ItemID
                                   AND      StoreId = @STId
                                   ORDER BY StockTranMasterId DESC ) ,
                                 0);


        --INSERT DATA INSIDE PURCHASE TRANSACTIOn
        INSERT INTO [dbo].[ROI_PurchaseStockTransaction] ( PurchaseDetailId ,
                                                           StoreId ,
                                                           ItemId ,
                                                           PurchaseQty ,
                                                           PurchaseUnit ,
                                                           PurchaseRate ,
                                                           PurchaseAmt ,
                                                           AvailableQty ,
                                                           TransactionDate )
        VALUES ( @PDId, @STId, @ItemID, @PurchaseQty, @SmallUnit, @PurchaseRate, @PurchaseRate * @PurchaseQty ,
                 CASE WHEN @LastBalance < 0 THEN 0
                      ELSE @PurchaseQty
                 END ,
                 --GETDATE()
                 @BillDate );

        SET @PurchaseTranId = @@IDENTITY;


        --INSERT INTO MAIN STOCK TABLE
        INSERT INTO [dbo].[ROI_StockTransactionMaster] ( PurchaseTranId ,
                                                         StoreId ,
                                                         ItemId ,
                                                         AvailableQty ,
                                                         [Rate] ,
                                                         ItemBalance ,
                                                         ItemBalUnitId ,
                                                         ItemValue ,
                                                         TransactionDate )
        VALUES ( @PurchaseTranId, @STId, @ItemID, CASE WHEN @LastBalance < 0 THEN 0
                                                       ELSE @PurchaseQty
                                                  END, @PurchaseRate, @LastBalance + @PurchaseQty, @SmallUnit ,
                 CASE WHEN @LastBalance < 0 THEN 0
                      ELSE @LastValue + ( @PurchaseQty * @PurchaseRate )
                 END , --GETDATE ()
                 @BillDate );

        SET @MasterTranId = @@IDENTITY;

        --When Last Balance is Zero and new Balance Creates Positive Balance

        DECLARE @LastTranBalance DECIMAL (18, 2) = ISNULL (( SELECT ItemBalance
                                                             FROM   [dbo].[ROI_StockTransactionMaster]
                                                             WHERE  StockTranMasterId = @MasterTranId ) ,
                                                           0);

        IF ( @LastBalance < 0
         AND @LastTranBalance > 0 )
            BEGIN
                UPDATE [dbo].[ROI_PurchaseStockTransaction]
                SET    AvailableQty = @LastTranBalance
                WHERE  PurchaseTranId = @PurchaseTranId;
                UPDATE [dbo].[ROI_StockTransactionMaster]
                SET    AvailableQty = @LastTranBalance ,
                       [Rate] = @PurchaseRate ,
                       ItemValue = ISNULL (( SELECT AvailableQty * PurchaseRate
                                             FROM   [dbo].[ROI_PurchaseStockTransaction]
                                             WHERE  PurchaseTranId = @PurchaseTranId ) ,
                                           0)
                WHERE  StockTranMasterId = @MasterTranId;
            END;

    END;
GO

