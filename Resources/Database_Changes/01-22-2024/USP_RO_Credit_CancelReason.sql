USE [RO-CHICKENSTATION]
GO
/****** Object:  StoredProcedure [dbo].[USP_RO_Credit_CancelReason]    Script Date: 1/22/2024 12:11:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[USP_RO_Credit_CancelReason] 
    @MembershipID INT,
    @salesMasterId INT,
    @Reasons NVARCHAR(max),
    @userName NVARCHAR(256),
    @cancelledDate NVARCHAR(256)
AS
BEGIN

    -- Insert a new row with the specified values
    INSERT INTO RO_SalesPaymentMode (
        salesMasterId,
        PaymentModeID,
        ChequeNo,
        TransactionNo,
        ProviderID,
        CusID,
        Customer,
        Address,
        PAN,
        PayAmount,
        Remarks,
        ReturnPayment,
        IsCancelled,
        cancelledBy,
        cancelledDate,
        cancelledReasons
    )
    SELECT 
        salesMasterId,
        PaymentModeID,
        ChequeNo,
        TransactionNo,
        ProviderID,
        CusID,
        Customer,
        Address,
        PAN,
        -(PayAmount),
        Remarks,
        ReturnPayment,
        1, 
        @userName,
        @cancelledDate,
        @Reasons
    FROM RO_SalesPaymentMode
    WHERE salesPaymentId = @salesMasterId;

	UPDATE RO_LoyaltyMembership
SET RemainingBalance = RemainingBalance - (
    SELECT PayAmount
    FROM RO_SalesPaymentMode
    WHERE salesPaymentId = @salesMasterId
)
WHERE MembershipID = @MembershipID;
	return 1
END
