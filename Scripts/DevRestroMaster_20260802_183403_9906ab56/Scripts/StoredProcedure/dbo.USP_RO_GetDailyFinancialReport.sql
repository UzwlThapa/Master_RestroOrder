SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_RO_GetDailyFinancialReport] 

CREATE PROCEDURE [dbo].[USP_RO_GetDailyFinancialReport] 
@FromDate Date,
@ToDate Date
AS
SELECT        FinancialID, Period, OpeningBalance, Cash, Cheque, Card, Credit, TotalCashReceived, SurplusDeficit, CreditCollectedInCash, CashInCounter, CashSettlement, ClosingBalance, IsClosed, ClosedTS, 
isnull(CreditCollectedInCard,0) as CreditCollectedInCard,
             isnull(CreditCollectedInCheque, 0) as CreditCollectedInCheque, isnull(TotalSales,0) as TotalSales
			 , isnull(TotalExpenses,0) as TotalExpenses, ExpensesRemark
FROM            DailyFinancialReport where(Period  >= @FromDate OR @FromDate IS NULL OR @FromDate='')
AND (Period <= @ToDate OR @ToDate IS NULL OR @ToDate='')


GO
