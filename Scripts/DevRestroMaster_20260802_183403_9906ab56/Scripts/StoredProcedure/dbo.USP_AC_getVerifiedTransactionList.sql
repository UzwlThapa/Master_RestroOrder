SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_AC_getVerifiedTransactionList]
    @StartDate NVARCHAR(100),
    @EndDate NVARCHAR(100)
AS
BEGIN


    IF @StartDate = ''
        SET @StartDate = '1900-01-01';
    IF (@EndDate = '')
        SET @EndDate = GETDATE();
    SELECT tt.TransactionID,
           SUM(ttd.Debit) AS totalDebit,
           SUM(ttd.Credit) AS totalCredit,
           vt.VoucherName,
           tt.TransactionDate,
           --,(fa.Name+', ') as FinancialAcName
           tt.Descriptions,
           tt.VoucherNo,
           tt.VerifiedOn,
           tt.VerifiedBy
    FROM Ac_Transaction tt
        JOIN Ac_TransactionDetail ttd
            ON tt.TransactionID = ttd.TransactionID
        JOIN Ac_VoucherType vt
            ON tt.VoucherTypeID = vt.VoucherTypeID
        JOIN Ac_FinancialAc fa
            ON fa.FinancialAcID = ttd.FinancialAcID
    WHERE CAST(tt.TransactionDate AS DATE)
    BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
    GROUP BY tt.TransactionID,
             vt.VoucherName,
             tt.TransactionDate,
             tt.VoucherNo,
             tt.VerifiedOn,
             tt.VerifiedBy,
             --,fa.Name
             tt.Descriptions
    ORDER BY tt.TransactionDate DESC;

END;


GO
