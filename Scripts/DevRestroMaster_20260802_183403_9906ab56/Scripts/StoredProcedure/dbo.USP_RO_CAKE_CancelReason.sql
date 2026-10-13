SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_CAKE_CancelReason]
    @salesMasterId INT,
    @SalesType VARCHAR(30),
    @Reasons NVARCHAR(MAX),
    @userName NVARCHAR(256),
    @creditNoteDate NVARCHAR(256),
    @restoreOrder BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF LOWER(ISNULL(@SalesType, '')) NOT IN ('cake', 'retail', 'wholesale')
        THROW 50001, 'Unsupported sales type for cake-family bill cancellation.', 1;

    IF @restoreOrder = 1
        THROW 50002, 'Order restoration is not supported by the cake-family sales return path.', 1;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @isArchived BIT;
        DECLARE @orderMasterId INT;
        DECLARE @invoiceNo INT;
        DECLARE @fiscalYearId INT;
        DECLARE @basicAmount DECIMAL(18, 2);
        DECLARE @netAmount DECIMAL(18, 2);
        DECLARE @fiscalYear NVARCHAR(256);
        DECLARE @firstSalesMasterId INT;
        DECLARE @invoiceCode NVARCHAR(256);
        DECLARE @sellerPan NVARCHAR(256);
        DECLARE @buyerPan NVARCHAR(256);
        DECLARE @buyerName NVARCHAR(256);
        DECLARE @vat DECIMAL(18, 2);
        DECLARE @creditNoteNumber NVARCHAR(256);
        DECLARE @creditNoteSequence INT;
        DECLARE @returnLogId INT;

        SELECT @isArchived = ISNULL(sm.IsArchived, 0),
               @orderMasterId = sm.OrderMasterId,
               @invoiceNo = sm.InvoiceNo,
               @fiscalYearId = sm.FiscalYearID,
               @basicAmount = ISNULL(sm.BasicAmount, 0),
               @netAmount = ISNULL(sm.NetAmount, 0),
               @buyerPan = sm.PAN,
               @buyerName = sm.CustomerName
        FROM dbo.RO_CakeSalesMaster sm WITH (UPDLOCK, HOLDLOCK)
        WHERE sm.SalesMasterId = @salesMasterId
          AND LOWER(ISNULL(sm.SalesType, '')) = LOWER(@SalesType);

        IF @orderMasterId IS NULL
            THROW 50003, 'Bill was not found for the supplied sales type.', 1;

        IF EXISTS
        (
            SELECT 1
            FROM dbo.CBMS_BillReturnPostLog WITH (UPDLOCK, HOLDLOCK)
            WHERE SalesMasterId = @salesMasterId
              AND LOWER(ISNULL(SalesType, '')) = LOWER(@SalesType)
              AND StatusCode = 'LOCAL'
        )
        BEGIN
            IF @isArchived = 1
            BEGIN
                COMMIT TRANSACTION;
                RETURN;
            END;

            THROW 50004, 'A local credit note already exists for an active bill; reconcile before retrying.', 1;
        END;

        IF @isArchived = 1
            THROW 50005, 'Bill is already archived but has no local credit note; reconcile before retrying.', 1;

        SELECT @fiscalYear = fy.fyName,
               @firstSalesMasterId = fy.FirstSalesMasterID
        FROM dbo.RO_fiscalYear fy
        WHERE fy.fyId = @fiscalYearId;

        SELECT TOP (1) @invoiceCode = ci.Code,
                       @sellerPan = ci.PAN
        FROM dbo.RO_CompanyInfo ci;

        SELECT @vat = ISNULL(ba.Amount, 0)
        FROM dbo.RO_CAKE_BillingAmount ba
        WHERE ba.SalesMasterID = @salesMasterId
          AND ba.BilingID = 54
          AND LOWER(ISNULL(ba.SalesType, '')) = LOWER(@SalesType);

        IF @fiscalYear IS NULL OR @invoiceCode IS NULL
            THROW 50006, 'Fiscal-year or company invoice configuration is missing.', 1;

        SELECT @creditNoteSequence = ISNULL(MAX(CASE
            WHEN ISNUMERIC(SUBSTRING(credit_note_number, CHARINDEX('-', credit_note_number) + 1, LEN(credit_note_number))) = 1
                THEN CAST(SUBSTRING(credit_note_number, CHARINDEX('-', credit_note_number) + 1, LEN(credit_note_number)) AS INT)
            ELSE 0
        END), 0) + 1
        FROM dbo.CBMS_BillReturnPostLog WITH (UPDLOCK, HOLDLOCK)
        WHERE fiscal_year = @fiscalYear;

        SET @creditNoteNumber = 'CN' + @fiscalYear + '-' + CONVERT(VARCHAR(20), @creditNoteSequence);

        INSERT INTO dbo.CBMS_BillReturnPostLog
        (
            seller_pan, buyer_pan, fiscal_year, buyer_name, ref_invoice_number,
            credit_note_number, credit_note_date, reason_for_return, total_sales,
            taxable_sales_vat, vat, excisable_amount, excise, taxable_sales_hst,
            hst, amount_for_esf, esf, export_sales, tax_exempted_sales,
            isrealtime, datetimeClient, BillReturnDateTime, StatusCode,
            StatusDetails, SalesMasterId, SalesType
        )
        VALUES
        (
            @sellerPan, @buyerPan, @fiscalYear, @buyerName,
            @invoiceCode + @fiscalYear + '-' + CONVERT(VARCHAR(20), @invoiceNo - @firstSalesMasterId),
            @creditNoteNumber, @creditNoteDate, @Reasons, @basicAmount,
            @basicAmount, ISNULL(@vat, 0), 0, 0, 0, 0, 0, 0, 0, 0,
            0, GETDATE(), GETDATE(), 'LOCAL', 'Internal credit note; not submitted to IRD.',
            @salesMasterId, @SalesType
        );

        SET @returnLogId = CONVERT(INT, SCOPE_IDENTITY());

        DECLARE @creditPayments TABLE
        (
            MembershipID INT NOT NULL,
            CreditAmount DECIMAL(18, 2) NOT NULL
        );

        INSERT INTO @creditPayments (MembershipID, CreditAmount)
        SELECT ISNULL(spm.CusID, 0), SUM(ISNULL(spm.PayAmount, 0))
        FROM dbo.RO_CAKE_SalesPaymentMode spm
        WHERE spm.SalesMasterId = @salesMasterId
          AND spm.PaymentModeID = 4
          AND LOWER(ISNULL(spm.SalesType, '')) = LOWER(@SalesType)
        GROUP BY ISNULL(spm.CusID, 0)
        HAVING SUM(ISNULL(spm.PayAmount, 0)) <> 0;

        DECLARE @membershipId INT;
        DECLARE @creditAmount DECIMAL(18, 2);

        DECLARE credit_cursor CURSOR LOCAL FAST_FORWARD FOR
            SELECT MembershipID, CreditAmount FROM @creditPayments;

        OPEN credit_cursor;
        FETCH NEXT FROM credit_cursor INTO @membershipId, @creditAmount;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE dbo.RO_LoyaltyMembership
            SET RemainingBalance = ISNULL(RemainingBalance, 0) - @creditAmount
            WHERE MembershipID = @membershipId;

            INSERT INTO dbo.RO_MemberPay
            (
                MemberID, RemainingAmount, PayAmount, AddedOn, AddedBy,
                IsActive, GoodReceivedMainId, SettlementAmount, ReturnAmount
            )
            VALUES
            (
                @membershipId, -@creditAmount, 0, GETDATE(), @userName,
                1, 0, NULL, 0
            );

            FETCH NEXT FROM credit_cursor INTO @membershipId, @creditAmount;
        END;

        CLOSE credit_cursor;
        DEALLOCATE credit_cursor;

        UPDATE dbo.RO_CakeSalesMaster
        SET IsArchived = 1,
            ArchivedBy = @userName,
            ArchivedOn = GETDATE(),
            Reasons = @Reasons
        WHERE SalesMasterId = @salesMasterId
          AND LOWER(ISNULL(SalesType, '')) = LOWER(@SalesType)
          AND IsArchived = 0;

        UPDATE dbo.RO_CakeOrderMaster
        SET CancelReason = @Reasons,
            StatusId = (SELECT TOP (1) Id FROM dbo.RO_StatusMaster WHERE LOWER(LookUpName) = 'cancelled' ORDER BY Id)
        WHERE OrderMasterID = @orderMasterId
          AND LOWER(ISNULL(SalesType, '')) = LOWER(@SalesType);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('local', 'credit_cursor') >= 0
            CLOSE credit_cursor;
        IF CURSOR_STATUS('local', 'credit_cursor') > -3
            DEALLOCATE credit_cursor;

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO