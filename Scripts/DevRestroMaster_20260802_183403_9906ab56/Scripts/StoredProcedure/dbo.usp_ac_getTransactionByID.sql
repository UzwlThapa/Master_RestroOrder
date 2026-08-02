SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[usp_ac_getTransactionByID] 241372
CREATE PROCEDURE [dbo].[usp_ac_getTransactionByID] -- 13
    @transactionID INT
AS
--declare @transactionID int=2
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
       tt.VoucherTypeID,
	   ttd.TransactionDetailID
FROM Ac_TempTransactionDetail ttd
   LEFT JOIN Ac_FinancialAc fa
        ON ttd.FinancialAcID = fa.FinancialAcID
    JOIN Ac_TempTransaction tt
        ON tt.TransactionID = ttd.TransactionID
WHERE ttd.TransactionID = @transactionID;



GO
