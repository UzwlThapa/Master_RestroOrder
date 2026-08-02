SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 11/10/2023
====================================

EXEC dbo.usp_SaveTransactionForSales @SalesMasterID = 88

*/
CREATE PROCEDURE [dbo].[usp_SaveTransactionForSales]
(@SalesMasterID INT)
AS
BEGIN

    --DEFAULT DECLARATION FROM COST CENTER GROUPS
    DECLARE @FoodFcid INT = 19;
    DECLARE @BarFcid INT = 20;
    DECLARE @BakeryFcid INT = 32;
    DECLARE @OtherSalesFcid INT = 24;

    DECLARE @PREFX NVARCHAR(10),
            @VoucherCount INT = 0,
            @VoucherTypeID INT = 16,
            @VoucherNo NVARCHAR(50) = N'',
            @SalesDiscount DECIMAL(18, 2) = 0,
            @AdvancePayment DECIMAL(18, 2) = 0,
            @code VARCHAR(10),
            @OrderMasterID INT,
            @DeliveryCharge DECIMAL(18, 2) = 0;
    DECLARE @CusID INT = 0;

    SELECT TOP (1)
           @CusID = CusID
    FROM dbo.RO_SalesPaymentMode
    WHERE salesMasterId = @SalesMasterID
    ORDER BY CusID;

    SET @code =
    (
        SELECT TOP (1) Code FROM dbo.RO_CompanyInfo ORDER BY Name
    );

    SELECT @OrderMasterID = OrderMasterId,
           @AdvancePayment = AdvancePayment
    FROM dbo.RO_SalesMaster
    WHERE salesMasterId = @SalesMasterID;

    SELECT @DeliveryCharge = ISNULL(sm.DeliveryCharge, 0)
    FROM dbo.RO_SalesMaster sm
        INNER JOIN dbo.RO_OrderMasters om
            ON om.OrderMasterID = sm.OrderMasterId
    WHERE sm.salesMasterId = @SalesMasterID;


    -- update order master bill paid status
    --UPDATE rom
    --SET    rom.BillPaid = 1
    --FROM   dbo.RO_OrderMasters AS rom
    --WHERE  rom.OrderMasterID = @OrderMasterID;

    SELECT @PREFX = Prefix,
           @VoucherCount = VoucherCount
    FROM dbo.Ac_VoucherType
    WHERE VoucherTypeID = @VoucherTypeID;

    SET @VoucherCount = @VoucherCount + 1;

    SET @VoucherNo = @PREFX + N'-' + CAST(@VoucherCount AS VARCHAR(20));
    UPDATE Ac_VoucherType
    SET VoucherCount = @VoucherCount
    WHERE VoucherTypeID = @VoucherTypeID;

    DECLARE @BillDate DATETIME,
            @Description NVARCHAR(256) = N'';

    SELECT @BillDate = SM.BillDate,
           @Description
               = ('Sales Bill No :- ' + @code
                  + (CONVERT(NVARCHAR(10), FY.fyName) + '-'
                     + CONVERT(NVARCHAR(10), (SM.InvoiceNo - (FY.FirstSalesMasterID)))
                    )
                 )
    FROM dbo.RO_SalesMaster SM
        INNER JOIN dbo.RO_fiscalYear FY
            ON SM.FiscalYearID = FY.fyId
               AND SM.salesMasterId = @SalesMasterID;

    DECLARE @TransactionID INT = 0;

    INSERT INTO dbo.Ac_TempTransaction
    (
        TransactionDate,
        BillDate,
        VoucherTypeID,
        VoucherNo,
        Descriptions,
        PostedBy,
        PostedOn,
        SalesMasterId
    )
    VALUES
    (@BillDate, @BillDate, @VoucherTypeID, @VoucherNo, @Description, 'System', @BillDate, @SalesMasterID);

    SET @TransactionID = SCOPE_IDENTITY();

    DECLARE @DiscountMethod BIT = 0,
            @Discount DECIMAL(16, 2);


    -- Food Sales 
    DECLARE @FoodSales DECIMAL(16, 2) = 0;
    DECLARE @ExtraFoodSales DECIMAL(16, 2) = 0;

    SELECT @FoodSales = SUM(sd.rate * sd.qty)
    FROM dbo.RO_SalesDetail sd
        LEFT JOIN dbo.CostCenterInfo CC
            ON sd.CostCenterId = CC.CostCenterId
        LEFT JOIN dbo.RO_CostCenterGroup CCG
            ON CC.GroupId = CCG.GroupId
    WHERE sd.salesMasterId = @SalesMasterID
          AND sd.IsCombo = 0
          AND CCG.FinancialAcId = @FoodFcid;

    SELECT @ExtraFoodSales = ISNULL(SUM(sde.Rate * sde.Quantity), 0)
    FROM dbo.RO_SalesDetailExtra sde
        INNER JOIN dbo.RO_SalesDetail sd
            ON sd.salesDetailId = sde.SalesDetailsId
        LEFT JOIN dbo.CostCenterInfo CC
            ON sd.CostCenterId = CC.CostCenterId
        LEFT JOIN dbo.RO_CostCenterGroup CCG
            ON CC.GroupId = CCG.GroupId
    WHERE sd.salesMasterId = @SalesMasterID
          AND sd.IsCombo = 0
          AND CCG.FinancialAcId = @FoodFcid;

    IF @FoodSales IS NOT NULL
    BEGIN
        SELECT TOP (1)
               @DiscountMethod = CASE
                                     WHEN r.isLoyalty = 1 THEN
                                         0
                                     WHEN r.isLoyalty = 0 THEN
                                         r.isflatdis
                                     ELSE
                                         NULL
                                 END,
               @Discount = CASE
                               WHEN r.isLoyalty = 1 THEN
                                   CONVERT(   DECIMAL(16, 2),
                                              CASE
                                                  WHEN r.loyaltydis = '' THEN
                                                      '0'
                                                  ELSE
                                                      r.loyaltydis
                                              END
                                          )
                               WHEN r.isLoyalty = 0 THEN
                                   ISNULL(r.kotdis, 0)
                               ELSE
                                   NULL
                           END
        FROM dbo.ro_flatandPerDiscount r
        WHERE SalesMasterId = @SalesMasterID
        ORDER BY SalesMasterId;

        IF @DiscountMethod = 0
            SET @SalesDiscount = @SalesDiscount + ((@FoodSales + @ExtraFoodSales) * (@Discount / 100));
        ELSE
            SET @SalesDiscount = @SalesDiscount + @Discount;

        INSERT INTO dbo.Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (@TransactionID, @FoodFcid, NULL, 'Food Sales(KOT)', 0, @FoodSales + @ExtraFoodSales);
    END;

    -- BAR Sales
    SET @FoodSales = NULL;
    SET @ExtraFoodSales = NULL;

    SELECT @FoodSales = SUM(SD.rate * SD.qty)
    FROM dbo.RO_SalesDetail SD
        LEFT JOIN dbo.CostCenterInfo CC
            ON SD.CostCenterId = CC.CostCenterId
        LEFT JOIN dbo.RO_CostCenterGroup CCG
            ON CC.GroupId = CCG.GroupId
    WHERE SD.salesMasterId = @SalesMasterID
          AND SD.IsCombo = 0
          AND CCG.FinancialAcId = @BarFcid;

    SELECT @ExtraFoodSales = ISNULL(SUM(sde.Rate * sde.Quantity), 0)
    FROM dbo.RO_SalesDetailExtra sde
        INNER JOIN dbo.RO_SalesDetail sd
            ON sd.salesDetailId = sde.SalesDetailsId
        LEFT JOIN dbo.CostCenterInfo CC
            ON sd.CostCenterId = CC.CostCenterId
        LEFT JOIN dbo.RO_CostCenterGroup CCG
            ON CC.GroupId = CCG.GroupId
    WHERE sd.salesMasterId = @SalesMasterID
          AND sd.IsCombo = 0
          AND CCG.FinancialAcId = @BarFcid;

    IF @FoodSales IS NOT NULL
    BEGIN
        SELECT TOP 1
               @DiscountMethod = CASE
                                     WHEN isLoyalty = 1 THEN
                                         0
                                     WHEN isLoyalty = 0 THEN
                                         isflatdis
                                 END,
               @Discount = CASE
                               WHEN isLoyalty = 1 THEN
                                   CONVERT(   DECIMAL(16, 2),
                                              CASE
                                                  WHEN loyaltydis = '' THEN
                                                      '0'
                                                  ELSE
                                                      loyaltydis
                                              END
                                          )
                               WHEN isLoyalty = 0 THEN
                                   ISNULL(bardis, 0)
                           END
        FROM dbo.ro_flatandPerDiscount
        WHERE SalesMasterId = @SalesMasterID;

        IF @DiscountMethod = 0
            SET @SalesDiscount = @SalesDiscount + ((@FoodSales + @ExtraFoodSales) * (@Discount / 100));
        ELSE
            SET @SalesDiscount = @SalesDiscount + @Discount;

        INSERT INTO dbo.Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (@TransactionID, @BarFcid, NULL, 'BAR Item Sales(BOT)', 0, @FoodSales + @ExtraFoodSales);
    END;

    -- Bakery Cafe Sales
    SET @FoodSales = NULL;
    SET @ExtraFoodSales = NULL;

    SELECT @FoodSales = SUM(SD.rate * SD.qty)
    FROM dbo.RO_SalesDetail SD
        LEFT JOIN dbo.CostCenterInfo CC
            ON SD.CostCenterId = CC.CostCenterId
        LEFT JOIN dbo.RO_CostCenterGroup CCG
            ON CC.GroupId = CCG.GroupId
    WHERE SD.salesMasterId = @SalesMasterID
          AND SD.IsCombo = 0
          AND CCG.FinancialAcId = @BakeryFcid;

    SELECT @ExtraFoodSales = ISNULL(SUM(sde.Rate * sde.Quantity), 0)
    FROM dbo.RO_SalesDetailExtra sde
        INNER JOIN dbo.RO_SalesDetail sd
            ON sd.salesDetailId = sde.SalesDetailsId
        LEFT JOIN dbo.CostCenterInfo CC
            ON sd.CostCenterId = CC.CostCenterId
        LEFT JOIN dbo.RO_CostCenterGroup CCG
            ON CC.GroupId = CCG.GroupId
    WHERE sd.salesMasterId = @SalesMasterID
          AND sd.IsCombo = 0
          AND CCG.FinancialAcId = @BakeryFcid;

    IF @FoodSales IS NOT NULL
    BEGIN
        SELECT TOP 1
               @DiscountMethod = CASE
                                     WHEN isLoyalty = 1 THEN
                                         0
                                     WHEN isLoyalty = 0 THEN
                                         isflatdis
                                 END,
               @Discount = CASE
                               WHEN isLoyalty = 1 THEN
                                   CONVERT(   DECIMAL(16, 2),
                                              CASE
                                                  WHEN loyaltydis = '' THEN
                                                      '0'
                                                  ELSE
                                                      loyaltydis
                                              END
                                          )
                               WHEN isLoyalty = 0 THEN
                                   ISNULL(bakerydis, 0)
                           END
        FROM dbo.ro_flatandPerDiscount
        WHERE SalesMasterId = @SalesMasterID;

        IF @DiscountMethod = 0
            SET @SalesDiscount = @SalesDiscount + ((@FoodSales + @ExtraFoodSales) * (@Discount / 100));
        ELSE
            SET @SalesDiscount = @SalesDiscount + @Discount;

        INSERT INTO dbo.Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (@TransactionID, @BakeryFcid, NULL, 'Bakery Cafe Sales  ', 0, @FoodSales + @ExtraFoodSales);
    END;

    -- Other Sales
    SET @FoodSales = NULL;
    SET @ExtraFoodSales = NULL;

    SELECT @FoodSales = SUM(SD.rate * SD.qty)
    FROM dbo.RO_SalesDetail SD
        LEFT JOIN dbo.CostCenterInfo CC
            ON SD.CostCenterId = CC.CostCenterId
        LEFT JOIN dbo.RO_CostCenterGroup CCG
            ON CC.GroupId = CCG.GroupId
    WHERE SD.salesMasterId = @SalesMasterID
          AND SD.IsCombo = 0
          AND CCG.FinancialAcId = @OtherSalesFcid;

    SELECT @ExtraFoodSales = ISNULL(SUM(sde.Rate * sde.Quantity), 0)
    FROM dbo.RO_SalesDetailExtra sde
        INNER JOIN dbo.RO_SalesDetail sd
            ON sd.salesDetailId = sde.SalesDetailsId
        LEFT JOIN dbo.CostCenterInfo CC
            ON sd.CostCenterId = CC.CostCenterId
        LEFT JOIN dbo.RO_CostCenterGroup CCG
            ON CC.GroupId = CCG.GroupId
    WHERE sd.salesMasterId = @SalesMasterID
          AND sd.IsCombo = 0
          AND CCG.FinancialAcId = @OtherSalesFcid;

    IF @FoodSales IS NOT NULL
    BEGIN
        SELECT TOP 1
               @DiscountMethod = CASE
                                     WHEN isLoyalty = 1 THEN
                                         0
                                     WHEN isLoyalty = 0 THEN
                                         isflatdis
                                 END,
               @Discount = CASE
                               WHEN isLoyalty = 1 THEN
                                   CONVERT(   DECIMAL(16, 2),
                                              CASE
                                                  WHEN loyaltydis = '' THEN
                                                      '0'
                                                  ELSE
                                                      loyaltydis
                                              END
                                          )
                               WHEN isLoyalty = 0 THEN
                                   ISNULL(pizzadis, 0)
                           END
        FROM dbo.ro_flatandPerDiscount
        WHERE SalesMasterId = @SalesMasterID;

        IF @DiscountMethod = 0
            SET @SalesDiscount = @SalesDiscount + ((@FoodSales + @ExtraFoodSales) * (@Discount / 100));
        ELSE
            SET @SalesDiscount = @SalesDiscount + @Discount;

        INSERT INTO dbo.Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (@TransactionID, @OtherSalesFcid, NULL, 'Other Sales  ', 0, @FoodSales + @ExtraFoodSales);
    END;

    -- Combo Sales
    SET @FoodSales = NULL;

    SELECT @FoodSales = SUM(rate * qty)
    FROM dbo.RO_SalesDetail
    WHERE salesMasterId = @SalesMasterID
          AND IsCombo = 1;

    IF @FoodSales IS NOT NULL
    BEGIN
        SELECT TOP 1
               @DiscountMethod = CASE
                                     WHEN isLoyalty = 1 THEN
                                         0
                                     WHEN isLoyalty = 0 THEN
                                         isflatdis
                                 END,
               @Discount = CASE
                               WHEN isLoyalty = 1 THEN
                                   CONVERT(   DECIMAL(16, 2),
                                              CASE
                                                  WHEN loyaltydis = '' THEN
                                                      '0'
                                                  ELSE
                                                      loyaltydis
                                              END
                                          )
                               WHEN isLoyalty = 0 THEN
                                   ISNULL(bakerydis, 0)
                           END
        FROM dbo.ro_flatandPerDiscount
        WHERE SalesMasterId = @SalesMasterID;

        IF @DiscountMethod = 0
            SET @SalesDiscount = @SalesDiscount + (@FoodSales * (@Discount / 100));
        ELSE
            SET @SalesDiscount = @SalesDiscount + @Discount;

        INSERT INTO dbo.Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (@TransactionID, 33, NULL, 'Combo Sales  ', 0, @FoodSales);
    END;

    -- Room Sales
    SET @FoodSales = NULL;

    SELECT @FoodSales = SUM(Rate * BookedDays)
    FROM dbo.Ro_RoomBookings
    WHERE OrderMasterId = @OrderMasterID;

    IF @FoodSales IS NOT NULL
    BEGIN
        SELECT TOP 1
               @DiscountMethod = CASE
                                     WHEN isLoyalty = 1 THEN
                                         0
                                     WHEN isLoyalty = 0 THEN
                                         isflatdis
                                 END,
               @Discount = CASE
                               WHEN isLoyalty = 1 THEN
                                   CONVERT(   DECIMAL(16, 2),
                                              CASE
                                                  WHEN loyaltydis = '' THEN
                                                      '0'
                                                  ELSE
                                                      loyaltydis
                                              END
                                          )
                               WHEN isLoyalty = 0 THEN
                                   ISNULL(roomdis, 0)
                           END
        FROM dbo.ro_flatandPerDiscount
        WHERE SalesMasterId = @SalesMasterID;

        IF @DiscountMethod = 0
            SET @SalesDiscount = @SalesDiscount + (@FoodSales * (@Discount / 100));
        ELSE
            SET @SalesDiscount = @SalesDiscount + @Discount;

        INSERT INTO dbo.Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (@TransactionID, 22, NULL, 'Room ', 0, @FoodSales);
    END;

    -- Sales Discount
    IF ISNULL(@SalesDiscount, 0) <> 0
        INSERT INTO dbo.Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (@TransactionID, 42, NULL, 'Total Discount ', @SalesDiscount, 0);

    -- Service Charge
    SET @FoodSales = NULL;

    SELECT @FoodSales = Amount
    FROM dbo.RO_BillingAmount
    WHERE SalesMasterID = @SalesMasterID
          AND BilingID = 62;

    --IF @FoodSales IS NOT NULL
    IF ISNULL(@FoodSales, 0) <> 0
        INSERT INTO dbo.Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (@TransactionID, 31, NULL, 'Service Charge ', 0, @FoodSales);

    -- Other Charge
    SET @FoodSales = NULL;

    SELECT @FoodSales = SUM(Amount)
    FROM dbo.RO_BillingAmount
    WHERE SalesMasterID = @SalesMasterID
          AND IsVoid = 0
          AND BilingID NOT IN ( 1, 62, 54 );

    --IF @FoodSales IS NOT NULL
    IF ISNULL(@FoodSales, 0) <> 0
        INSERT INTO dbo.Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (@TransactionID, 44, NULL, 'Other Charges ', 0, @FoodSales);



    -- Delivery Charge
    IF ISNULL(@DeliveryCharge, 0) <> 0
        INSERT INTO dbo.Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (@TransactionID, 132, NULL, 'Delivery Charges ', 0, @DeliveryCharge);

    -- Other Discount
    SET @FoodSales = NULL;

    SELECT @FoodSales = SUM(Amount)
    FROM dbo.RO_BillingAmount
    WHERE SalesMasterID = @SalesMasterID
          AND IsVoid = 1
          AND BilingID NOT IN ( 1, 62, 54 );

    --IF @FoodSales IS NOT NULL
    IF ISNULL(@FoodSales, 0) <> 0
        INSERT INTO dbo.Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (@TransactionID, 44, NULL, 'Other Discounts ', @FoodSales, 0);

    -- VAT 
    SET @FoodSales = NULL;

    DECLARE @Percentage DECIMAL(18, 2) = 0;

    SELECT @FoodSales = Amount
    FROM dbo.RO_BillingAmount
    WHERE SalesMasterID = @SalesMasterID
          AND BilingID = 54;

    --SET @FoodSales = @FoodSales * @Percentage / 100
    IF ISNULL(@FoodSales, 0) <> 0
        INSERT INTO dbo.Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (@TransactionID, 30, NULL, 'VAT ', 0, @FoodSales);

    DECLARE @NetAmount DECIMAL(18, 2),
            @FinancialAcID INT,
            @CustFinancialAcID INT,
            @provFinancialAcID INT,
            @paymentMode INT,
            @PayAmount DECIMAL(18, 2),
            @TotalPayAmount DECIMAL(18, 2);
    DECLARE @CreditParty NVARCHAR(256),
            @TransactionNo NVARCHAR(256);
    DECLARE @MembershipID INT = 0;

    SELECT @NetAmount = NetAmount
    FROM dbo.RO_SalesMaster
    WHERE salesMasterId = @SalesMasterID;

    SELECT @TotalPayAmount = SUM(PayAmount)
    FROM dbo.RO_SalesPaymentMode
    WHERE salesMasterId = @SalesMasterID;

    DECLARE @MyCursor CURSOR;
    DECLARE @MyField INT;
    SET @MyCursor = CURSOR FOR
    SELECT spm.salesPaymentID
    FROM dbo.RO_SalesPaymentMode spm
    WHERE spm.salesMasterId = @SalesMasterID;

    OPEN @MyCursor;

    FETCH NEXT FROM @MyCursor
    INTO @MyField;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @PayAmount = NULL;

        SELECT @PayAmount = spm.PayAmount,
               @paymentMode = spm.PaymentModeID,
               @MembershipID = spm.CusID,
               @CreditParty = spm.Customer,
               @CustFinancialAcID = lm.FinancialAcId,
               @provFinancialAcID = cp.FinancialAcId,
               @TransactionNo = (CASE
                                     WHEN spm.PaymentModeID = 2 THEN
                                         spm.ChequeNo
                                     WHEN spm.PaymentModeID = 3 THEN
                                         spm.TransactionNo
                                     WHEN spm.PaymentModeID = 5 THEN
                                         spm.TransactionNo
                                     WHEN spm.PaymentModeID = 6 THEN
                                         spm.TransactionNo
                                     ELSE
                                         NULL
                                 END
                                )
        FROM dbo.RO_SalesPaymentMode spm
            LEFT JOIN dbo.RO_LoyaltyMembership lm
                ON spm.CusID = lm.MembershipID
            LEFT JOIN dbo.RO_CardProvider cp
                ON cp.ProviderID = spm.ProviderID
        WHERE spm.salesPaymentID = @MyField;

        IF ISNULL(@PayAmount, 0) <> 0
        BEGIN
            SET @FinancialAcID = CASE
                                     WHEN @paymentMode = 1 THEN
                                         10
                                     WHEN @paymentMode = 4 THEN
                                         @CustFinancialAcID
                                     ELSE
                                         @provFinancialAcID
                                 END;

            INSERT INTO dbo.Ac_TempTransactionDetail
            (
                TransactionID,
                FinancialAcID,
                MemberShipID,
                Particulars,
                Debit,
                Credit
            )
            VALUES
            (   @TransactionID, ISNULL(@FinancialAcID, 15), @MembershipID,
                CASE
                    WHEN @paymentMode = 1 THEN
                        'Cash Received '
                    WHEN @paymentMode = 4 THEN
                        'Credit Party - ' + @CreditParty
                    WHEN @paymentMode = 5 THEN
                        'eSewa - ' + @TransactionNo
                    WHEN @paymentMode = 6 THEN
                        'fonepay - ' + @TransactionNo
                    ELSE
                        'Bank Transaction - ' + @TransactionNo
                END, CASE
                         WHEN @paymentMode = 4 THEN
                             @PayAmount --+ @AdvancePayment
                         ELSE
                             @PayAmount
                     END, 0);
        END;


        FETCH NEXT FROM @MyCursor
        INTO @MyField;
    END;

    CLOSE @MyCursor;

    DEALLOCATE @MyCursor;

    DECLARE @PayAmt DECIMAL(18, 2),
            @ReturnPayment DECIMAL(18, 2);

    SELECT @PayAmt = SUM(PayAmount)
    FROM dbo.RO_SalesPaymentMode
    WHERE salesMasterId = @SalesMasterID
          AND PaymentModeID <> 4;
    SELECT @ReturnPayment = ReturnPayment
    FROM dbo.RO_SalesPaymentMode
    WHERE salesMasterId = @SalesMasterID;

    --IF EXISTS (select * from RO_SalesPaymentMode where salesMasterId = @SalesMasterID and PaymentModeID = 4)
    IF (@AdvancePayment > 0 AND @AdvancePayment > @NetAmount)
    BEGIN

        INSERT INTO dbo.Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (@TransactionID, ISNULL(@CustFinancialAcID, 15), @MembershipID,
         'Credit Party - ' + @CreditParty + ' - From Advance payment', @NetAmount, 0);
    END;

    ELSE IF (@AdvancePayment > 0 AND @AdvancePayment <= @NetAmount)
    BEGIN

        INSERT INTO dbo.Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (@TransactionID, ISNULL(@CustFinancialAcID, 15), @MembershipID,
         'From Advance payment: To Credit Party - ' + @CreditParty, @AdvancePayment, 0);
    END;



    IF (
           @NetAmount <> @TotalPayAmount + ISNULL(@AdvancePayment, 0)
           AND @CusID < 0
       )
    BEGIN
        INSERT INTO dbo.Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (   @TransactionID, 43, NULL, CASE
                                          WHEN @NetAmount > @TotalPayAmount THEN
                                              'Deficit Amount Received'
                                          ELSE
                                              'Surplus Amount Received '
                                      END, CASE
                                               WHEN @NetAmount > @TotalPayAmount + @AdvancePayment THEN
                                                   @NetAmount - @TotalPayAmount - @AdvancePayment
                                               ELSE
                                                   0
                                           END, CASE
                                                    WHEN @NetAmount < @TotalPayAmount + @AdvancePayment THEN
                                                        @AdvancePayment - @NetAmount + @TotalPayAmount
                                                    ELSE
                                                        0
                                                END);
    END;
    ELSE IF (
                @NetAmount <> @TotalPayAmount + ISNULL(@AdvancePayment, 0)
                AND ISNULL(@AdvancePayment, 0) < @NetAmount
            )
    BEGIN
        INSERT INTO dbo.Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (   @TransactionID, 43, NULL, CASE
                                          WHEN @NetAmount > @TotalPayAmount THEN
                                              'Deficit Amount Received'
                                          ELSE
                                              'Surplus Amount Received '
                                      END, CASE
                                               WHEN @NetAmount > @TotalPayAmount + @AdvancePayment THEN
                                                   @NetAmount - @TotalPayAmount - @AdvancePayment
                                               ELSE
                                                   0
                                           END, CASE
                                                    WHEN @NetAmount < @TotalPayAmount + @AdvancePayment THEN
                                                        @AdvancePayment - @NetAmount + @TotalPayAmount
                                                    ELSE
                                                        0
                                                END);
    END;

END;


GO
