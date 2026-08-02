SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 11/22/2023
====================================

 EXEC dbo.ROI_SAVEPURCHASEitembal @ItemID = 237 , -- int
                                  @PDId = 0 ,   -- int
                                  @STId = 0 ,   -- int
                                  @OPBal = 0 ,  -- int
                                  @CLBal = NULL, -- decimal(18, 2)
								  @BillDate = '2023/11/01'
  
*/
CREATE PROCEDURE [dbo].[ROI_SAVEPURCHASEitembal]
    @ItemID INT ,
    @PDId INT ,
    @STId INT ,
    @OPBal INT ,
    @CLBal DECIMAL (18, 2) ,
    @BillDate DATETIME = NULL
AS
    BEGIN
        -- use bill date as transaction date for stock
        SELECT @BillDate = CAST(CONCAT (
                                    DATEPART (YEAR, @BillDate) ,
                                    '-' ,
                                    DATEPART (MONTH, @BillDate),
                                    '-' ,
                                    DATEPART (DAY, @BillDate),
                                    ' ' ,
                                    DATEPART (HOUR, GETDATE ()),
                                    ':' ,
                                    DATEPART (MINUTE, GETDATE ()),
                                    ':' ,
                                    DATEPART (SECOND, GETDATE ())) AS DATETIME);


        DECLARE @PurchaseQty DECIMAL (18, 2) ,
                @SmallUnit INT ,
                @PurchaseRate DECIMAL (18, 2) ,
                @Conversion DECIMAL (18, 2) ,
                @PurchaseTranId INT ,
                @PurchaseMainID INT;

        --DECLARING VALUE FOR INSERT IN PURCHASE
        SELECT @PurchaseQty = ISNULL (( PD.Quentity * ISNULL (Conversion, 1)), 0) ,
               @PurchaseRate = ISNULL (PD.UnitRate, 0) ,
               @Conversion = ISNULL (PD.Conversion, 1) ,
               @PurchaseMainID = PD.PurchaseMainID
        FROM   dbo.ROI_PurchaseDetails PD
        WHERE  PurchaseDetailsID = @PDId;

        SELECT @SmallUnit = ISNULL (ID.SmallUnit, 0)
        FROM   dbo.ROI_ItemDetails ID
        WHERE  ITId = @ItemID;


        /*
	Main Query To Calculate Details
	*/
        DECLARE @LastBalance DECIMAL (15, 2);
        DECLARE @LastValue DECIMAL (15, 2);

        SELECT   TOP ( 1 ) @LastBalance = ItemBalance ,
                           @LastValue = ItemValue
        FROM     [dbo].[ROI_StockTransactionMaster]
        WHERE    ItemId = @ItemID
        AND      StoreId = @STId
        ORDER BY TransactionDate DESC;

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
                 ISNULL (@LastBalance, 0) + @PurchaseQty, @BillDate );

        SET @PurchaseTranId = SCOPE_IDENTITY ();


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
        VALUES ( @PurchaseTranId, @STId, @ItemID, ISNULL (@LastBalance, 0) + @PurchaseQty, @PurchaseRate ,
                 ISNULL (@LastBalance, 0) + @PurchaseQty, @SmallUnit ,
                 ISNULL (@LastValue, 0) + ( @PurchaseQty * @PurchaseRate / @Conversion), @BillDate );


        -- truncate TempPurchaseDetail after purchase is resolved/goods received & paid 
        IF EXISTS ( SELECT TOP ( 1 ) 1
                    FROM   dbo.ROI_PurchaseMain AS rpm
                           INNER JOIN dbo.ROI_PurchaseDetails AS rpd ON rpd.PurchaseMainID = rpm.PurchaseMainID
                    WHERE  rpd.ItemID = @ItemID
                    AND    rpm.PostedBy = 'systemAuto'
                    AND    rpd.PurchaseMainID = @PurchaseMainID )
            BEGIN

                DELETE tpd
                FROM   dbo.TempPurchaseDetail AS tpd
                WHERE  tpd.ItemID = @ItemID;

                IF NOT EXISTS ( SELECT TOP ( 1 ) 1
                                FROM   dbo.TempPurchaseDetail AS tpd )
                    BEGIN
					-- reset temp auto purchase
                        TRUNCATE TABLE dbo.TempPurchaseDetail;

                        UPDATE rpm
                        SET    rpm.PostedBy = 'system'
                        FROM   dbo.ROI_PurchaseMain AS rpm
                        WHERE  rpm.PostedBy = 'systemAuto';
                    END;
            END;
    END;

GO
