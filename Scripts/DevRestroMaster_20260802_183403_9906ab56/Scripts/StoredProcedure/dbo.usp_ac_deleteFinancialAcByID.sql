SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC 
CREATE PROCEDURE [dbo].[usp_ac_deleteFinancialAcByID]
    @id INT ,
    @username NVARCHAR (256)
AS
    DECLARE @MSG NVARCHAR (50);

    BEGIN TRANSACTION;
    BEGIN TRY
        IF EXISTS ( SELECT TOP ( 1 ) *
                    FROM   Ac_TempTransactionDetail
                    WHERE  FinancialAcID = @id )
            BEGIN
                SET @MSG = N'Transactions had been done. Cannot be deleted !!!';
            END;
        ELSE IF EXISTS ( SELECT TOP ( 1 ) *
                         FROM   Ac_TransactionDetail
                         WHERE  FinancialAcID = @id )
                 BEGIN
                     SET @MSG = N'Transactions had been done. Cannot be deleted !!!';
                 END;
        ELSE IF EXISTS ( SELECT TOP ( 1 ) *
                         FROM   dbo.Ac_FinancialAc AS afa
                                INNER JOIN dbo.Ac_FinancialSys AS afs ON afs.FinancialSysID = afa.FinancialSysID
                         WHERE  afs.IsGroup = 1
                         AND    afa.FinancialAcID = @id )
                 BEGIN
                     SET @MSG = N'Group account. Cannot be deleted !!!';
                 END;
        ELSE
                 BEGIN
                     UPDATE Ac_FinancialAc
                     SET    IsArchived = 1 ,
                            ArchivedOn = GETDATE () ,
                            ArchivedBy = @username
                     WHERE  FinancialAcID = @id;
                     SET @MSG = N'Data Successfully deleted !!!';
                     COMMIT TRANSACTION;
                 END;
    END TRY
    BEGIN CATCH
        SET @MSG = N'Something went wrong in database !!! Please contact Support';
        ROLLBACK TRANSACTION;
    END CATCH;

    SELECT @MSG;



GO
