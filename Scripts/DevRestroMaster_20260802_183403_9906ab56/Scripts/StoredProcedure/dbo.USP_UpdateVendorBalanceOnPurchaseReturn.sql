SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_UpdateVendorBalanceOnPurchaseReturn]
    @VendorId INT,
    @PurchaseReturnId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ReturnTotal DECIMAL(18, 2);
    DECLARE @CurrentBalance DECIMAL(18, 2);

    SELECT @ReturnTotal = ISNULL(SUM(Total), 0)
    FROM RO_PurchaseReturnDetails
    WHERE PurchaseReturnId = @PurchaseReturnId;

    SELECT @CurrentBalance = RemainingBalance
    FROM RO_LoyaltyMembership
    WHERE MembershipID = @VendorId
          AND IsCustomer = 0;

    UPDATE RO_LoyaltyMembership
    SET RemainingBalance = RemainingBalance - @ReturnTotal
    WHERE MembershipID = @VendorId
          AND IsCustomer = 0;

    INSERT INTO RO_MemberPay
    (
        MemberID,
        RemainingAmount,
        PayAmount,
        AddedOn,
        AddedBy,
        IsActive,
        GoodReceivedMainId,
        SettlementAmount,
        ReturnAmount
    )
    VALUES
    (@VendorId, @CurrentBalance, 0, GETDATE(), 'System', 1, 0, 0, @ReturnTotal);
END;

GO
