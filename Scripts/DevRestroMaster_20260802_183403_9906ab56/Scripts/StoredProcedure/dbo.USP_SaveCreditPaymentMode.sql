SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SaveCreditPaymentMode]
    @MemberPayId INT ,
    @MemberID INT ,
    @PaymentModeID INT ,
    @ProviderID INT ,
    @TransactionNo NVARCHAR (256) ,
    @PayAmount DECIMAL (18, 2) ,
    @SettlementAmount DECIMAL (18, 2) ,
    @VoucherNo NVARCHAR (256) ,
    @TransactionId INT ,
    @ReturnAmount DECIMAL (18, 2) = 0
AS
    BEGIN
        DECLARE @IsCustomer BIT;

        SELECT @IsCustomer = lm.IsCustomer
        FROM   dbo.RO_LoyaltyMembership lm
        WHERE  lm.MembershipID = @MemberID;

        IF ( @IsCustomer = 0 )
            BEGIN
                IF ( @ReturnAmount > 0 )
                    SET @VoucherNo = 'PV-' + @VoucherNo;
                ELSE
                    SET @VoucherNo = 'RV-' + @VoucherNo;
            END;
        ELSE
            BEGIN
                IF ( @ReturnAmount > 0 )
                    SET @VoucherNo = 'RV-' + @VoucherNo;
                ELSE
                    SET @VoucherNo = 'PV-' + @VoucherNo;
            END;

        INSERT INTO dbo.RO_MemberPaymentMode ( MemberPayId ,
                                               VoucherNo ,
                                               MemberID ,
                                               PaymentModeID ,
                                               ProviderID ,
                                               TransactionNo ,
                                               PayAmount ,
                                               SettlementAmount ,
                                               TransactionID ,
                                               ReturnAmount )
        VALUES ( @MemberPayId, @VoucherNo, @MemberID, @PaymentModeID, @ProviderID, @TransactionNo, @PayAmount ,
                 @SettlementAmount , @TransactionId, @ReturnAmount );
    END;


GO
