SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP PROC [dbo].[USP_SaveAdvancePaymentTransaction] 
CREATE PROCEDURE [dbo].[USP_SaveAdvancePaymentTransaction] 
	@MembershipID INT
	,@PayAmount DECIMAL(18, 2)
	,@NewVoucherNo NVARCHAR(50)
	,@PaymentModeID int
	,@TransactionNo NVARCHAR(50)
	,@ProviderID Int
	,@Membername NVARCHAR(250)
AS
BEGIN
	DECLARE @financialAcId int
	,@custfinancialAcId int

	select @financialAcId = FinancialAcId from RO_CardProvider
	where ProviderID=@ProviderID

	if(@MembershipID <> 0)
	BEGIN
	SELECT @custfinancialAcId = FinancialAcId
	FROM ro_loyaltymembership lm
	WHERE lm.MembershipID = @MembershipID

		UPDATE RO_LoyaltyMembership
		SET RemainingBalance -= @PayAmount
		WHERE MembershipID = @MembershipID
	END
	ELSE
	BEGIN
	set @custfinancialAcId = 28
	END

	DECLARE @TransactionID INT = 0
		,@VoucherTypeID INT
		,@VoucherNo NVARCHAR(50)
		,@VoucherDesc NVARCHAR(50)

		SET @VoucherTypeID = 3
		SET @VoucherNo = 'RV-' + @NewVoucherNo
		SET @VoucherDesc = 'Advance payment From ' + @Membername
	

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
		-- Cash   
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
			,case when @PaymentModeID = 1 then 10 else isnull(@financialAcId,11) end
			,@MembershipID
			,case when @PaymentModeID = 1 then 'Cash Recieved'
			else 'Bank Transaction - ' + @TransactionNo end
			,@PayAmount
			,0
			)

		--advance Payment
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
			,isnull(@custfinancialAcId,28)
			,@MembershipID
			,'Advance Payee - ' + @Membername
			,0
			,@PayAmount
			)

	

	SELECT @TransactionID
END

GO
