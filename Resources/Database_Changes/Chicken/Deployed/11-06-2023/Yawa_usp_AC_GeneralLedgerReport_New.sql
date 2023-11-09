SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: ADARSHA KARKI
	Last Modified Date: 09/28/2023
====================================

 EXEC dbo.usp_AC_GeneralLedgerReport_New @ACID = '20,30,40,10,19',
                                         @Start = '11/07/2023',
                                         @End = '11/07/2023'
*/
ALTER PROCEDURE [dbo].[usp_AC_GeneralLedgerReport_New]
    @ACID VARCHAR (MAX) ,
    @Start DATE ,
    @End DATE
AS
    BEGIN
        BEGIN TRY
		 
            SELECT value AS FinancialAcID
            INTO   #TempACID
            FROM   STRING_SPLIT(ISNULL (@ACID, ''), ',');
            INSERT INTO #TempACID ( FinancialAcID )
                        SELECT A.FinancialAcID
                        FROM   dbo.Ac_FinancialAc AS A
                               INNER JOIN #TempACID t ON t.FinancialAcID = A.PFinancialAcID;

            CREATE TABLE #AccountLedger
            (   ID INT IDENTITY (1, 1) ,
                TransactionID INT NULL ,
                PFinancialAcID INT NULL ,
                FinancialAcID INT NULL ,
                [Date] DATE NULL ,
                ParentAccount VARCHAR (200) NULL ,
                AccountHead VARCHAR (200) NULL ,
                Particulars VARCHAR (200) NULL ,
                Debit DECIMAL (18, 2) NULL ,
                Credit DECIMAL (18, 2) NULL ,
                Balance DECIMAL (18, 2) NULL ,
                [Descriptions] VARCHAR (200) NULL );

            INSERT #AccountLedger ( TransactionID ,
                                    PFinancialAcID ,
                                    FinancialAcID ,
                                    ParentAccount ,
                                    [Date] ,
                                    AccountHead ,
                                    Particulars ,
                                    Debit ,
                                    Credit ,
                                    Balance ,
                                    [Descriptions] )
                   SELECT   TD.TransactionID ,
                            FA.PFinancialAcID ,
                            TD.FinancialAcID ,
                            afa.Name ,
                            T.TransactionDate ,
                            CONCAT (FA.Name, ' #: ', T.VoucherNo) ,
                            TD.Particulars ,
                            TD.Debit ,
                            TD.Credit ,
                            0 AS Balance ,
                            T.Descriptions
                   FROM     dbo.Ac_Transaction T
                            INNER JOIN dbo.Ac_TransactionDetail TD ON T.TransactionID = TD.TransactionID
                            INNER JOIN dbo.Ac_FinancialAc FA ON FA.FinancialAcID = TD.FinancialAcID
                            LEFT JOIN dbo.Ac_FinancialAc AS afa ON afa.FinancialAcID = FA.PFinancialAcID
                   WHERE    (( ISNULL (@ACID, '') <> ''
                           AND EXISTS ( SELECT 1
                                        FROM   #TempACID
                                        WHERE  FinancialAcID = FA.FinancialAcID )
                            OR ISNULL (@ACID, '') = '' ))
                   AND      T.TransactionDate BETWEEN @Start AND @End
                   ORDER BY afa.Name ,
                            T.TransactionDate;



            INSERT INTO #AccountLedger ( TransactionID ,
                                         PFinancialAcID ,
                                         FinancialAcID ,
                                         [Date] ,
                                         ParentAccount ,
                                         AccountHead ,
                                         Particulars ,
                                         Debit ,
                                         Credit ,
                                         Balance ,
                                         [Descriptions] )
                        SELECT   0 ,
                                 0 ,
                                 A.PFinancialAcID ,
                                 @Start ,
                                 A.ParentAccount ,
                                 'Opening Balance' ,
                                 '' ,
                                 ISNULL (SUM (TD.Debit), 0) ,
                                 ISNULL (SUM (TD.Credit), 0) ,
                                 ISNULL (SUM (TD.Debit) - SUM (TD.Credit), 0) ,
                                 ''
                        FROM     ( SELECT DISTINCT PFinancialAcID ,
                                                   ParentAccount
                                   FROM   #AccountLedger ) AS A
                                 INNER JOIN dbo.Ac_FinancialAc FA ON FA.PFinancialAcID = A.PFinancialAcID
                                 LEFT JOIN dbo.Ac_TransactionDetail TD ON TD.FinancialAcID = FA.FinancialAcID
                                 INNER JOIN dbo.Ac_Transaction T ON T.TransactionID = TD.TransactionID
                        WHERE    T.TransactionDate < @Start
                        GROUP BY A.PFinancialAcID ,
                                 A.ParentAccount;


            SELECT TransactionID ,
                   FinancialAcID ,
                   ParentAccount ,
                   [Date] ,
                   AccountHead ,
                   Particulars ,
                   Debit ,
                   Credit ,
                   Balance ,
                   Descriptions
            FROM   #AccountLedger;

            DROP TABLE IF EXISTS #AccountLedger;
            DROP TABLE IF EXISTS #TempACID;
        END TRY
        BEGIN CATCH
            THROW;
        END CATCH;
    END;
GO

