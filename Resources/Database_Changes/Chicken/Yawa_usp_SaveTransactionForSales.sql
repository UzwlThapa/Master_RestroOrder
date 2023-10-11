SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
-- usp_SaveTransactionForSales 88
-- drop PROC [dbo].[usp_SaveTransactionForSales] 46
ALTER PROC [dbo].usp_SaveTransactionForSales @SalesMasterID INT
AS
BEGIN

--DEFAULT DECLARATION FROM COST CENTER GROUPS
Declare @FoodFcid INT = 19
Declare @BarFcid INT = 20
DECLARE @BakeryFcid INT  = 32
Declare @OtherSalesFcid INT = 24
 
    DECLARE @PREFX NVARCHAR(10),
            @VoucherCount INT = 0,
            @VoucherTypeID INT = 16,
            @VoucherNo NVARCHAR(50) = N'',
            @SalesDiscount DECIMAL(18, 2) = 0,
            @AdvancePayment DECIMAL(18, 2) = 0,
            @code VARCHAR(10),
            @OrderMasterID INT,
            @membername NVARCHAR(250),
            @DeliveryCharge DECIMAL(18, 2) = 0;
    DECLARE @CusID INT = 0,
            @custAcId INT;

    SELECT TOP 1
           @CusID = CusID
    FROM RO_SalesPaymentMode
    WHERE salesMasterId = @SalesMasterID;
    IF (@CusID <> 0)
    BEGIN
        SELECT @custAcId = FinancialAcId
        FROM RO_LoyaltyMembership lm
        WHERE lm.MembershipID = @CusID
              AND ISNULL(IsArchived, 0) != 1;
    END;
    ELSE
    BEGIN
        SET @custAcId = 28;
    END;

    SET @code =
    (
        SELECT TOP (1) Code FROM RO_CompanyInfo
    );

    SELECT @OrderMasterID = OrderMasterId,
           @AdvancePayment = AdvancePayment
    FROM RO_SalesMaster
    WHERE salesMasterId = @SalesMasterID;

    SELECT @membername = CustomerName
    FROM Ro_RoomBookings rm
        INNER JOIN RO_OrderMasters om
            ON om.OrderMasterID = rm.OrderMasterId
        INNER JOIN RO_SalesMaster sm
            ON sm.OrderMasterId = om.OrderMasterID
    WHERE sm.salesMasterId = @SalesMasterID;

    SELECT @DeliveryCharge = ISNULL(DeliveryCharge, 0)
    FROM RO_SalesMaster sm
        INNER JOIN RO_OrderMasters om
            ON om.OrderMasterID = sm.OrderMasterId
    WHERE sm.salesMasterId = @SalesMasterID;

    SELECT @PREFX = Prefix,
           @VoucherCount = VoucherCount
    FROM Ac_VoucherType
    WHERE VoucherTypeID = @VoucherTypeID;

    SET @VoucherCount = @VoucherCount + 1;

    --UPDATE Ac_VoucherType
    --SET VoucherCount = @VoucherCount
    --WHERE VoucherTypeID = @VoucherTypeID

    SET @VoucherNo = @PREFX + N'-' + CAST(@VoucherCount AS VARCHAR(20));

    DECLARE @BillDate DATETIME,
            @Description NVARCHAR(256) = N'';

    SELECT @BillDate = BillDate,

           --,@Description = 'Sales Bill No :-' + SM.billNo
           @Description
               = ('Sales Bill No :- ' + @code
                  + (CONVERT(NVARCHAR(10), FY.fyName) + '-'
                     + CONVERT(NVARCHAR(10), (SM.InvoiceNo - (FY.FirstSalesMasterID)))
                    )
                 )
    --WHERE fy.fyid = sm.fiscalyearid
    FROM RO_SalesMaster SM
        INNER JOIN RO_fiscalYear FY
            ON SM.FiscalYearID = FY.fyId
               AND SM.salesMasterId = @SalesMasterID;

    --select @PREFX,@VoucherCount,@VoucherTypeID,@BillDate,@Description,@VoucherNo
    DECLARE @TransactionID INT = 0;

    INSERT INTO Ac_TempTransaction
    (
        TransactionDate,
        VoucherTypeID,
        VoucherNo,
        Descriptions,
        PostedBy,
        PostedOn,
		SalesMasterId
    )
    VALUES
    (@BillDate, @VoucherTypeID, @VoucherNo, @Description, 'System', @BillDate, @SalesMasterID);

    SET @TransactionID = @@IDENTITY;

    --IF ISNULL(@AdvancePayment, 0) <> 0
    --	BEGIN

    --		INSERT INTO Ac_TempTransactionDetail (
    --			TransactionID
    --			,FinancialAcID
    --			,MemberShipID
    --			,Particulars
    --			,Debit
    --			,Credit
    --			)
    --		VALUES (
    --			@TransactionID
    --			,@custAcId
    --			,@CusID 
    --			,'Advance Payee - ' + @membername
    --			,@AdvancePayment
    --			,0
    --			)
    --	END

    DECLARE @DiscountMethod BIT = 0,
            @Discount DECIMAL(16, 2);


    -- Food Sales

    DECLARE @FoodSales DECIMAL(16, 2) = 0;
    DECLARE @ExtraFoodSales DECIMAL(16, 2) = 0;

    SELECT @FoodSales = SUM(sd.rate * sd.qty)
    FROM RO_SalesDetail sd LEFT JOIN
	CostCenterInfo CC ON SD.CostCenterId = CC.CostCenterId
	LEFT JOIN RO_CostCenterGroup CCG ON CC.GroupId = CCG.GroupId
    WHERE sd.salesMasterId = @SalesMasterID
          AND IsCombo = 0
          AND CCG.FinancialAcId = @FoodFcid;

    SELECT @ExtraFoodSales = ISNULL(SUM(sde.Rate * sde.Quantity), 0)
    FROM RO_SalesDetailExtra sde
        INNER JOIN RO_SalesDetail sd
            ON sd.salesDetailId = sde.SalesDetailsId LEFT JOIN
	CostCenterInfo CC ON SD.CostCenterId = CC.CostCenterId
	LEFT JOIN RO_CostCenterGroup CCG ON CC.GroupId = CCG.GroupId
    WHERE sd.salesMasterId = @SalesMasterID
          AND IsCombo = 0
          AND CCG.FinancialAcId = @FoodFcid;

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
                                   CONVERT(   DECIMAL(16, 2),
                                              CASE
                                                  WHEN kotdis = '' THEN
                                                      '0'
                                                  ELSE
                                                      kotdis
                                              END
                                          )
                           END
        FROM ro_flatandPerDiscount
        WHERE SalesMasterId = @SalesMasterID;

        --AND IsCombo = 0
        --AND CostCenterId = 1
        -- select * from ro_flatandPerDiscount
        IF @DiscountMethod = 0
            SET @SalesDiscount = @SalesDiscount + ((@FoodSales + @ExtraFoodSales) * (@Discount / 100));
        ELSE
            SET @SalesDiscount = @SalesDiscount + @Discount;

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
        (@TransactionID, @FoodFcid, NULL, 'Food Sales(KOT)', 0, @FoodSales + @ExtraFoodSales);
    END;

    -- BAR Sales
    SET @FoodSales = NULL;
    SET @ExtraFoodSales = NULL;

    SELECT @FoodSales = SUM(rate * qty)
    FROM RO_SalesDetail SD LEFT JOIN
	CostCenterInfo CC ON SD.CostCenterId = CC.CostCenterId
	LEFT JOIN RO_CostCenterGroup CCG ON CC.GroupId = CCG.GroupId
    WHERE sd.salesMasterId = @SalesMasterID
          AND IsCombo = 0
          AND CCG.FinancialAcId = @BarFcid;

    SELECT @ExtraFoodSales = ISNULL(SUM(sde.Rate * sde.Quantity), 0)
    FROM RO_SalesDetailExtra sde
        INNER JOIN RO_SalesDetail sd
            ON sd.salesDetailId = sde.SalesDetailsId
   LEFT JOIN
	CostCenterInfo CC ON SD.CostCenterId = CC.CostCenterId
	LEFT JOIN RO_CostCenterGroup CCG ON CC.GroupId = CCG.GroupId
    WHERE sd.salesMasterId = @SalesMasterID
          AND IsCombo = 0
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
                                   CONVERT(   DECIMAL(16, 2),
                                              CASE
                                                  WHEN bardis = '' THEN
                                                      '0'
                                                  ELSE
                                                      bardis
                                              END
                                          )
                           END
        FROM ro_flatandPerDiscount
        WHERE SalesMasterId = @SalesMasterID;

        IF @DiscountMethod = 0
            SET @SalesDiscount = @SalesDiscount + ((@FoodSales + @ExtraFoodSales) * (@Discount / 100));
        ELSE
            SET @SalesDiscount = @SalesDiscount + @Discount;

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
        (@TransactionID, @BarFcid, NULL, 'BAR Item Sales(BOT)', 0, @FoodSales + @ExtraFoodSales);
    END;

    -- Bakery Cafe Sales
    SET @FoodSales = NULL;
    SET @ExtraFoodSales = NULL;

    SELECT @FoodSales = SUM(rate * qty)
    FROM RO_SalesDetail SD LEFT JOIN
	CostCenterInfo CC ON SD.CostCenterId = CC.CostCenterId
	LEFT JOIN RO_CostCenterGroup CCG ON CC.GroupId = CCG.GroupId
    WHERE sd.salesMasterId = @SalesMasterID
          AND IsCombo = 0
          AND CCG.FinancialAcId = @BakeryFcid;

    SELECT @ExtraFoodSales = ISNULL(SUM(sde.Rate * sde.Quantity), 0)
    FROM RO_SalesDetailExtra sde
        INNER JOIN RO_SalesDetail sd
            ON sd.salesDetailId = sde.SalesDetailsId
			LEFT JOIN
	CostCenterInfo CC ON SD.CostCenterId = CC.CostCenterId
	LEFT JOIN RO_CostCenterGroup CCG ON CC.GroupId = CCG.GroupId
    WHERE sd.salesMasterId = @SalesMasterID
          AND IsCombo = 0
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
                                   CONVERT(   DECIMAL(16, 2),
                                              CASE
                                                  WHEN bakerydis = '' THEN
                                                      '0'
                                                  ELSE
                                                      bakerydis
                                              END
                                          )
                           END
        FROM ro_flatandPerDiscount
        WHERE SalesMasterId = @SalesMasterID;

        IF @DiscountMethod = 0
            SET @SalesDiscount = @SalesDiscount + ((@FoodSales + @ExtraFoodSales) * (@Discount / 100));
        ELSE
            SET @SalesDiscount = @SalesDiscount + @Discount;

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
        (@TransactionID, @BakeryFcid, NULL, 'Bakery Cafe Sales  ', 0, @FoodSales + @ExtraFoodSales);
    END;

    -- Other Sales
    SET @FoodSales = NULL;
    SET @ExtraFoodSales = NULL;

    SELECT @FoodSales = SUM(rate * qty)
    FROM RO_SalesDetail SD LEFT JOIN
	CostCenterInfo CC ON SD.CostCenterId = CC.CostCenterId
	LEFT JOIN RO_CostCenterGroup CCG ON CC.GroupId = CCG.GroupId
    WHERE sd.salesMasterId = @SalesMasterID
          AND IsCombo = 0
          AND CCG.FinancialAcId = @OtherSalesFcid;

    SELECT @ExtraFoodSales = ISNULL(SUM(sde.Rate * sde.Quantity), 0)
    FROM RO_SalesDetailExtra sde
        INNER JOIN RO_SalesDetail sd
            ON sd.salesDetailId = sde.SalesDetailsId
   LEFT JOIN
	CostCenterInfo CC ON SD.CostCenterId = CC.CostCenterId
	LEFT JOIN RO_CostCenterGroup CCG ON CC.GroupId = CCG.GroupId
    WHERE sd.salesMasterId = @SalesMasterID
          AND IsCombo = 0
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
                                   CONVERT(   DECIMAL(16, 2),
                                              CASE
                                                  WHEN pizzadis = '' THEN
                                                      '0'
                                                  ELSE
                                                      pizzadis
                                              END
                                          )
                           END
        FROM ro_flatandPerDiscount
        WHERE SalesMasterId = @SalesMasterID;

        IF @DiscountMethod = 0
            SET @SalesDiscount = @SalesDiscount + ((@FoodSales + @ExtraFoodSales) * (@Discount / 100));
        ELSE
            SET @SalesDiscount = @SalesDiscount + @Discount;

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
        (@TransactionID, @OtherSalesFcid , NULL, 'Other Sales  ', 0, @FoodSales + @ExtraFoodSales);
    END;

    -- Combo Sales
    SET @FoodSales = NULL;

    SELECT @FoodSales = SUM(rate * qty)
    FROM RO_SalesDetail
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
                                   CONVERT(   DECIMAL(16, 2),
                                              CASE
                                                  WHEN bakerydis = '' THEN
                                                      '0'
                                                  ELSE
                                                      bakerydis
                                              END
                                          )
                           END
        FROM ro_flatandPerDiscount
        WHERE SalesMasterId = @SalesMasterID;

        IF @DiscountMethod = 0
            SET @SalesDiscount = @SalesDiscount + (@FoodSales * (@Discount / 100));
        ELSE
            SET @SalesDiscount = @SalesDiscount + @Discount;

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
        (@TransactionID, 33, NULL, 'Combo Sales  ', 0, @FoodSales);
    END;

    -- Room Sales
    SET @FoodSales = NULL;

    SELECT @FoodSales = SUM(Rate * BookedDays)
    FROM Ro_RoomBookings
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
                                   CONVERT(   DECIMAL(16, 2),
                                              CASE
                                                  WHEN roomdis = '' THEN
                                                      '0'
                                                  ELSE
                                                      roomdis
                                              END
                                          )
                           END
        FROM ro_flatandPerDiscount
        WHERE SalesMasterId = @SalesMasterID;

        IF @DiscountMethod = 0
            SET @SalesDiscount = @SalesDiscount + (@FoodSales * (@Discount / 100));
        ELSE
            SET @SalesDiscount = @SalesDiscount + @Discount;

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
        (@TransactionID, 22, NULL, 'Room ', 0, @FoodSales);
    END;

    -- Sales Discount
    IF ISNULL(@SalesDiscount, 0) <> 0
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
        (@TransactionID, 42, NULL, 'Total Discount ', @SalesDiscount, 0);

    -- Service Charge
    SET @FoodSales = NULL;

    SELECT @FoodSales = Amount
    FROM RO_BillingAmount
    WHERE SalesMasterID = @SalesMasterID
          AND BilingID = 62;

    --IF @FoodSales IS NOT NULL
    IF ISNULL(@FoodSales, 0) <> 0
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
        (@TransactionID, 31, NULL, 'Service Charge ', 0, @FoodSales);

    -- Other Charge
    SET @FoodSales = NULL;

    SELECT @FoodSales = SUM(Amount)
    FROM RO_BillingAmount
    WHERE SalesMasterID = @SalesMasterID
          AND IsVoid = 0
          AND BilingID NOT IN ( 1, 62, 54 );

    --IF @FoodSales IS NOT NULL
    IF ISNULL(@FoodSales, 0) <> 0
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
        (@TransactionID, 44, NULL, 'Other Charges ', 0, @FoodSales);



    -- Delivery Charge
    IF ISNULL(@DeliveryCharge, 0) <> 0
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
        (@TransactionID, 132, NULL, 'Delivery Charges ', 0, @DeliveryCharge);

    -- Other Discount
    SET @FoodSales = NULL;

    SELECT @FoodSales = SUM(Amount)
    FROM RO_BillingAmount
    WHERE SalesMasterID = @SalesMasterID
          AND IsVoid = 1
          AND BilingID NOT IN ( 1, 62, 54 );

    --IF @FoodSales IS NOT NULL
    IF ISNULL(@FoodSales, 0) <> 0
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
        (@TransactionID, 44, NULL, 'Other Discounts ', @FoodSales, 0);

    -- VAT 
    SET @FoodSales = NULL;

    DECLARE @Percentage DECIMAL(18, 2) = 0;

    --SELECT @FoodSales = Amount
    --	,@Percentage = [Percent]
    --FROM UsedBillingTerm
    --WHERE salesMasterId = @SalesMasterID
    --	AND BillingTerm = 'VAT'
    SELECT @FoodSales = Amount
    FROM RO_BillingAmount
    WHERE SalesMasterID = @SalesMasterID
          AND BilingID = 54;

    --SET @FoodSales = @FoodSales * @Percentage / 100
    IF ISNULL(@FoodSales, 0) <> 0
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
    FROM RO_SalesMaster
    WHERE salesMasterId = @SalesMasterID;

    SELECT @TotalPayAmount = SUM(PayAmount)
    FROM RO_SalesPaymentMode
    WHERE salesMasterId = @SalesMasterID;

    DECLARE @MyCursor CURSOR;
    DECLARE @MyField INT;
    SET @MyCursor = CURSOR FOR
    SELECT spm.salesPaymentID
    FROM RO_SalesPaymentMode spm
    WHERE spm.salesMasterId = @SalesMasterID;

    OPEN @MyCursor;

    FETCH NEXT FROM @MyCursor
    INTO @MyField;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @PayAmount = NULL;

        SELECT @PayAmount = PayAmount,
               @paymentMode = PaymentModeID,
               @MembershipID = spm.CusID,
               @CreditParty = spm.Customer,
               @CustFinancialAcID = lm.FinancialAcId,
               @provFinancialAcID = cp.FinancialAcId,
               @TransactionNo = (CASE
                                     WHEN PaymentModeID = 2 THEN
                                         spm.ChequeNo
                                     WHEN PaymentModeID = 3 THEN
                                         spm.TransactionNo
                                     WHEN PaymentModeID = 5 THEN
                                         spm.TransactionNo
                                     WHEN PaymentModeID = 6 THEN
                                         spm.TransactionNo
                                     ELSE
                                         NULL
                                 END
                                )
        FROM RO_SalesPaymentMode spm
            LEFT JOIN RO_LoyaltyMembership lm
                ON spm.CusID = lm.MembershipID
            LEFT JOIN RO_CardProvider cp
                ON cp.ProviderID = spm.ProviderID
        WHERE salesPaymentID = @MyField;

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
    FROM RO_SalesPaymentMode
    WHERE salesMasterId = @SalesMasterID
          AND PaymentModeID <> 4;
    SELECT @ReturnPayment = ReturnPayment
    FROM RO_SalesPaymentMode
    WHERE salesMasterId = @SalesMasterID;

    --IF EXISTS (select * from RO_SalesPaymentMode where salesMasterId = @SalesMasterID and PaymentModeID = 4)
    IF (@AdvancePayment > 0 AND @AdvancePayment > @NetAmount)
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
        (@TransactionID, ISNULL(@CustFinancialAcID, 15), @MembershipID,
         'Credit Party - ' + @CreditParty + ' - From Advance payment', @NetAmount, 0);
    END;

    ELSE IF (@AdvancePayment > 0 AND @AdvancePayment <= @NetAmount)
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
        (@TransactionID, ISNULL(@CustFinancialAcID, 15), @MembershipID,
         'From Advance payment: To Credit Party - ' + @CreditParty, @AdvancePayment, 0);
    END;



    IF (
           @NetAmount != @TotalPayAmount + ISNULL(@AdvancePayment, 0)
           AND @CusID < 0
       )
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
                @NetAmount != @TotalPayAmount + ISNULL(@AdvancePayment, 0)
                AND ISNULL(@AdvancePayment, 0) < @NetAmount
            )
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

