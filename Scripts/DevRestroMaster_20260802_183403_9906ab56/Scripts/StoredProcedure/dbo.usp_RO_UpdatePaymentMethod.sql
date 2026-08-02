SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_RO_UpdatePaymentMethod]
    @salesMasterId INT,
    @SPMID INT,
    @ChequeNo NVARCHAR(MAX),
    @TransactionNo NVARCHAR(MAX),
    @ProviderID INT,
    @CusID INT,
    @Customer NVARCHAR(MAX),
    @Address NVARCHAR(MAX),
    @PAN NVARCHAR(MAX),
    @PayAmount DECIMAL(18, 2),
    @TenderAmount DECIMAL(18, 2),
    @ReturnAmount DECIMAL(18, 2),
    @Remarks NVARCHAR(MAX),
    @ReturnPayment DECIMAL(18, 2) = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    --Declaring Necessary Variables
    DECLARE @PrevCredit BIT = 0;
    DECLARE @PrevCustomerId INT;
    DECLARE @CreditPayAmt DECIMAL(15, 2);
    DECLARE @PrevCustomerName VARCHAR(50);
    DECLARE @AlreadyProcessed BIT = 0;
    DECLARE @UpdatedOn DATETIME;

    -- Get previous customer name
    SET @PrevCustomerName = ISNULL(
        (SELECT TOP (1) Customer 
         FROM RO_SalesPaymentMode 
         WHERE salesMasterId = @salesMasterId), ''
    );

    -- Check if this sale was already updated in the current session
    -- (within last 5 seconds means it's part of a multi-payment update)
    SELECT @UpdatedOn = UpdatedOn 
    FROM RO_SalesMaster 
    WHERE salesMasterId = @salesMasterId;

    IF (@UpdatedOn IS NOT NULL AND DATEDIFF(SECOND, @UpdatedOn, GETDATE()) <= 5)
    BEGIN
        SET @AlreadyProcessed = 1;
    END

    -- Only archive and handle credit reversal if NOT already processed
    IF (@AlreadyProcessed = 0)
    BEGIN
        -- Check if there's previous credit payment
        IF EXISTS (
            SELECT * FROM RO_SalesPaymentMode 
            WHERE salesMasterId = @salesMasterId 
            AND PaymentModeID = 4
        )
        BEGIN
            SET @PrevCredit = 1;
            
            SELECT TOP (1) 
                @PrevCustomerId = CusID, 
                @CreditPayAmt = PayAmount
            FROM RO_SalesPaymentMode 
            WHERE salesMasterId = @salesMasterId 
            AND PaymentModeID = 4;

            -- Reverse previous credit balance
            IF (@PrevCredit = 1 AND @PrevCustomerId <> 0)
            BEGIN
                UPDATE RO_LoyaltyMembership 
                SET RemainingBalance = ISNULL(RemainingBalance, 0) - @CreditPayAmt
                WHERE MembershipID = @PrevCustomerId;
            END
        END;

        -- Archive old payment methods
        EXEC [usp_RO_ArchivePaymentMethod] @salesMasterId, @PrevCustomerName;
    END;

    -- Handle new credit payment
    IF (@SPMID = 4 AND @CusID <> 0)
    BEGIN
        UPDATE RO_LoyaltyMembership 
        SET RemainingBalance = ISNULL(RemainingBalance, 0) + @PayAmount
        WHERE MembershipID = @CusID;
    END;

    -- Insert new payment method
    INSERT INTO RO_SalesPaymentMode (
        salesMasterId, 
        PaymentModeID, 
        ChequeNo, 
        TransactionNo, 
        ProviderID, 
        CusID, 
        Customer, 
        Address, 
        PAN, 
        PayAmount, 
        Remarks, 
        ReturnPayment
    )
    VALUES (
        @salesMasterId, 
        @SPMID, 
        @ChequeNo, 
        @TransactionNo, 
        @ProviderID, 
        @CusID, 
        @Customer, 
        @Address, 
        @PAN, 
        @PayAmount, 
        @Remarks, 
        @ReturnPayment
    );

    -- Update SalesMaster (always update to keep timestamp fresh for detection)
    IF (@SPMID = 1)
    BEGIN
        UPDATE RO_SalesMaster 
        SET IsUpdated = 1, 
            UpdatedOn = GETDATE(),
            TenderAmount = @TenderAmount,
            ReturnAmount = @ReturnAmount
        WHERE salesMasterId = @salesMasterId;
    END
    ELSE
    BEGIN
        UPDATE RO_SalesMaster 
        SET IsUpdated = 1, 
            UpdatedOn = GETDATE()
        WHERE salesMasterId = @salesMasterId;
    END;

    RETURN 0;
END;

GO
