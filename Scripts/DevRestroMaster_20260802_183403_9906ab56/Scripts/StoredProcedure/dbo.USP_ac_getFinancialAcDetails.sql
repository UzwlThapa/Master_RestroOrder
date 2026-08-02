SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ac_getFinancialAcDetails] 
@FinancialAcID int
,@date date
as

declare @startDate date
select @startDate = cast(StartDate as date) from RO_fiscalYear where @date between StartDate and EndDate
SELECT Fa.FinancialAcID
	,Fa.NAME AS FinancialAcName
	,Fs.IsGroup
	,SUM(ISNULL(AD.Credit, 0)) AS Credit
	,SUM(ISNULL(AD.Debit, 0)) AS Debit
FROM Ac_FinancialAc Fa
INNER JOIN Ac_FinancialSys Fs ON Fa.FinancialSysID = Fs.FinancialSysID
INNER JOIN Ac_TransactionDetail AD ON Fa.FinancialAcID = AD.FinancialAcID
INNER JOIN Ac_Transaction TM ON TM.TransactionID = AD.TransactionID
WHERE cast(TM.TransactionDate as date) between @startDate and @date
and Fa.PFinancialAcID = @FinancialAcID
GROUP BY Fa.FinancialAcID
	,Fa.NAME
	,Fs.IsGroup
order by FinancialAcName asc

GO
