SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--usp_GetLedgerDetail  10002
CREATE PROCEDURE [dbo].[usp_GetLedgerDetail] @TransactionID INT
AS
--declare @transactionID int =10
--declare @transactionID int=2

SELECT tt.TransactionID,
       SUM(ttd.Debit) AS totalDebit,
       SUM(ttd.Credit) AS totalCredit,
       vt.VoucherName,
       FORMAT(tt.TransactionDate,'yyyy-MM-dd') TransactionDate,
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
WHERE tt.TransactionID = @TransactionID
GROUP BY tt.TransactionID,
         vt.VoucherName,
         tt.TransactionDate,
         tt.VoucherNo,
         tt.VerifiedOn,
         tt.VerifiedBy,
         --,fa.Name
         tt.Descriptions;

SELECT fa.Name AS financialAcName,
       ttd.FinancialAcID,
       ttd.Particulars,
       ttd.Debit,
       ttd.Credit,
       ttd.ChequeNo,
       ttd.ChequeDate,
       tt.PostedBy,
       CAST(tt.PostedOn AS DATE) AS PostedOn,
       ttd.TransactionDetailID,
       tt.VoucherTypeID
FROM Ac_TransactionDetail ttd
    JOIN Ac_FinancialAc fa
        ON ttd.FinancialAcID = fa.FinancialAcID
    JOIN Ac_Transaction tt
        ON tt.TransactionID = ttd.TransactionID
WHERE ttd.TransactionID = @TransactionID;



GO
