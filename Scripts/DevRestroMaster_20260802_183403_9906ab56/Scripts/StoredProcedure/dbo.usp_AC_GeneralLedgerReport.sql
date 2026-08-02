SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_AC_GeneralLedgerReport] 1,'04/04/2016','04/04/2017'
CREATE PROCEDURE [dbo].[usp_AC_GeneralLedgerReport]
 @VoucherNo int ,
 @Start datetime,
 @End datetime
 as


select convert(NVARCHAR, T.TransactionDate, 101) as TransactionDate,Fa.Name as FinanceName ,(SELECT top(1) Name  FROM RO_CompanyInfo) as CompanyName,TD.Debit, TD.Credit from Ac_Transaction T
inner join  Ac_TransactionDetail TD  on t.TransactionID = TD.TransactionID
inner join Ac_FinancialAc FA on FA.FinancialAcID = TD.FinancialAcID
where T.TransactionDate between @Start and @End 
and T.VoucherTypeID = @VoucherNo



GO
