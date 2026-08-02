SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_Credit_CancelReason]
    @MembershipID INT ,
    @salesMasterId INT ,
    @Reasons NVARCHAR (MAX) ,
    @userName NVARCHAR (256) ,
    @cancelledDate VARCHAR (256)
AS
    BEGIN

        -- Insert a new row with the specified values
        INSERT INTO dbo.RO_SalesPaymentMode ( salesMasterId ,
                                              PaymentModeID ,
                                              ChequeNo ,
                                              TransactionNo ,
                                              ProviderID ,
                                              CusID ,
                                              Customer ,
                                              Address ,
                                              PAN ,
                                              PayAmount ,
                                              Remarks ,
                                              ReturnPayment ,
                                              IsCancelled ,
                                              cancelledBy ,
                                              cancelledDate ,
                                              cancelledReasons )
                    SELECT salesMasterId ,
                           PaymentModeID ,
                           ChequeNo ,
                           TransactionNo ,
                           ProviderID ,
                           CusID ,
                           Customer ,
                           Address ,
                           PAN ,
                           - ( PayAmount ) ,
                           Remarks ,
                           ReturnPayment ,
                           1 ,
                           @userName ,
                           @cancelledDate ,
                           @Reasons
                    FROM   dbo.RO_SalesPaymentMode
                    WHERE  salesMasterId = @salesMasterId;

        UPDATE dbo.RO_LoyaltyMembership
        SET    RemainingBalance = RemainingBalance - ( SELECT TOP ( 1 ) rspm.PayAmount
                                                       FROM   dbo.RO_SalesPaymentMode AS rspm
                                                       WHERE  rspm.salesMasterId = @salesMasterId )
        WHERE  MembershipID = @MembershipID;

        RETURN 1;
    END;

GO
