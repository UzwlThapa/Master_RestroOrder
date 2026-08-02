SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---- close daily financial 
--DROP PROC [usp_ro_CloseTheDay] 
CREATE PROCEDURE [dbo].[usp_ro_CloseTheDay] @financialID int
	,@CashSettlement DECIMAL(18, 2)
	,@CashInCounter DECIMAL(18, 2)
	,@ClosingBalance DECIMAL(18, 2)
	,@TotalExpenses DECIMAL(18, 2)
	,@ExpensesRemark nvarchar(max)
AS
BEGIN
	DECLARE @date DATE

	UPDATE DailyFinancialReport
	SET CashSettlement = @CashSettlement
	,TotalExpenses = @TotalExpenses
	,CashInCounter = @CashInCounter
		,ClosingBalance = @ClosingBalance
		,IsClosed = 1
		,ExpensesRemark = @ExpensesRemark
	WHERE FinancialID = @financialID

	SET @date = (
			SELECT Period
			FROM DailyFinancialReport
			WHERE FinancialID = @financialID
			)

	EXEC usp_ro_generateDailyStockReport @date
		,0

	EXEC usp_ro_generateDailySalesReport @date
		,0

	EXEC USP_RO_Generate_Sales_Summary;
END



GO
