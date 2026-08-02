SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ac_SaveTransactionDetails] @TransactionID INT
	,@FinancialAcID INT
	,@ChequeNo NVARCHAR = NULL
	,@ChequeDate NVARCHAR(256) = NULL
	,@Particulars NVARCHAR(256)
	,@Debit DECIMAL(18, 2)
	,@Credit DECIMAL(18, 2)
AS
BEGIN
	INSERT INTO Ac_TempTransactionDetail (
		[TransactionID]
		,[FinancialAcID]
		,[ChequeNo]
		,[ChequeDate]
		,[Particulars]
		,[Debit]
		,[Credit]
		)
	VALUES (
		@TransactionID
		,@FinancialAcID
		,@ChequeNo
		,@ChequeDate
		,@Particulars
		,@Debit
		,@Credit
		)
END



GO
