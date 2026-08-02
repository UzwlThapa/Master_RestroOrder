SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_ChangePaymentMode]
    @InvoiceNumber VARCHAR(50),
    @FromPaymentModeID INT,
    @ToPaymentModeID INT,
    @IsUpdateDatabase BIT = 0
AS
/*
1   CASH
2   Cheque
3   Card
4   Credit
6   FonePay

NOTES:
- RO_SalesPaymentMode has trigger (RO_SalesPaymentMode_Delete) blocking UPDATE and DELETE
- Trigger is disabled/enabled within this SP using EXEC() to bypass TRY/CATCH syntax limitation
- @FromPaymentModeID = existing PaymentModeID to change
- @ToPaymentModeID   = new PaymentModeID to set
- @IsUpdateDatabase  = 0 for dry run, 1 to commit
*/

DECLARE @SalesMasterId INT;
DECLARE @PayAmount DECIMAL(18, 2);
DECLARE @ReturnPayment DECIMAL(18, 2);

-- Get salesMasterId from invoice number
SELECT @SalesMasterId = sm.salesMasterId
FROM CBMS_BillPostLog bpl
    INNER JOIN RO_SalesMaster sm
        ON bpl.SalesMasterId = sm.salesMasterId
WHERE bpl.invoice_number = @InvoiceNumber;

IF @SalesMasterId IS NULL
BEGIN
    RAISERROR('Invoice not found: %s', 16, 1, @InvoiceNumber);
    RETURN;
END;

IF (@IsUpdateDatabase = 0)
BEGIN
    -- Show current positive payment rows only
    SELECT spm.salesPaymentID,
           bpl.invoice_number,
           pm.PaymentModeID,
           pm.PaymentMode,
           spm.PayAmount,
           spm.ReturnPayment,
           spm.Remarks
    FROM CBMS_BillPostLog bpl
        INNER JOIN RO_SalesMaster sm
            ON bpl.SalesMasterId = sm.salesMasterId
        INNER JOIN RO_SalesPaymentMode spm
            ON sm.salesMasterId = spm.salesMasterId
        INNER JOIN RO_PaymentModes pm
            ON pm.PaymentModeID = spm.PaymentModeID
    WHERE bpl.invoice_number = @InvoiceNumber
          AND spm.PaymentModeID > 0;

    SELECT 'Will change PaymentModeID ' + CAST(@FromPaymentModeID AS VARCHAR) + ' to PaymentModeID '
           + CAST(@ToPaymentModeID AS VARCHAR) AS ActionToBePerformed,
           'Run with @IsUpdateDatabase = 1 to commit' AS Note;
END;
ELSE
BEGIN
    -- Get amount and ReturnPayment of the row being changed
    SELECT @PayAmount = spm.PayAmount,
           @ReturnPayment = ISNULL(spm.ReturnPayment, 0.00)
    FROM RO_SalesPaymentMode spm
    WHERE spm.salesMasterId = @SalesMasterId
          AND spm.PaymentModeID = @FromPaymentModeID;

    IF @PayAmount IS NULL
    BEGIN
        RAISERROR('No payment row found for PaymentModeID %d on invoice %s', 16, 1, @FromPaymentModeID, @InvoiceNumber);
        RETURN;
    END;

    BEGIN TRY
        -- Disable trigger
        EXEC ('DISABLE TRIGGER [RO_SalesPaymentMode_Delete] ON [RO_SalesPaymentMode]');

        -- Update PaymentModeID on the existing row
        -- Also fix ReturnPayment NULL to 0.00 to prevent report duplicates
        UPDATE spm
        SET spm.PaymentModeID = @ToPaymentModeID,
            spm.ReturnPayment = ISNULL(spm.ReturnPayment, 0.00),
            spm.Remarks = ISNULL(spm.Remarks, '') + ' | ChangedFrom:' + CAST(@FromPaymentModeID AS VARCHAR(10))
                          + ' To:' + CAST(@ToPaymentModeID AS VARCHAR(10)) + ' Date:'
                          + CONVERT(VARCHAR(30), GETDATE(), 100)
        FROM RO_SalesPaymentMode spm
        WHERE spm.salesMasterId = @SalesMasterId
              AND spm.PaymentModeID = @FromPaymentModeID;

        -- Also fix any other positive rows with NULL ReturnPayment on this bill
        -- to prevent report duplicates
        UPDATE RO_SalesPaymentMode
        SET ReturnPayment = 0.00
        WHERE salesMasterId = @SalesMasterId
              AND PaymentModeID > 0
              AND ReturnPayment IS NULL;

        -- Re-enable trigger
        EXEC ('ENABLE TRIGGER [RO_SalesPaymentMode_Delete] ON [RO_SalesPaymentMode]');

        -- Show result
        SELECT spm.salesPaymentID,
               pm.PaymentModeID,
               pm.PaymentMode,
               spm.PayAmount,
               spm.ReturnPayment,
               spm.Remarks
        FROM RO_SalesPaymentMode spm
            INNER JOIN RO_PaymentModes pm
                ON pm.PaymentModeID = spm.PaymentModeID
        WHERE spm.salesMasterId = @SalesMasterId
              AND spm.PaymentModeID > 0;

    END TRY
    BEGIN CATCH
        -- Always re-enable trigger even if update fails
        EXEC ('ENABLE TRIGGER [RO_SalesPaymentMode_Delete] ON [RO_SalesPaymentMode]');

        DECLARE @ErrorMessage VARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;

GO
