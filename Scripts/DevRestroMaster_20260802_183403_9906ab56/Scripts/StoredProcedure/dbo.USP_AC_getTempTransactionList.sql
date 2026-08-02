SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_AC_getTempTransactionList]
    @StartDate NVARCHAR (100) NULL ,
    @EndDate NVARCHAR (100) NULL
AS
    BEGIN

        IF ISNULL (@StartDate, '') = ''
            BEGIN
                SELECT @StartDate = DATEADD (DAY, 7, GETDATE ());
            END;
        IF ISNULL (@EndDate, '') = ''
            BEGIN
                SELECT @EndDate = GETDATE ();
            END;

        SELECT   tt.TransactionID ,
                 SUM (ttd.Debit) AS totalDebit ,
                 SUM (ttd.Credit) AS totalCredit ,
                 vt.VoucherName ,
                 tt.TransactionDate ,
                 tt.Descriptions ,
                 tt.VoucherNo
        FROM     dbo.Ac_TempTransaction tt
                 INNER JOIN dbo.Ac_TempTransactionDetail ttd ON tt.TransactionID = ttd.TransactionID
                 INNER JOIN dbo.Ac_VoucherType vt ON tt.VoucherTypeID = vt.VoucherTypeID
                 INNER JOIN dbo.Ac_FinancialAc fa ON fa.FinancialAcID = ttd.FinancialAcID
        WHERE    tt.IsDeleted = 0
        AND      tt.IsVerified = 0
        AND      CAST(tt.TransactionDate AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
        GROUP BY tt.TransactionID ,
                 vt.VoucherName ,
                 tt.TransactionDate ,
                 tt.VoucherNo ,
                 tt.Descriptions
        ORDER BY tt.TransactionDate DESC;

    END;

GO
