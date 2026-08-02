SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SavePurchasePaymentMode]
    @GMId INT ,
    @paymentModeID INT ,
    @ChequeNo NVARCHAR (250) ,
    @TransactionNo NVARCHAR (250) ,
    @ProviderID INT ,
    @VendorID INT ,
    @VendorName NVARCHAR (MAX) ,
    @PayAmount DECIMAL (18, 2) ,
    @Remarks NVARCHAR (MAX) ,
    @PAN NVARCHAR (250)
AS
    BEGIN
        INSERT INTO RO_PurchasePaymentMode ( GMId ,
                                             paymentModeID ,
                                             ChequeNo ,
                                             TransactionNo ,
                                             ProviderID ,
                                             VendorID ,
                                             VendorName ,
                                             PayAmount ,
                                             Remarks ,
                                             PAN )
                    SELECT @GMId ,
                           @paymentModeID ,
                           @ChequeNo ,
                           @TransactionNo ,
                           @ProviderID ,
                           CASE WHEN @VendorID = 0 THEN NULL
                                ELSE @VendorID
                           END ,
                           @VendorName ,
                           @PayAmount ,
                           @Remarks ,
                           @PAN;
    END;

GO
