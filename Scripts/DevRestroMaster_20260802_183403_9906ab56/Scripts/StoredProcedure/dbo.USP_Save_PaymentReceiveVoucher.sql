SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC USP_Save_PaymentReceiveVoucher 1,4673,'Test from Database',5000,2,4674,'1234568','2023-05-09','Test of Payment Voucher from Cheque','2023-05-08','Superuser'
CREATE PROCEDURE [dbo].[USP_Save_PaymentReceiveVoucher]
	@VoucherTypeId INT -- 1 is for Payment 2 is for Receive
	,@FinancialAcId INT
	,@Particulars NVARCHAR(50)
	,@Amount DECIMAL(15,2)
	,@PaymentModeId INT
	,@BankAccId INT
	,@ChequeNo NVARCHAR(50)
	,@ChequeDate DATETIME
	,@Description NVARCHAR(MAX)
	,@VoucherDate DATETIME
	,@CreatedBy NVARCHAR(100)
AS
BEGIN
	
BEGIN TRANSACTION
BEGIN TRY
	IF @VoucherTypeId=1 -- Payment Voucher
	BEGIN

	DECLARE @PaymentTempId INT
	 --Query for adding payment voucher
	 INSERT INTO Ac_TempTransaction
	 ( TransactionDate
		,VoucherTypeID
		,Descriptions
		,PostedOn
		,PostedBy
		,IsVerified
	 ) VALUES
	 (@VoucherDate
	 ,2
	 ,@Description
	 ,GETDATE()
	 ,@CreatedBy
	 ,0
	 )

	 SET @PaymentTempId = @@IDENTITY

	 INSERT INTO Ac_TempTransactionDetail
	 ( TransactionID,
	 FinancialAcID,
	 Particulars,
	 Debit,
	 Credit
	 ) VALUES
	 (
		@PaymentTempId,
		@FinancialAcId,
		@Particulars,
		@Amount,
		0
	 ),
	 (
		@PaymentTempId,
		CASE 
		WHEN @PaymentModeId=1 THEN 10
		ELSE @BankAccId 
		END,
		CASE 
		WHEN @PaymentModeId=2 THEN CONCAT(@Particulars,' [Cheque No:',@ChequeNo,' Cheque Date:',@ChequeDate,']')
		ELSE @Particulars 
		END,
		0,
		@Amount
	 )

	END
	ELSE IF @VoucherTypeId=2
	BEGIN

	DECLARE @ReceiveTempId INT
	 --Query for adding payment voucher
	 INSERT INTO Ac_TempTransaction
	 ( TransactionDate
		,VoucherTypeID
		,Descriptions
		,PostedOn
		,PostedBy
		,IsVerified
	 ) VALUES
	 (@VoucherDate
	 ,3
	 ,@Description
	 ,GETDATE()
	 ,@CreatedBy
	 ,0
	 )

	 SET @ReceiveTempId = @@IDENTITY

	 INSERT INTO Ac_TempTransactionDetail
	 ( TransactionID,
	 FinancialAcID,
	 Particulars,
	 Debit,
	 Credit
	 ) VALUES
	 (
		@ReceiveTempId,
		@FinancialAcId,
		@Particulars,
		0,
		@Amount
	 ),
	 (
		@ReceiveTempId,
		CASE 
		WHEN @PaymentModeId=1 THEN 10
		ELSE @BankAccId 
		END,
		CASE 
		WHEN @PaymentModeId=2 THEN CONCAT(@Particulars,' [Cheque No:',@ChequeNo,' Cheque Date:',@ChequeDate,']')
		ELSE @Particulars 
		END,
		@Amount,
		0
	 )

	END

COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION
END CATCH
END

GO
