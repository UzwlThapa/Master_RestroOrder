SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_SaveTransactionForPurchaseReturn] @PurchaseReturnId INT
AS
BEGIN
    DECLARE @PREFX NVARCHAR(10),
            @VoucherCount INT = 0,
            @VoucherTypeID INT = 16,
            @VoucherNo NVARCHAR(50) = N'',
            @TransactionID INT = 0,
            @BillDate DATETIME,
            @Description NVARCHAR(256) = N'',
            @MembershipID INT = 0,
            @PayAmount DECIMAL(18, 2) = 0,
            @Total DECIMAL(10, 2) = 0,
            @GMNo NVARCHAR(25),
            @PurchaseReturn DECIMAL(16, 2) = 0,
            @TotalPayAmount DECIMAL(18, 2) = 0,
            @VendorFinancialAcID INT,
            @VendorMembershipID INT,
            @VendorName NVARCHAR(256);

    -- Get GMNo for description
    SELECT DISTINCT
           @GMNo = GMNo
    FROM RO_GoodsReceivedMain gm
        JOIN RO_GoodsReceivedDetls gd
            ON gm.GMId = gd.GMId
        JOIN RO_PurchaseReturnDetails prd
            ON prd.GDId = gd.GDId
               AND prd.PurchaseReturnId = @PurchaseReturnId;

    -- Get vendor info
    SELECT @VendorMembershipID = prm.vendorId,
           @VendorFinancialAcID = lm.FinancialAcId,
           @VendorName = lm.Fname,
           @BillDate = prm.PostedOn,
           @Description
               = N'Goods Receive No :- ' + @GMNo + N' and Purchase Return No :- ' + CAST(prm.PRNo AS NVARCHAR(20))
    FROM RO_PurchaseReturnMain prm
        LEFT JOIN RO_LoyaltyMembership lm
            ON lm.MembershipID = prm.vendorId
    WHERE prm.PurchaseReturnId = @PurchaseReturnId;

    -- Setup voucher
    SELECT @VoucherCount = 0,
           @VoucherTypeID = 25,
           @VoucherNo = N'';

    SELECT @PREFX = Prefix,
           @VoucherCount = VoucherCount
    FROM Ac_VoucherType
    WHERE VoucherTypeID = @VoucherTypeID;

    SET @VoucherCount = @VoucherCount + 1;
    SET @VoucherNo = @PREFX + N'-' + CAST(@VoucherCount AS VARCHAR(20));

    -- Update voucher count
    UPDATE Ac_VoucherType
    SET VoucherCount = @VoucherCount
    WHERE VoucherTypeID = @VoucherTypeID;

    -- Create transaction header
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

    SET @TransactionID = @@IDENTITY;

    -- Get return total
    SELECT @PurchaseReturn = ISNULL(SUM(Total), 0)
    FROM RO_PurchaseReturnDetails
    WHERE PurchaseReturnId = @PurchaseReturnId;

    -- Get total payment amount (if any payment modes exist)
    SELECT @TotalPayAmount = ISNULL(SUM(PayAmount), 0)
    FROM RO_PurchaseReturnPaymentMode
    WHERE PurchaseReturnId = @PurchaseReturnId;

    -- CREDIT side: Account 40 (Purchase Account)
    IF ISNULL(@PurchaseReturn, 0) <> 0
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
        (@TransactionID, 40, NULL, 'Regular Purchase', 0, @PurchaseReturn);
    END;

    -- DEBIT side
    IF NOT EXISTS
    (
        SELECT 1
        FROM RO_PurchaseReturnPaymentMode
        WHERE PurchaseReturnId = @PurchaseReturnId
    )
    BEGIN
        -- No payment mode: full amount goes to vendor payable (credit balance reduced)
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
        (@TransactionID, ISNULL(@VendorFinancialAcID, 41), @VendorMembershipID, 'Purchase Return - ' + @VendorName,
         @PurchaseReturn, 0);
    END;
    ELSE
    BEGIN
        -- Payment modes exist: post each payment mode as debit
        DECLARE @MyCursor CURSOR;
        DECLARE @MyField INT;

        SET @MyCursor = CURSOR FOR
        SELECT ppm.ID
        FROM RO_PurchaseReturnPaymentMode ppm
        WHERE ppm.PurchaseReturnId = @PurchaseReturnId;

        OPEN @MyCursor;
        FETCH NEXT FROM @MyCursor
        INTO @MyField;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            DECLARE @FinancialAcID INT,
                    @CustFinancialAcID INT,
                    @provFinancialAcID INT,
                    @paymentMode INT,
                    @CreditParty NVARCHAR(256),
                    @TransactionNo NVARCHAR(256);

            SET @PayAmount = NULL;

            SELECT @PayAmount = ppm.PayAmount,
                   @paymentMode = ppm.paymentModeID,
                   @MembershipID = ppm.VendorId,
                   @CreditParty = lm.Fname,
                   @CustFinancialAcID = lm.FinancialAcId,
                   @provFinancialAcID = cp.FinancialAcId,
                   @TransactionNo = (CASE
                                         WHEN ppm.paymentModeID = 2 THEN
                                             ppm.ChequeNo
                                         WHEN ppm.paymentModeID = 3 THEN
                                             ppm.TransactionNo
                                         ELSE
                                             NULL
                                     END
                                    )
            FROM RO_PurchaseReturnPaymentMode ppm
                LEFT JOIN RO_LoyaltyMembership lm
                    ON ppm.VendorId = lm.MembershipID
                LEFT JOIN RO_CardProvider cp
                    ON cp.ProviderID = ppm.ProviderID
            WHERE ppm.ID = @MyField
                  AND ISNULL(lm.IsArchived, 0) != 1;

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
                            'Cash Paid'
                        WHEN @paymentMode = 4 THEN
                            'Credit Party - ' + @CreditParty
                        ELSE
                            'Bank Transaction - ' + @TransactionNo
                    END, @PayAmount, 0);
            END;

            FETCH NEXT FROM @MyCursor
            INTO @MyField;
        END;

        CLOSE @MyCursor;
        DEALLOCATE @MyCursor;

        -- Surplus/Deficit if payment doesn't match return total
        IF (@PurchaseReturn != @TotalPayAmount)
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
            (   @TransactionID, 43, NULL, CASE
                                              WHEN @PurchaseReturn < @TotalPayAmount THEN
                                                  'Deficit Amount'
                                              ELSE
                                                  'Surplus Amount'
                                          END, CASE
                                                   WHEN @PurchaseReturn > @TotalPayAmount THEN
                                                       @PurchaseReturn - @TotalPayAmount
                                                   ELSE
                                                       0
                                               END, CASE
                                                        WHEN @PurchaseReturn < @TotalPayAmount THEN
                                                            @TotalPayAmount - @PurchaseReturn
                                                        ELSE
                                                            0
                                                    END);
        END;
    END;
END;

GO
