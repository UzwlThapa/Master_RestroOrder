SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- usp_SaveTransactionForSales 88
-- drop PROC [dbo].[usp_SaveTransactionForSales] 46
CREATE PROCEDURE [dbo].[usp_SaveTransactionForSalesReturn]
    @SalesMasterID INT
AS
    BEGIN

        --DEFAULT DECLARATION FROM COST CENTER GROUPS
        DECLARE @FoodFcid INT = 19;
        DECLARE @BarFcid INT = 20;
        DECLARE @BakeryFcid INT = 32;
        DECLARE @OtherSalesFcid INT = 24;

        DECLARE @PREFX NVARCHAR (10) ,
                @VoucherCount INT = 0 ,
                @VoucherTypeID INT = 16 ,
                @VoucherNo NVARCHAR (50) = N'' ,
                @SalesDiscount DECIMAL (18, 2) = 0 ,
                @AdvancePayment DECIMAL (18, 2) = 0 ,
                @code VARCHAR (10) ,
                @OrderMasterID INT ,
                @membername NVARCHAR (250) ,
                @DeliveryCharge DECIMAL (18, 2) = 0;

        DECLARE @CusID INT = 0 ,
                @custAcId INT;

        SELECT TOP 1 @CusID = CusID
        FROM   dbo.RO_SalesPaymentMode
        WHERE  salesMasterId = @SalesMasterID;
        IF ( @CusID <> 0 )
            BEGIN
                SELECT @custAcId = FinancialAcId
                FROM   dbo.RO_LoyaltyMembership lm
                WHERE  lm.MembershipID = @CusID
                AND    ISNULL (IsArchived, 0) <> 1;
            END;
        ELSE
            BEGIN
                SET @custAcId = 28;
            END;

        SET @code = ( SELECT TOP ( 1 ) Code
                      FROM   dbo.RO_CompanyInfo );

        SELECT @OrderMasterID = OrderMasterId ,
               @AdvancePayment = AdvancePayment
        FROM   dbo.RO_SalesMaster
        WHERE  salesMasterId = @SalesMasterID;

        SELECT @membername = rm.CustomerName
        FROM   dbo.Ro_RoomBookings rm
               INNER JOIN dbo.RO_OrderMasters om ON om.OrderMasterID = rm.OrderMasterId
               INNER JOIN dbo.RO_SalesMaster sm ON sm.OrderMasterId = om.OrderMasterID
        WHERE  sm.salesMasterId = @SalesMasterID;

        SELECT @DeliveryCharge = ISNULL (sm.DeliveryCharge, 0)
        FROM   dbo.RO_SalesMaster sm
               INNER JOIN dbo.RO_OrderMasters om ON om.OrderMasterID = sm.OrderMasterId
        WHERE  sm.salesMasterId = @SalesMasterID;

        SELECT @PREFX = Prefix ,
               @VoucherCount = VoucherCount
        FROM   dbo.Ac_VoucherType
        WHERE  VoucherTypeID = @VoucherTypeID;

        SET @VoucherCount = @VoucherCount + 1;

        SET @VoucherNo = @PREFX + N'-' + CAST(@VoucherCount AS VARCHAR (20));

        DECLARE @BillDate DATETIME ,
                @Description NVARCHAR (256) = N'';

        SELECT @BillDate = SM.BillDate ,
               @Description = ( 'Sales Return Bill No :- ' + @code
                                + ( CONVERT (NVARCHAR (10), FY.fyName) + '-'
                                    + CONVERT (NVARCHAR (10), ( SM.InvoiceNo - ( FY.FirstSalesMasterID )))))
        FROM   dbo.RO_SalesMaster SM
               INNER JOIN dbo.RO_fiscalYear FY ON  SM.FiscalYearID = FY.fyId
                                               AND SM.salesMasterId = @SalesMasterID;

        DECLARE @TransactionID INT = 0;

        INSERT INTO dbo.Ac_TempTransaction ( TransactionDate ,
                                             VoucherTypeID ,
                                             VoucherNo ,
                                             Descriptions ,
                                             PostedBy ,
                                             PostedOn )
        VALUES ( @BillDate, @VoucherTypeID, @VoucherNo, @Description, 'System', @BillDate );

        SET @TransactionID = SCOPE_IDENTITY ();

        DECLARE @DiscountMethod BIT = 0 ,
                @Discount DECIMAL (16, 2);

        -- Food Sales

        DECLARE @FoodSales DECIMAL (16, 2) = 0;
        DECLARE @ExtraFoodSales DECIMAL (16, 2) = 0;

        SELECT @FoodSales = SUM (sd.rate * sd.qty)
        FROM   dbo.RO_SalesDetail sd
               LEFT JOIN dbo.CostCenterInfo CC ON sd.CostCenterId = CC.CostCenterId
               LEFT JOIN dbo.RO_CostCenterGroup CCG ON CC.GroupId = CCG.GroupId
        WHERE  sd.salesMasterId = @SalesMasterID
        AND    sd.IsCombo = 0
        AND    CCG.FinancialAcId = @FoodFcid;

        SELECT @ExtraFoodSales = ISNULL (SUM (sde.Rate * sde.Quantity), 0)
        FROM   dbo.RO_SalesDetailExtra sde
               INNER JOIN dbo.RO_SalesDetail sd ON sd.salesDetailId = sde.SalesDetailsId
               LEFT JOIN dbo.CostCenterInfo CC ON sd.CostCenterId = CC.CostCenterId
               LEFT JOIN dbo.RO_CostCenterGroup CCG ON CC.GroupId = CCG.GroupId
        WHERE  sd.salesMasterId = @SalesMasterID
        AND    sd.IsCombo = 0
        AND    CCG.FinancialAcId = @FoodFcid;

        IF @FoodSales IS NOT NULL
            BEGIN
                SELECT TOP 1 @DiscountMethod = CASE WHEN isLoyalty = 1 THEN 0
                                                    WHEN isLoyalty = 0 THEN isflatdis
                                               END ,
                             @Discount = CASE WHEN isLoyalty = 1 THEN
                                                  CONVERT (DECIMAL (16, 2) ,
                                                           CASE WHEN loyaltydis = '' THEN '0'
                                                                ELSE loyaltydis
                                                           END)
                                              WHEN isLoyalty = 0 THEN
                                                  CONVERT (DECIMAL (16, 2) ,
                                                           CASE WHEN kotdis = '' THEN '0'
                                                                ELSE kotdis
                                                           END)
                                         END
                FROM   dbo.ro_flatandPerDiscount
                WHERE  SalesMasterId = @SalesMasterID;

                IF @DiscountMethod = 0
                    SET @SalesDiscount = @SalesDiscount + (( @FoodSales + @ExtraFoodSales ) * ( @Discount / 100 ));
                ELSE
                    SET @SalesDiscount = @SalesDiscount + @Discount;

                INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                           FinancialAcID ,
                                                           MemberShipID ,
                                                           Particulars ,
                                                           Debit ,
                                                           Credit )
                VALUES ( @TransactionID, @FoodFcid, NULL, 'Sales Return - Food Sales(KOT)' ,
                         @FoodSales + @ExtraFoodSales, 0 );
            END;

        -- BAR Sales
        SET @FoodSales = NULL;
        SET @ExtraFoodSales = NULL;

        SELECT @FoodSales = SUM (SD.rate * SD.qty)
        FROM   dbo.RO_SalesDetail SD
               LEFT JOIN dbo.CostCenterInfo CC ON SD.CostCenterId = CC.CostCenterId
               LEFT JOIN dbo.RO_CostCenterGroup CCG ON CC.GroupId = CCG.GroupId
        WHERE  SD.salesMasterId = @SalesMasterID
        AND    SD.IsCombo = 0
        AND    CCG.FinancialAcId = @BarFcid;

        SELECT @ExtraFoodSales = ISNULL (SUM (sde.Rate * sde.Quantity), 0)
        FROM   dbo.RO_SalesDetailExtra sde
               INNER JOIN dbo.RO_SalesDetail sd ON sd.salesDetailId = sde.SalesDetailsId
               LEFT JOIN dbo.CostCenterInfo CC ON sd.CostCenterId = CC.CostCenterId
               LEFT JOIN dbo.RO_CostCenterGroup CCG ON CC.GroupId = CCG.GroupId
        WHERE  sd.salesMasterId = @SalesMasterID
        AND    sd.IsCombo = 0
        AND    CCG.FinancialAcId = @BarFcid;

        IF @FoodSales IS NOT NULL
            BEGIN
                SELECT TOP 1 @DiscountMethod = CASE WHEN isLoyalty = 1 THEN 0
                                                    WHEN isLoyalty = 0 THEN isflatdis
                                               END ,
                             @Discount = CASE WHEN isLoyalty = 1 THEN
                                                  CONVERT (DECIMAL (16, 2) ,
                                                           CASE WHEN loyaltydis = '' THEN '0'
                                                                ELSE loyaltydis
                                                           END)
                                              WHEN isLoyalty = 0 THEN
                                                  CONVERT (DECIMAL (16, 2) ,
                                                           CASE WHEN bardis = '' THEN '0'
                                                                ELSE bardis
                                                           END)
                                         END
                FROM   dbo.ro_flatandPerDiscount
                WHERE  SalesMasterId = @SalesMasterID;

                IF @DiscountMethod = 0
                    SET @SalesDiscount = @SalesDiscount + (( @FoodSales + @ExtraFoodSales ) * ( @Discount / 100 ));
                ELSE
                    SET @SalesDiscount = @SalesDiscount + @Discount;

                INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                           FinancialAcID ,
                                                           MemberShipID ,
                                                           Particulars ,
                                                           Debit ,
                                                           Credit )
                VALUES ( @TransactionID, @BarFcid, NULL, 'Sales Return - BAR Item Sales(BOT)' ,
                         @FoodSales + @ExtraFoodSales, 0 );
            END;

        -- Bakery Cafe Sales
        SET @FoodSales = NULL;
        SET @ExtraFoodSales = NULL;

        SELECT @FoodSales = SUM (SD.rate * SD.qty)
        FROM   dbo.RO_SalesDetail SD
               LEFT JOIN dbo.CostCenterInfo CC ON SD.CostCenterId = CC.CostCenterId
               LEFT JOIN dbo.RO_CostCenterGroup CCG ON CC.GroupId = CCG.GroupId
        WHERE  SD.salesMasterId = @SalesMasterID
        AND    SD.IsCombo = 0
        AND    CCG.FinancialAcId = @BakeryFcid;

        SELECT @ExtraFoodSales = ISNULL (SUM (sde.Rate * sde.Quantity), 0)
        FROM   dbo.RO_SalesDetailExtra sde
               INNER JOIN dbo.RO_SalesDetail sd ON sd.salesDetailId = sde.SalesDetailsId
               LEFT JOIN dbo.CostCenterInfo CC ON sd.CostCenterId = CC.CostCenterId
               LEFT JOIN dbo.RO_CostCenterGroup CCG ON CC.GroupId = CCG.GroupId
        WHERE  sd.salesMasterId = @SalesMasterID
        AND    sd.IsCombo = 0
        AND    CCG.FinancialAcId = @BakeryFcid;

        IF @FoodSales IS NOT NULL
            BEGIN
                SELECT TOP 1 @DiscountMethod = CASE WHEN isLoyalty = 1 THEN 0
                                                    WHEN isLoyalty = 0 THEN isflatdis
                                               END ,
                             @Discount = CASE WHEN isLoyalty = 1 THEN
                                                  CONVERT (DECIMAL (16, 2) ,
                                                           CASE WHEN loyaltydis = '' THEN '0'
                                                                ELSE loyaltydis
                                                           END)
                                              WHEN isLoyalty = 0 THEN
                                                  CONVERT (DECIMAL (16, 2) ,
                                                           CASE WHEN bakerydis = '' THEN '0'
                                                                ELSE bakerydis
                                                           END)
                                         END
                FROM   dbo.ro_flatandPerDiscount
                WHERE  SalesMasterId = @SalesMasterID;

                IF @DiscountMethod = 0
                    SET @SalesDiscount = @SalesDiscount + (( @FoodSales + @ExtraFoodSales ) * ( @Discount / 100 ));
                ELSE
                    SET @SalesDiscount = @SalesDiscount + @Discount;

                INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                           FinancialAcID ,
                                                           MemberShipID ,
                                                           Particulars ,
                                                           Debit ,
                                                           Credit )
                VALUES ( @TransactionID, @BakeryFcid, NULL, 'Sales Return - Bakery Cafe Sales  ' ,
                         @FoodSales + @ExtraFoodSales, 0 );
            END;

        -- Other Sales
        SET @FoodSales = NULL;
        SET @ExtraFoodSales = NULL;

        SELECT @FoodSales = SUM (SD.rate * SD.qty)
        FROM   dbo.RO_SalesDetail SD
               LEFT JOIN dbo.CostCenterInfo CC ON SD.CostCenterId = CC.CostCenterId
               LEFT JOIN dbo.RO_CostCenterGroup CCG ON CC.GroupId = CCG.GroupId
        WHERE  SD.salesMasterId = @SalesMasterID
        AND    SD.IsCombo = 0
        AND    CCG.FinancialAcId = @OtherSalesFcid;

        SELECT @ExtraFoodSales = ISNULL (SUM (sde.Rate * sde.Quantity), 0)
        FROM   dbo.RO_SalesDetailExtra sde
               INNER JOIN dbo.RO_SalesDetail sd ON sd.salesDetailId = sde.SalesDetailsId
               LEFT JOIN dbo.CostCenterInfo CC ON sd.CostCenterId = CC.CostCenterId
               LEFT JOIN dbo.RO_CostCenterGroup CCG ON CC.GroupId = CCG.GroupId
        WHERE  sd.salesMasterId = @SalesMasterID
        AND    sd.IsCombo = 0
        AND    CCG.FinancialAcId = @OtherSalesFcid;

        IF @FoodSales IS NOT NULL
            BEGIN
                SELECT TOP 1 @DiscountMethod = CASE WHEN isLoyalty = 1 THEN 0
                                                    WHEN isLoyalty = 0 THEN isflatdis
                                               END ,
                             @Discount = CASE WHEN isLoyalty = 1 THEN
                                                  CONVERT (DECIMAL (16, 2) ,
                                                           CASE WHEN loyaltydis = '' THEN '0'
                                                                ELSE loyaltydis
                                                           END)
                                              WHEN isLoyalty = 0 THEN
                                                  CONVERT (DECIMAL (16, 2) ,
                                                           CASE WHEN pizzadis = '' THEN '0'
                                                                ELSE pizzadis
                                                           END)
                                         END
                FROM   dbo.ro_flatandPerDiscount
                WHERE  SalesMasterId = @SalesMasterID;

                IF @DiscountMethod = 0
                    SET @SalesDiscount = @SalesDiscount + (( @FoodSales + @ExtraFoodSales ) * ( @Discount / 100 ));
                ELSE
                    SET @SalesDiscount = @SalesDiscount + @Discount;

                INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                           FinancialAcID ,
                                                           MemberShipID ,
                                                           Particulars ,
                                                           Debit ,
                                                           Credit )
                VALUES ( @TransactionID, @OtherSalesFcid, NULL, 'Sales Return - Other Sales  ' ,
                         @FoodSales + @ExtraFoodSales, 0 );
            END;

        -- Combo Sales
        SET @FoodSales = NULL;

        SELECT @FoodSales = SUM (rate * qty)
        FROM   dbo.RO_SalesDetail
        WHERE  salesMasterId = @SalesMasterID
        AND    IsCombo = 1;

        IF @FoodSales IS NOT NULL
            BEGIN
                SELECT TOP 1 @DiscountMethod = CASE WHEN isLoyalty = 1 THEN 0
                                                    WHEN isLoyalty = 0 THEN isflatdis
                                               END ,
                             @Discount = CASE WHEN isLoyalty = 1 THEN
                                                  CONVERT (DECIMAL (16, 2) ,
                                                           CASE WHEN loyaltydis = '' THEN '0'
                                                                ELSE loyaltydis
                                                           END)
                                              WHEN isLoyalty = 0 THEN
                                                  CONVERT (DECIMAL (16, 2) ,
                                                           CASE WHEN bakerydis = '' THEN '0'
                                                                ELSE bakerydis
                                                           END)
                                         END
                FROM   dbo.ro_flatandPerDiscount
                WHERE  SalesMasterId = @SalesMasterID;

                IF @DiscountMethod = 0
                    SET @SalesDiscount = @SalesDiscount + ( @FoodSales * ( @Discount / 100 ));
                ELSE
                    SET @SalesDiscount = @SalesDiscount + @Discount;

                INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                           FinancialAcID ,
                                                           MemberShipID ,
                                                           Particulars ,
                                                           Debit ,
                                                           Credit )
                VALUES ( @TransactionID, 33, NULL, 'Sales Return - Combo Sales  ', 0, @FoodSales );
            END;

        -- Room Sales
        SET @FoodSales = NULL;

        SELECT @FoodSales = SUM (Rate * BookedDays)
        FROM   dbo.Ro_RoomBookings
        WHERE  OrderMasterId = @OrderMasterID;

        IF @FoodSales IS NOT NULL
            BEGIN
                SELECT TOP 1 @DiscountMethod = CASE WHEN isLoyalty = 1 THEN 0
                                                    WHEN isLoyalty = 0 THEN isflatdis
                                               END ,
                             @Discount = CASE WHEN isLoyalty = 1 THEN
                                                  CONVERT (DECIMAL (16, 2) ,
                                                           CASE WHEN loyaltydis = '' THEN '0'
                                                                ELSE loyaltydis
                                                           END)
                                              WHEN isLoyalty = 0 THEN
                                                  CONVERT (DECIMAL (16, 2) ,
                                                           CASE WHEN roomdis = '' THEN '0'
                                                                ELSE roomdis
                                                           END)
                                         END
                FROM   dbo.ro_flatandPerDiscount
                WHERE  SalesMasterId = @SalesMasterID;

                IF @DiscountMethod = 0
                    SET @SalesDiscount = @SalesDiscount + ( @FoodSales * ( @Discount / 100 ));
                ELSE
                    SET @SalesDiscount = @SalesDiscount + @Discount;

                INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                           FinancialAcID ,
                                                           MemberShipID ,
                                                           Particulars ,
                                                           Debit ,
                                                           Credit )
                VALUES ( @TransactionID, 22, NULL, 'Sales Return - Room ', @FoodSales, 0 );
            END;

        -- Sales Discount
        IF ISNULL (@SalesDiscount, 0) <> 0
            INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                       FinancialAcID ,
                                                       MemberShipID ,
                                                       Particulars ,
                                                       Debit ,
                                                       Credit )
            VALUES ( @TransactionID, 42, NULL, 'Sales Return - Total Discount ', 0, @SalesDiscount );

        -- Service Charge
        SET @FoodSales = NULL;

        SELECT @FoodSales = Amount
        FROM   dbo.RO_BillingAmount
        WHERE  SalesMasterID = @SalesMasterID
        AND    BilingID = 62;

        --IF @FoodSales IS NOT NULL
        IF ISNULL (@FoodSales, 0) <> 0
            INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                       FinancialAcID ,
                                                       MemberShipID ,
                                                       Particulars ,
                                                       Debit ,
                                                       Credit )
            VALUES ( @TransactionID, 31, NULL, 'Sales Return - Service Charge ', @FoodSales, 0 );

        -- Other Charge
        SET @FoodSales = NULL;

        SELECT @FoodSales = SUM (Amount)
        FROM   dbo.RO_BillingAmount
        WHERE  SalesMasterID = @SalesMasterID
        AND    IsVoid = 0
        AND    BilingID NOT IN ( 1, 62, 54 );

        --IF @FoodSales IS NOT NULL
        IF ISNULL (@FoodSales, 0) <> 0
            INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                       FinancialAcID ,
                                                       MemberShipID ,
                                                       Particulars ,
                                                       Debit ,
                                                       Credit )
            VALUES ( @TransactionID, 44, NULL, 'Sales Return - Other Charges ', @FoodSales, 0 );



        -- Delivery Charge
        IF ISNULL (@DeliveryCharge, 0) <> 0
            INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                       FinancialAcID ,
                                                       MemberShipID ,
                                                       Particulars ,
                                                       Debit ,
                                                       Credit )
            VALUES ( @TransactionID, 132, NULL, 'Sales Return - Delivery Charges ', @DeliveryCharge, 0 );

        -- Other Discount
        SET @FoodSales = NULL;

        SELECT @FoodSales = SUM (Amount)
        FROM   dbo.RO_BillingAmount
        WHERE  SalesMasterID = @SalesMasterID
        AND    IsVoid = 1
        AND    BilingID NOT IN ( 1, 62, 54 );

        --IF @FoodSales IS NOT NULL
        IF ISNULL (@FoodSales, 0) <> 0
            INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                       FinancialAcID ,
                                                       MemberShipID ,
                                                       Particulars ,
                                                       Debit ,
                                                       Credit )
            VALUES ( @TransactionID, 44, NULL, 'Sales Return - Other Discounts ', 0, @FoodSales );

        -- VAT 
        SET @FoodSales = NULL;

        DECLARE @Percentage DECIMAL (18, 2) = 0;

        SELECT @FoodSales = Amount
        FROM   dbo.RO_BillingAmount
        WHERE  SalesMasterID = @SalesMasterID
        AND    BilingID = 54;

        --SET @FoodSales = @FoodSales * @Percentage / 100
        IF ISNULL (@FoodSales, 0) <> 0
            INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                       FinancialAcID ,
                                                       MemberShipID ,
                                                       Particulars ,
                                                       Debit ,
                                                       Credit )
            VALUES ( @TransactionID, 30, NULL, 'Sales Return - VAT ', @FoodSales, 0 );

        DECLARE @NetAmount DECIMAL (18, 2) ,
                @FinancialAcID INT ,
                @CustFinancialAcID INT ,
                @provFinancialAcID INT ,
                @paymentMode INT ,
                @PayAmount DECIMAL (18, 2) ,
                @TotalPayAmount DECIMAL (18, 2);
        DECLARE @CreditParty NVARCHAR (256) ,
                @TransactionNo NVARCHAR (256);
        DECLARE @MembershipID INT = 0;

        SELECT @NetAmount = NetAmount
        FROM   dbo.RO_SalesMaster
        WHERE  salesMasterId = @SalesMasterID;

        SELECT @TotalPayAmount = SUM (PayAmount)
        FROM   dbo.RO_SalesPaymentMode
        WHERE  salesMasterId = @SalesMasterID;

        DECLARE @MyCursor CURSOR;
        DECLARE @MyField INT;
        SET @MyCursor = CURSOR FOR
        SELECT spm.salesPaymentID
        FROM   dbo.RO_SalesPaymentMode spm
        WHERE  spm.salesMasterId = @SalesMasterID;

        OPEN @MyCursor;

        FETCH NEXT FROM @MyCursor
        INTO @MyField;

        WHILE @@FETCH_STATUS = 0
            BEGIN
                SET @PayAmount = NULL;

                SELECT @PayAmount = spm.PayAmount ,
                       @paymentMode = spm.PaymentModeID ,
                       @MembershipID = spm.CusID ,
                       @CreditParty = spm.Customer ,
                       @CustFinancialAcID = lm.FinancialAcId ,
                       @provFinancialAcID = cp.FinancialAcId ,
                       @TransactionNo = ( CASE WHEN spm.PaymentModeID = 2 THEN spm.ChequeNo
                                               WHEN spm.PaymentModeID = 3 THEN spm.TransactionNo
                                               WHEN spm.PaymentModeID = 5 THEN spm.TransactionNo
                                               WHEN spm.PaymentModeID = 6 THEN spm.TransactionNo
                                               ELSE NULL
                                          END )
                FROM   dbo.RO_SalesPaymentMode spm
                       LEFT JOIN dbo.RO_LoyaltyMembership lm ON spm.CusID = lm.MembershipID
                       LEFT JOIN dbo.RO_CardProvider cp ON cp.ProviderID = spm.ProviderID
                WHERE  spm.salesPaymentID = @MyField;

                IF ISNULL (@PayAmount, 0) <> 0
                    BEGIN
                        SET @FinancialAcID = CASE WHEN @paymentMode = 1 THEN 10
                                                  WHEN @paymentMode = 4 THEN @CustFinancialAcID
                                                  ELSE @provFinancialAcID
                                             END;

                        INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                                   FinancialAcID ,
                                                                   MemberShipID ,
                                                                   Particulars ,
                                                                   Debit ,
                                                                   Credit )
                        VALUES ( @TransactionID, ISNULL (@FinancialAcID, 15), @MembershipID ,
                                 CASE WHEN @paymentMode = 1 THEN 'Sales Return - Cash '
                                      WHEN @paymentMode = 4 THEN 'Sales Return - Credit Party - ' + @CreditParty
                                      WHEN @paymentMode = 5 THEN 'Sales Return - eSewa - ' + @TransactionNo
                                      WHEN @paymentMode = 6 THEN 'Sales Return - fonepay - ' + @TransactionNo
                                      ELSE 'Sales Return - Bank Transaction - ' + @TransactionNo
                                 END, 0, CASE WHEN @paymentMode = 4 THEN @PayAmount --+ @AdvancePayment
                                              ELSE @PayAmount
                                         END );
                    END;


                FETCH NEXT FROM @MyCursor
                INTO @MyField;
            END;

        CLOSE @MyCursor;

        DEALLOCATE @MyCursor;

        DECLARE @PayAmt DECIMAL (18, 2) ,
                @ReturnPayment DECIMAL (18, 2);

        SELECT @PayAmt = SUM (PayAmount)
        FROM   dbo.RO_SalesPaymentMode
        WHERE  salesMasterId = @SalesMasterID
        AND    PaymentModeID <> 4;
        SELECT @ReturnPayment = ReturnPayment
        FROM   dbo.RO_SalesPaymentMode
        WHERE  salesMasterId = @SalesMasterID;

        IF ( @AdvancePayment > 0
         AND @AdvancePayment > @NetAmount )
            BEGIN

                INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                           FinancialAcID ,
                                                           MemberShipID ,
                                                           Particulars ,
                                                           Debit ,
                                                           Credit )
                VALUES ( @TransactionID, ISNULL (@CustFinancialAcID, 15), @MembershipID ,
                         'Credit Party - ' + @CreditParty + ' - From Advance payment', 0, @NetAmount );
            END;

        ELSE IF ( @AdvancePayment > 0
              AND @AdvancePayment <= @NetAmount )
                 BEGIN

                     INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                                FinancialAcID ,
                                                                MemberShipID ,
                                                                Particulars ,
                                                                Debit ,
                                                                Credit )
                     VALUES ( @TransactionID, ISNULL (@CustFinancialAcID, 15), @MembershipID ,
                              'From Advance payment: To Credit Party - ' + @CreditParty, 0, @AdvancePayment );
                 END;

        IF ( @NetAmount <> @TotalPayAmount + ISNULL (@AdvancePayment, 0)
         AND @CusID < 0 )
            BEGIN
                INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                           FinancialAcID ,
                                                           MemberShipID ,
                                                           Particulars ,
                                                           Debit ,
                                                           Credit )
                VALUES ( @TransactionID, 43, NULL ,
                         CASE WHEN @NetAmount > @TotalPayAmount THEN 'Sales Return - Deficit Amount'
                              ELSE 'Sales Return - Surplus Amount '
                         END ,
                         CASE WHEN @NetAmount < @TotalPayAmount + @AdvancePayment THEN
                                  @AdvancePayment - @NetAmount + @TotalPayAmount
                              ELSE 0
                         END ,
                         CASE WHEN @NetAmount > @TotalPayAmount + @AdvancePayment THEN
                                  @NetAmount - @TotalPayAmount - @AdvancePayment
                              ELSE 0
                         END );
            END;
        ELSE IF ( @NetAmount <> @TotalPayAmount + ISNULL (@AdvancePayment, 0)
              AND ISNULL (@AdvancePayment, 0) < @NetAmount )
                 BEGIN
                     INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                                FinancialAcID ,
                                                                MemberShipID ,
                                                                Particulars ,
                                                                Debit ,
                                                                Credit )
                     VALUES ( @TransactionID, 43, NULL ,
                              CASE WHEN @NetAmount > @TotalPayAmount THEN 'Sales Return - Deficit Amount'
                                   ELSE 'Sales Return - Surplus Amount'
                              END ,
                              CASE WHEN @NetAmount < @TotalPayAmount + @AdvancePayment THEN
                                       @AdvancePayment - @NetAmount + @TotalPayAmount
                                   ELSE 0
                              END ,
                              CASE WHEN @NetAmount > @TotalPayAmount + @AdvancePayment THEN
                                       @NetAmount - @TotalPayAmount - @AdvancePayment
                                   ELSE 0
                              END );
                 END;
    END;


GO
