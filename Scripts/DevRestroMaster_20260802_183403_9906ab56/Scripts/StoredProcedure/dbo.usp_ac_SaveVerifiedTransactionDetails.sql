SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ac_SaveVerifiedTransactionDetails] @TransactionID INT
	,@FinancialAcID INT
	,@ChequeNo nvarchar=null
	,@ChequeDate nvarchar(256)=null
	,@Particulars NVARCHAR(256)
	,@Debit DECIMAL(18, 2)
	,@Credit DECIMAL(18, 2)
AS
INSERT INTO Ac_TransactionDetail (
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



GO
