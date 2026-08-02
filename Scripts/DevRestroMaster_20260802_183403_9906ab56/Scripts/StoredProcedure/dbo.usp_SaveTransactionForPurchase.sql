SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_SaveTransactionForPurchase] @GoodsReceivedMainID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PREFX NVARCHAR(10),
            @VoucherCount INT = 0,
            @VoucherTypeID INT = 16,
            @VoucherNo NVARCHAR(50) = N'';

    DECLARE @BillDate DATETIME,
            @Description NVARCHAR(256) = N'';

    DECLARE @TransactionID INT = 0;
    DECLARE @FoodSales DECIMAL(16, 2) = 0;
    DECLARE @MembershipID INT = 0;
    DECLARE @PayAmount DECIMAL(18, 2) = 0;
    DECLARE @netamount DECIMAL(18, 2) = 0;

    DECLARE @purchaseno NVARCHAR(25);
    DECLARE @PurchaseDiscount DECIMAL(10, 2) = 0;
    DECLARE @Discount DECIMAL(10, 2) = 0;
    DECLARE @ExtraDiscount DECIMAL(10, 2) = 0;
    DECLARE @NonVatTotal DECIMAL(10, 2) = 0;
    DECLARE @vatTotal DECIMAL(10, 2) = 0;
    DECLARE @vat DECIMAL(10, 2) = 0;
    DECLARE @vatDiscount DECIMAL(10, 2) = 0;
    DECLARE @TotalPayAmount DECIMAL(18, 2) = 0;

    DECLARE @GoodsStoreId INT = 0;

    -----------------------------------------------------
    -- Store Identification
    -----------------------------------------------------
    DECLARE @BarStoreId INT = 0;
    SELECT TOP 1
           @BarStoreId = STId
    FROM ROI_Store
    WHERE StName LIKE '%bar%';

    DECLARE @KitchenStoreId INT = 0;
    SELECT TOP 1
           @KitchenStoreId = STId
    FROM ROI_Store
    WHERE StName LIKE '%kitchen%';

    -----------------------------------------------------
    -- Financial Accounts
    -----------------------------------------------------
    DECLARE @BarFinancialAcId INT = 0,
            @BarFinancialAc NVARCHAR(MAX) = N'';

    SELECT TOP 1
           @BarFinancialAcId = FinancialAcID,
           @BarFinancialAc = Name
    FROM Ac_FinancialAc
    WHERE Name LIKE '%BAR PURCHASE A/C%';

    DECLARE @FoodFinancialAcId INT = 0,
            @FoodFinancialAc NVARCHAR(MAX) = N'';

    SELECT TOP 1
           @FoodFinancialAcId = FinancialAcID,
           @FoodFinancialAc = Name
    FROM Ac_FinancialAc
    WHERE Name LIKE '%FOOD PURCHASE A/C%';

    -----------------------------------------------------
    -- Purchase Info
    -----------------------------------------------------
    SELECT DISTINCT
           @purchaseno = PuNo
    FROM ROI_PurchaseMain pm
        JOIN ROI_PurchaseDetails pd
            ON pd.PurchaseMainID = pm.PurchaseMainID
        JOIN RO_GoodsReceivedDetls gd
            ON pd.PurchaseDetailsID = gd.PDId
    WHERE GMId = @GoodsReceivedMainID;

    SET @VoucherTypeID = 25;

    SELECT @PREFX = Prefix,
           @VoucherCount = VoucherCount
    FROM Ac_VoucherType
    WHERE VoucherTypeID = @VoucherTypeID;

    SET @VoucherCount = @VoucherCount + 1;
    SET @VoucherNo = @PREFX + N'-' + CAST(@VoucherCount AS VARCHAR(20));
    UPDATE Ac_VoucherType
    SET VoucherCount = @VoucherCount
    WHERE VoucherTypeID = @VoucherTypeID;

    SELECT @BillDate = InvoiceDate,
           @Description
               = N'Purchase No :- ' + @purchaseno + N' and Goods Receive No :-' + CAST(SM.GMNo AS NVARCHAR(20)),
           @GoodsStoreId = SM.STId
    FROM RO_GoodsReceivedMain SM
    WHERE GMId = @GoodsReceivedMainID;

    -----------------------------------------------------
    -- Amount Calculations
    -----------------------------------------------------
    SELECT @NonVatTotal = ISNULL(SUM(Total), 0)
    FROM RO_GoodsReceivedDetls
    WHERE GMId = @GoodsReceivedMainID
          AND
          (
              IsVat = 0
              OR IsVat IS NULL
          );

    SELECT @vatTotal = ISNULL(SUM(Total), 0)
    FROM RO_GoodsReceivedDetls
    WHERE GMId = @GoodsReceivedMainID
          AND IsVat = 1;

    SELECT @ExtraDiscount = ISNULL(ExtraDiscount, 0)
    FROM RO_GoodsReceivedMain
    WHERE GMId = @GoodsReceivedMainID;

    SELECT @Discount = ISNULL(SUM(Discount), 0)
    FROM RO_GoodsReceivedDetls
    WHERE GMId = @GoodsReceivedMainID;

    SELECT @vatDiscount = ISNULL(SUM(Discount), 0)
    FROM RO_GoodsReceivedDetls
    WHERE GMId = @GoodsReceivedMainID
          AND IsVat = 1;

    SET @PurchaseDiscount = @ExtraDiscount + @Discount;
    SET @vat = (@vatTotal - @vatDiscount) * 0.13;

    -----------------------------------------------------
    -- Insert Transaction Master
    -----------------------------------------------------
    INSERT INTO Ac_TempTransaction
    (
        TransactionDate,
        VoucherTypeID,
        VoucherNo,
        Descriptions,
        PostedBy,
        PostedOn
    )
    VALUES
    (@BillDate, @VoucherTypeID, @VoucherNo, @Description, 'System', @BillDate);

    SET @TransactionID = SCOPE_IDENTITY();

    -----------------------------------------------------
    -- Debit Purchase Account
    -----------------------------------------------------
    SELECT @FoodSales = SUM(Total)
    FROM RO_GoodsReceivedDetls
    WHERE GMId = @GoodsReceivedMainID;

    IF ISNULL(@FoodSales, 0) <> 0
    BEGIN
        INSERT INTO Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        SELECT @TransactionID,
               CASE
                   WHEN @GoodsStoreId = @BarStoreId THEN
                       @BarFinancialAcId
                   WHEN @GoodsStoreId = @KitchenStoreId THEN
                       @FoodFinancialAcId
                   ELSE
                       40
               END,
               NULL,
               CASE
                   WHEN @GoodsStoreId = @BarStoreId THEN
                       @BarFinancialAc
                   WHEN @GoodsStoreId = @KitchenStoreId THEN
                       @FoodFinancialAc
                   ELSE
                       'Regular Purchase'
               END,
               @FoodSales,
               0;
    END;

    -----------------------------------------------------
    -- Discount Credit
    -----------------------------------------------------
    IF ISNULL(@PurchaseDiscount, 0) <> 0
    BEGIN
        INSERT INTO Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (@TransactionID, 45, NULL, 'Discount Received', 0, @PurchaseDiscount);
    END;

    -----------------------------------------------------
    -- ✅ FIXED VAT (Input VAT → VAT RECEIVABLE 4663)
    -----------------------------------------------------
    IF ISNULL(@vat, 0) <> 0
    BEGIN
        INSERT INTO Ac_TempTransactionDetail
        (
            TransactionID,
            FinancialAcID,
            MemberShipID,
            Particulars,
            Debit,
            Credit
        )
        VALUES
        (@TransactionID, 4663, NULL, 'Input VAT', @vat, 0);
    END;

    -----------------------------------------------------
    -- Payment Entries
    -----------------------------------------------------
    DECLARE @FinancialAcID INT,
            @CustFinancialAcID INT,
            @provFinancialAcID INT,
            @paymentMode INT,
            @CreditParty NVARCHAR(256),
            @TransactionNo NVARCHAR(256);

    SELECT @TotalPayAmount = SUM(PayAmount)
    FROM RO_PurchasePaymentMode
    WHERE GMId = @GoodsReceivedMainID;

    DECLARE cur CURSOR FOR
    SELECT purchasePaymentID
    FROM RO_PurchasePaymentMode
    WHERE GMId = @GoodsReceivedMainID;

    OPEN cur;
    DECLARE @id INT;

    FETCH NEXT FROM cur
    INTO @id;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @PayAmount = ppm.PayAmount,
               @paymentMode = ppm.paymentModeID,
               @MembershipID = ppm.VendorID,
               @CreditParty = ppm.VendorName,
               @CustFinancialAcID = lm.FinancialAcId,
               @provFinancialAcID = cp.FinancialAcId,
               @TransactionNo = CASE
                                    WHEN paymentModeID = 2 THEN
                                        ppm.ChequeNo
                                    WHEN paymentModeID = 3 THEN
                                        ppm.TransactionNo
                                    ELSE
                                        NULL
                                END
        FROM RO_PurchasePaymentMode ppm
            LEFT JOIN RO_LoyaltyMembership lm
                ON ppm.VendorID = lm.MembershipID
            LEFT JOIN RO_CardProvider cp
                ON cp.ProviderID = ppm.ProviderID
        WHERE ppm.purchasePaymentID = @id;

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

            INSERT INTO Ac_TempTransactionDetail
            (
                TransactionID,
                FinancialAcID,
                MemberShipID,
                Particulars,
                Debit,
                Credit
            )
            VALUES
            (   @TransactionID, ISNULL(@FinancialAcID, 41), @MembershipID,
                CASE
                    WHEN @paymentMode = 1 THEN
                        'Paid in Cash'
                    WHEN @paymentMode = 4 THEN
                        'Credit Party - ' + @CreditParty
                    ELSE
                        'Bank Transaction - ' + @TransactionNo
                END, 0, @PayAmount);
        END;

        FETCH NEXT FROM cur
        INTO @id;
    END;

    CLOSE cur;
    DEALLOCATE cur;

END;

GO
