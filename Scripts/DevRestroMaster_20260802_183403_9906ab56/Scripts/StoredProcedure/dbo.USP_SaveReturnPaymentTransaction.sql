SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SaveReturnPaymentTransaction] 
@PayAmount DECIMAL(18, 2)
,@PaymentModeID int
,@TransactionNo NVARCHAR(50)
,@ProviderID Int
,@MembershipID int 
,@Membername NVARCHAR(350)
AS
BEGIN
	DECLARE @financialAcId int
		,@custfinancialAcId int
	DECLARE @PREFX NVARCHAR(10)
		,@VoucherCount INT = 0
		,@VoucherTypeID INT = 16
		,@VoucherNo NVARCHAR(50) = ''


	SELECT @VoucherCount = 0
			,@VoucherTypeID = 2
			,@VoucherNo = ''
				DECLARE @BillDate DATETIME
			,@VoucherDesc NVARCHAR(256) = ''

	SELECT @PREFX = Prefix
		,@VoucherCount = VoucherCount
	FROM Ac_VoucherType
	WHERE VoucherTypeID = @VoucherTypeID

	SET @VoucherCount = @VoucherCount + 1
	SET @VoucherNo = @PREFX + '-' + cast(@VoucherCount AS VARCHAR(20))


	select @financialAcId = FinancialAcId from RO_CardProvider
	where ProviderID=@ProviderID

	if(@MembershipID <> 0)
	BEGIN
		SELECT @custfinancialAcId = FinancialAcId
		FROM ro_loyaltymembership lm
		WHERE lm.MembershipID = @MembershipID  and isnull(IsArchived,0) != 1
	END
	ELSE
	BEGIN
	SET @custfinancialAcId  = 28
	END

	DECLARE @TransactionID INT = 0
		SET @VoucherDesc = 'Cash Returned To - ' + @Membername
	

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
			,case when @PaymentModeID = 1 then 'Cash Paid To -' + @Membername
			else 'Paid To - ' + @Membername + 'Bank Transaction - ' + @TransactionNo end
			,0
			,@PayAmount
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
			,isnull(@custfinancialAcId, 28)
			,@MembershipID
			,'Cash Returned To - ' + @Membername
			,@PayAmount
			,0
			)

	if(@MembershipID <> 0)
	BEGIN
		DECLARE @MemberPayId INT = 0
		SELECT @custfinancialAcId = FinancialAcId
		FROM ro_loyaltymembership lm
		WHERE lm.MembershipID = @MembershipID and lm.IsArchived != 1

			UPDATE RO_LoyaltyMembership
			SET RemainingBalance += @PayAmount
			WHERE MembershipID = @MembershipID

		INSERT INTO [dbo].[RO_MemberPay] (
		[MemberID],[RemainingAmount],[PayAmount],[AddedOn],[AddedBy],[IsActive],[GoodReceivedMainId],[ReturnAmount])
		VALUES (@MembershipID,0,-@PayAmount,GETDATE(),'',1,0,@PayAmount)

		SET @MemberPayId = @@IDENTITY

		INSERT INTO RO_MemberPaymentMode (
		MemberPayId
		,VoucherNo
		,MemberID
		,PaymentModeID
		,ProviderID
		,TransactionNo
		,PayAmount
		,SettlementAmount
		,TransactionID
		,ReturnAmount
		)
	VALUES (
		@MemberPayId
		,@VoucherNo
		,@MembershipID
		,@PaymentModeID
		,@ProviderID
		,@TransactionNo
		,0
		,0
		,@TransactionId
		,@PayAmount
		)
	END
	SELECT @Membername
END

GO
