SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from [RO_MemberPay]

CREATE PROCEDURE [dbo].[USP_SavePurchaseReturnPaymentMode]
@PRId int
,@paymentModeID int
,@ChequeNo nvarchar(250)
,@TransactionNo nvarchar(250)
,@ProviderID int
,@VendorId int
,@PayAmount decimal(18, 2)
,@Remarks nvarchar(MAX)
,@AddedBy nvarchar(250)

AS 
BEGIN

INSERT INTO RO_PurchaseReturnPaymentMode(
PurchaseReturnId
,paymentModeID
,ChequeNo
,TransactionNo
,ProviderID
,VendorId
,PayAmount
,Remarks
)
VALUES
(
@PRId
,@paymentModeID
,@ChequeNo
,@TransactionNo
,@ProviderID
,@VendorId
,@PayAmount
,@Remarks
)

	IF(@paymentModeID = 4)
	BEGIN
	DECLARE @RemainingBalance decimal(18, 2)

	    SELECT @RemainingBalance=RemainingBalance 
		FROM RO_LoyaltyMembership 
		WHERE MembershipID = @VendorId
		
		UPDATE RO_LoyaltyMembership
		SET RemainingBalance -= @PayAmount
		WHERE MembershipID = @VendorId


		INSERT INTO [dbo].[RO_MemberPay] (
		[MemberID]
		,[RemainingAmount]
		,[PayAmount]
		,[AddedOn]
		,[AddedBy]
		,[IsActive]
		,[GoodReceivedMainId]
		,[SettlementAmount]
		,[ReturnAmount]
		)
	VALUES (
		@VendorId
		,@RemainingBalance
		,-@PayAmount
		,GETDATE()
		,@AddedBy
		,1
		,0
		,0
		,@PayAmount

		)


	END
END

GO
