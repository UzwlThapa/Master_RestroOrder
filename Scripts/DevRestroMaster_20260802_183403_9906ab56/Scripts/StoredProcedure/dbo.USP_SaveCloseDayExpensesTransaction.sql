SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SaveCloseDayExpensesTransaction]
 @financialAcId INT 
	as
	DECLARE @TotalExpenses decimal(18,2)
	DECLARE @TransactionID INT = 0
		,@VoucherTypeID INT = 2
		,@VoucherDesc NVARCHAR(50)
DECLARE @PREFX NVARCHAR(10)
		,@VoucherCount INT = 0
			,@VoucherNo NVARCHAR(50) = ''

DECLARE @Company NVARCHAR(max) = ''
SELECT TOP (1) @Company = NAME
		FROM ro_companyinfo
	select @TotalExpenses=TotalExpenses from DailyFinancialReport where FinancialID=@financialAcId

SELECT @PREFX = Prefix
	,@VoucherCount = VoucherCount	
	FROM Ac_VoucherType
	WHERE VoucherTypeID = @VoucherTypeID

	IF (@TotalExpenses > 0)
	BEGIN
	SET @VoucherCount = @VoucherCount + 1
	SET @VoucherNo = @PREFX + '-' + cast(@VoucherCount AS VARCHAR(20))
		SET @VoucherDesc = 'Miscellaenous Expenses from closeday ' + convert(nvarchar, getdate(), 23)

	INSERT INTO Ac_TempTransaction (
		TransactionDate
		,VoucherTypeID
		,VoucherNo
		,Descriptions
		,PostedBy
		,PostedOn
		)
	VALUES (
		GETDATE()
		,@VoucherTypeID
		,@VoucherNo
		,@VoucherDesc
		,'System'
		,GETDATE()
		)

	SET @TransactionID = @@IDENTITY

	INSERT INTO Ac_TempTransactionDetail (
				TransactionID
				,FinancialAcID
				,MemberShipID
				,Particulars
				,Debit
				,Credit
				)
			VALUES (
				@TransactionID
				,36
				,0
				,'Cash paid for Miscellaenous Expenses'
				,@TotalExpenses
				,0
				)


INSERT INTO Ac_TempTransactionDetail (
			TransactionID
			,FinancialAcID
			,MemberShipID
			,Particulars
			,Debit
			,Credit
			)
		VALUES (
			@TransactionID
			,10
			,0
			,'Account Payee - ' + @Company
			,0
			,@TotalExpenses
			)


	SELECT @TransactionID
		END

GO
