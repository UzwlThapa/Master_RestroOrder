SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Ac_AddACLoyaltyOpeningBalance]
    @MembershipId INT ,
    @AcId INT ,
    @OpeningDate DATETIME ,
    @OpeningAmt DECIMAL (15, 2) ,
    @AddedBy VARCHAR (50) ,
    @IsDebit BIT ,
    @IsAdd BIT
AS
    BEGIN

        IF ( @IsAdd = 1 )
            BEGIN
                INSERT INTO dbo.Ac_Transaction ( TransactionDate ,
                                                 VoucherTypeID ,
                                                 VoucherNo ,
                                                 Descriptions ,
                                                 PostedBy ,
                                                 PostedOn ,
                                                 VerifiedOn )
                VALUES ( CAST(@OpeningDate AS DATE), 57, 'Opening', 'Opening Balance', ISNULL (@AddedBy, '') ,
                         GETDATE (), GETDATE ());

                DECLARE @TranId INT = SCOPE_IDENTITY ();

                INSERT INTO dbo.Ac_TransactionDetail ( TransactionID ,
                                                       FinancialAcID ,
                                                       Particulars ,
                                                       Debit ,
                                                       Credit )
                VALUES ( @TranId, @AcId, 'Opening Balance', CASE WHEN @IsDebit = 1 THEN @OpeningAmt
                                                                 ELSE 0.00
                                                            END, CASE WHEN @IsDebit = 0 THEN @OpeningAmt
                                                                      ELSE 0.00
                                                                 END );

                INSERT INTO [dbo].[Ac_OpeningBalanceDetail] ( IsLoyalty ,
                                                              MemberShipId ,
                                                              TranId ,
                                                              [TranDate] ,
                                                              [IsDebit] ,
                                                              [AddedOn] ,
                                                              [AddedBy] ,
                                                              OpeningAmt )
                VALUES ( 1, @MembershipId, @TranId, @OpeningDate, @IsDebit, GETDATE (), @AddedBy, @OpeningAmt );
				 
            END;
        ELSE
            BEGIN

                IF EXISTS ( SELECT TOP ( 1 ) o.TranId
                            FROM   [dbo].[Ac_OpeningBalanceDetail] o
                                   INNER JOIN dbo.Ac_Transaction AS t ON t.TransactionID = o.TranId
                                   INNER JOIN dbo.Ac_TransactionDetail AS atd ON atd.TransactionID = t.TransactionID
                            WHERE  o.MemberShipId = @MembershipId
                            AND    atd.FinancialAcID = @AcId )
                    BEGIN
                        DECLARE @fcid INT = ISNULL (
                                            ( SELECT   TOP ( 1 ) o.TranId
                                              FROM     [dbo].[Ac_OpeningBalanceDetail] o
                                                       INNER JOIN dbo.Ac_Transaction AS t ON t.TransactionID = o.TranId
                                              WHERE    o.MemberShipId = @MembershipId
                                              ORDER BY o.MemberShipId ) ,
                                            0);

                        UPDATE [dbo].[Ac_OpeningBalanceDetail]
                        SET    UpdatedOn = GETDATE () ,
                               OpeningAmt = @OpeningAmt ,
                               IsDebit = @IsDebit
                        WHERE  MemberShipId = @MembershipId;

                        DECLARE @TransactionId INT = 0;
                        SELECT @TransactionId = att.TransactionID
                        FROM   dbo.Ac_Transaction AS att
                               INNER JOIN dbo.Ac_TransactionDetail AS atd ON atd.TransactionID = att.TransactionID
                        WHERE  att.Descriptions = 'Opening Balance'
                        AND    att.VoucherNo = 'Opening'
                        AND    atd.MemberShipID = @MembershipId;

                        IF ( @IsDebit = 1 )
                            BEGIN
                                UPDATE dbo.Ac_Transaction
                                SET    BillDate = @OpeningDate
                                WHERE  TransactionID = @fcid;

                                UPDATE dbo.Ac_TransactionDetail
                                SET    Debit = @OpeningAmt ,
                                       Credit = 0
                                WHERE  TransactionID = @fcid;

                                UPDATE dbo.Ac_TransactionDetail
                                SET    Debit = @OpeningAmt ,
                                       Credit = 0
                                WHERE  TransactionID = @TransactionId
                                AND    MemberShipID = @MembershipId;
                            END;
                        ELSE
                            BEGIN
                                UPDATE dbo.Ac_Transaction
                                SET    BillDate = @OpeningDate
                                WHERE  TransactionID = @fcid;

                                UPDATE dbo.Ac_TransactionDetail
                                SET    Debit = 0 ,
                                       Credit = @OpeningAmt
                                WHERE  TransactionID = @fcid;


                                UPDATE dbo.Ac_TransactionDetail
                                SET    Debit = 0 ,
                                       Credit = @OpeningAmt
                                WHERE  TransactionID = @TransactionId
                                AND    MemberShipID = @MembershipId;
                            END;
                    END;
                ELSE
                    BEGIN
                        DECLARE @TranDate DATETIME = ISNULL (( SELECT AddedOn
                                                               FROM   dbo.RO_LoyaltyMembership
                                                               WHERE  MembershipID = @MembershipId ) ,
                                                             0);

                        INSERT INTO dbo.Ac_Transaction ( TransactionDate ,
                                                         VoucherTypeID ,
                                                         VoucherNo ,
                                                         Descriptions ,
                                                         PostedBy ,
                                                         PostedOn ,
                                                         VerifiedOn ,
                                                         BillDate )
                        VALUES ( CAST(@OpeningDate AS DATE), 57, 'Opening', 'Opening Balance', ISNULL (@AddedBy, '') ,
                                 @TranDate , @TranDate, @TranDate );

                        DECLARE @UpdateTranId INT = SCOPE_IDENTITY ();

                        INSERT INTO dbo.Ac_TransactionDetail ( TransactionID ,
                                                               FinancialAcID ,
                                                               Particulars ,
                                                               Debit ,
                                                               Credit )
                                    SELECT @UpdateTranId ,
                                           @AcId ,
                                           'Opening Balance' ,
                                           CASE WHEN @IsDebit = 1 THEN @OpeningAmt
                                                ELSE 0.00
                                           END ,
                                           CASE WHEN @IsDebit = 0 THEN @OpeningAmt
                                                ELSE 0.00
                                           END;

                        IF EXISTS ( SELECT TOP ( 1 ) 1
                                    FROM   [dbo].[Ac_OpeningBalanceDetail] o
                                    WHERE  o.MemberShipId = @MembershipId )
                            BEGIN
                                UPDATE [aobd]
                                SET    aobd.TranId = @UpdateTranId
                                FROM   [dbo].[Ac_OpeningBalanceDetail] AS [aobd]
                                WHERE  aobd.MemberShipId = @MembershipId;
                            END;
                        ELSE
                            BEGIN
                                INSERT INTO [dbo].[Ac_OpeningBalanceDetail] ( IsLoyalty ,
                                                                              MemberShipId ,
                                                                              TranId ,
                                                                              [TranDate] ,
                                                                              [IsDebit] ,
                                                                              [AddedOn] ,
                                                                              [AddedBy] ,
                                                                              OpeningAmt )
                                VALUES ( 1, @MembershipId, @UpdateTranId, @OpeningDate, @IsDebit, @TranDate, @AddedBy ,
                                         @OpeningAmt );
                            END;
                    END;
            END;

    END;

GO
