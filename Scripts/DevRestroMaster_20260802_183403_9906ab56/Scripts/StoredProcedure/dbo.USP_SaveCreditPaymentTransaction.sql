SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROC [dbo].[USP_SaveCreditPaymentTransaction]
CREATE PROCEDURE [dbo].[USP_SaveCreditPaymentTransaction]
    @MembershipID INT ,
    @PayAmount DECIMAL (18, 2) ,
    @SettlementAmount DECIMAL (18, 2) ,
    @NewVoucherNo NVARCHAR (50) ,
    @PaymentModeID INT ,
    @TransactionNo NVARCHAR (50) ,
    @ProviderID INT ,
    @ReturnAmount DECIMAL (18, 2) = 0
AS
    BEGIN
        DECLARE @CreditParty NVARCHAR (256) = N'' ,
                @IsCustomer BIT ,
                @financialAcId INT ,
                @custfinancialAcId INT;

        SELECT @financialAcId = FinancialAcId
        FROM   dbo.RO_CardProvider
        WHERE  ProviderID = @ProviderID;

        SELECT @IsCustomer = lm.IsCustomer ,
               @CreditParty = lm.Fname + N' ' + lm.Lname ,
               @custfinancialAcId = FinancialAcId
        FROM   dbo.RO_LoyaltyMembership lm
        WHERE  lm.MembershipID = @MembershipID;

        DECLARE @TransactionID INT = 0 ,
                @VoucherTypeID INT ,
                @VoucherNo NVARCHAR (50) ,
                @VoucherDesc NVARCHAR (50);

        IF ( @IsCustomer = 0 )
            BEGIN
                IF ( @ReturnAmount > 0 )
                    BEGIN
                        SET @VoucherTypeID = 3;
                        SET @VoucherNo = N'RV-' + @NewVoucherNo;
                        SET @VoucherDesc = N'Receive Voucher from ' + @CreditParty;
                    END;
                ELSE
                    BEGIN
                        SET @VoucherTypeID = 2;
                        SET @VoucherNo = N'PV-' + @NewVoucherNo;
                        SET @VoucherDesc = N'Payment Voucher for ' + @CreditParty;
                    END; 
            END;
        ELSE
            BEGIN
                IF ( @ReturnAmount > 0 )
                    BEGIN
                        SET @VoucherTypeID = 2;
                        SET @VoucherNo = N'PV-' + @NewVoucherNo;
                        SET @VoucherDesc = N'Payment Voucher for ' + @CreditParty;
                    END;
                ELSE
                    BEGIN
                        SET @VoucherTypeID = 3;
                        SET @VoucherNo = N'RV-' + @NewVoucherNo;
                        SET @VoucherDesc = N'Receive Voucher from ' + @CreditParty;
                    END;

            END;

        INSERT INTO dbo.Ac_TempTransaction ( TransactionDate ,
                                         VoucherTypeID ,
                                         VoucherNo ,
                                         Descriptions ,
                                         PostedBy ,
                                         PostedOn )
        VALUES ( GETDATE (), @VoucherTypeID, @VoucherNo, @VoucherDesc, 'System', GETDATE ());

        SET @TransactionID = SCOPE_IDENTITY();

        IF ( @IsCustomer = 1 )
            BEGIN
                -- Cash   
                INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                       FinancialAcID ,
                                                       MemberShipID ,
                                                       Particulars ,
                                                       Debit ,
                                                       Credit )
                VALUES ( @TransactionID, CASE WHEN @PaymentModeID = 1 THEN 10
                                              ELSE ISNULL (@financialAcId, 11)
                                         END, @MembershipID, CASE WHEN @PaymentModeID = 1 THEN 'Cash A/C'
                                                                  ELSE 'Bank Transaction - ' + @TransactionNo
                                                             END, CASE WHEN @PayAmount > 0 THEN @PayAmount
                                                                       ELSE 0
                                                                  END, CASE WHEN @ReturnAmount > 0 THEN @ReturnAmount
                                                                            ELSE 0
                                                                       END );

                -- Credit Party 
                INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                       FinancialAcID ,
                                                       MemberShipID ,
                                                       Particulars ,
                                                       Debit ,
                                                       Credit )
                VALUES ( @TransactionID, ISNULL (@custfinancialAcId, 15), @MembershipID ,
                         'Account Payee - ' + @CreditParty ,
                         CASE WHEN @ReturnAmount > 0 THEN ( @ReturnAmount + @SettlementAmount )
                              ELSE 0
                         END, CASE WHEN @PayAmount > 0 THEN ( @PayAmount + @SettlementAmount )
                                   ELSE 0
                              END );



                -- Settlement
                IF ( @SettlementAmount > 0 )
                    BEGIN
                        INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                               FinancialAcID ,
                                                               MemberShipID ,
                                                               Particulars ,
                                                               Debit ,
                                                               Credit )
                        VALUES ( @TransactionID, 29 , --42 
                                 0, 'Cash Settlement', CASE WHEN @PayAmount > 0 THEN @SettlementAmount
                                                            ELSE 0
                                                       END, CASE WHEN @ReturnAmount > 0 THEN @SettlementAmount
                                                                 ELSE 0
                                                            END );
                    END;
            END;
        ELSE
            BEGIN

                DECLARE @Company NVARCHAR (MAX) = N'';

                SELECT TOP ( 1 ) @Company = Name
                FROM   dbo.RO_CompanyInfo ORDER BY ID;


                -- Cash   
                INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                       FinancialAcID ,
                                                       MemberShipID ,
                                                       Particulars ,
                                                       Debit ,
                                                       Credit )
                VALUES ( @TransactionID ,
                         ISNULL (@custfinancialAcId, 15) , --case when @PaymentModeID = 1 then 10 else isnull(@custfinancialAcId,15) end
                         @MembershipID, 'Account Payee- ' + @CreditParty , --,case when @PaymentModeID = 1 then 'Cash Paid To - ' + @CreditParty
                                                           --else 'Bank Transaction - ' + @TransactionNo end
                         CASE WHEN @PayAmount > 0 THEN @PayAmount
                              ELSE 0
                         END, CASE WHEN @ReturnAmount > 0 THEN @ReturnAmount
                                   ELSE 0
                              END );

                -- Credit Party 
                INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                       FinancialAcID ,
                                                       MemberShipID ,
                                                       Particulars ,
                                                       Debit ,
                                                       Credit )
                VALUES ( @TransactionID, CASE WHEN @PaymentModeID = 1 THEN 10
                                              ELSE ISNULL (@financialAcId, 11)
                                         END, @MembershipID , --,'Account Payee - ' + @Company
                         CASE WHEN @PaymentModeID = 1 THEN 'Account Payee - ' + @CreditParty
                              ELSE 'Account Payee - ' + @CreditParty + ' #' + @TransactionNo
                         END, CASE WHEN @ReturnAmount > 0 THEN ( @ReturnAmount + @SettlementAmount )
                                   ELSE 0
                              END, CASE WHEN @PayAmount > 0 THEN ( @PayAmount + @SettlementAmount )
                                        ELSE 0
                                   END );


                -- Settlement
                IF ( @SettlementAmount > 0 )
                    BEGIN
                        INSERT INTO dbo.Ac_TempTransactionDetail ( TransactionID ,
                                                               FinancialAcID ,
                                                               MemberShipID ,
                                                               Particulars ,
                                                               Debit ,
                                                               Credit )
                        VALUES ( @TransactionID, 29 , --42 
                                 0, 'Cash Settlement', CASE WHEN @PayAmount > 0 THEN @SettlementAmount
                                                            ELSE 0
                                                       END, CASE WHEN @ReturnAmount > 0 THEN @SettlementAmount
                                                                 ELSE 0
                                                            END );
                    END;
            END;

        SELECT @TransactionID;
    END;

GO
