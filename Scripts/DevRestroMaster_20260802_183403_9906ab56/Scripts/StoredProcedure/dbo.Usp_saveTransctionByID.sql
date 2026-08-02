SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 10/15/2023
====================================

EXEC dbo.Usp_saveTransctionByID @TransactionID = 0
*/
CREATE PROCEDURE [dbo].[Usp_saveTransctionByID]
    @TransactionID INT
AS
    BEGIN
        DECLARE @Debit DECIMAL (10, 2) ,
                @Credit DECIMAL (10, 2) ,
                @VoucherTypeID INT;


        SELECT @Debit = SUM (ttd.Debit) ,
               @Credit = SUM (ttd.Credit)
        FROM   dbo.Ac_TempTransactionDetail ttd
               JOIN dbo.Ac_FinancialAc fa ON ttd.FinancialAcID = fa.FinancialAcID
               JOIN dbo.Ac_TempTransaction tt ON tt.TransactionID = ttd.TransactionID
        WHERE  ttd.TransactionID = @TransactionID;

        IF ( @Debit = @Credit )
            BEGIN
                INSERT INTO dbo.Ac_Transaction ( TransactionDate ,
                                             VoucherTypeID ,
                                             Descriptions ,
                                             PostedBy ,
                                             PostedOn ,
                                             VerifiedOn ,
                                             BillDate ,
                                             SalesMasterId )
                            SELECT TransactionDate ,
                                   VoucherTypeID ,
                                   Descriptions ,
                                   PostedBy ,
                                   PostedOn ,
                                   GETDATE () ,
                                   BillDate ,
                                   SalesMasterId
                            FROM   dbo.Ac_TempTransaction
                            WHERE  TransactionID = @TransactionID;

                UPDATE dbo.Ac_TempTransaction
                SET    IsVerified = 1
                WHERE  TransactionID = @TransactionID;

                UPDATE dbo.Ac_VoucherType
                SET    VoucherCount = VoucherCount + 1
                WHERE  VoucherTypeID = ( SELECT VoucherTypeID
                                         FROM   dbo.Ac_TempTransaction
                                         WHERE  TransactionID = @TransactionID );

                DECLARE @prefix NVARCHAR (256);
                SELECT @prefix = Prefix
                FROM   dbo.Ac_VoucherType
                WHERE  [VoucherTypeID] = ( SELECT VoucherTypeID
                                           FROM   dbo.Ac_TempTransaction
                                           WHERE  TransactionID = @TransactionID );

                DECLARE @VoucherNo NVARCHAR (256);

                SET @VoucherNo = @prefix + N'-'
                                 + CONVERT (
                                       NVARCHAR (256) ,
                                   ( SELECT VoucherCount
                                     FROM   dbo.Ac_VoucherType
                                     WHERE  VoucherTypeID = ( SELECT VoucherTypeID
                                                              FROM   dbo.Ac_TempTransaction
                                                              WHERE  TransactionID = @TransactionID )));

                UPDATE dbo.Ac_Transaction
                SET    [VoucherNo] = @VoucherNo
                WHERE  TransactionID = @@IDENTITY;


                INSERT INTO dbo.Ac_TransactionDetail ( [TransactionID] ,
                                                   [FinancialAcID] ,
                                                   [ChequeNo] ,
                                                   [ChequeDate] ,
                                                   [Particulars] ,
                                                   [Debit] ,
                                                   [Credit] )
                            SELECT @@IDENTITY ,
                                   ttd.FinancialAcID ,
                                   ttd.ChequeNo ,
                                   ttd.ChequeDate ,
                                   ttd.Particulars ,
                                   ttd.Debit ,
                                   ttd.Credit
                            FROM   dbo.Ac_TempTransactionDetail ttd
                                   JOIN dbo.Ac_FinancialAc fa ON ttd.FinancialAcID = fa.FinancialAcID
                                   JOIN dbo.Ac_TempTransaction tt ON tt.TransactionID = ttd.TransactionID
                            WHERE  ttd.TransactionID = @TransactionID;

            END;

    END;

GO
