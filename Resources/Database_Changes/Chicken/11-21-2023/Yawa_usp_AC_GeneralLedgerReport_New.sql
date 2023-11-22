SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawa
	Last Modified Date: 11/21/2023
====================================

 EXEC dbo.usp_AC_GeneralLedgerReport_New @ACID = '20,30,40,10,19',
                                         @Start = '11/07/2023',
                                         @End = '11/07/2023',
										 @IsGroup = 1
*/
ALTER PROCEDURE [dbo].usp_AC_GeneralLedgerReport_New
    @ACID VARCHAR (MAX) ,
    @Start DATE ,
    @End DATE ,
    @IsGroup BIT
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

            SELECT *
            FROM   #TempACID;
            CREATE TABLE #AccountLedger
            (   Id INT IDENTITY (1, 1) ,
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
 

            -- opening balance
            IF ( @IsGroup = 1 )
                BEGIN
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
                END;
            ELSE
                BEGIN
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
                                         ta.FinancialAcID ,
                                         @Start ,
                                         FA.Name ,
                                         'Opening Balance' ,
                                         '' ,
                                         ISNULL (SUM (TD.Debit), 0) ,
                                         ISNULL (SUM (TD.Credit), 0) ,
                                         ISNULL (SUM (TD.Debit) - SUM (TD.Credit), 0) ,
                                         ''
                                FROM     #TempACID AS ta
                                         LEFT JOIN dbo.Ac_TransactionDetail TD ON TD.FinancialAcID = ta.FinancialAcID
                                         INNER JOIN dbo.Ac_FinancialAc FA ON FA.FinancialAcID = TD.FinancialAcID
                                         INNER JOIN dbo.Ac_Transaction T ON T.TransactionID = TD.TransactionID
                                WHERE    EXISTS ( SELECT 1
                                                  FROM   #TempACID AS ta2
                                                  WHERE  ta2.FinancialAcID = ta.FinancialAcID )
                                AND      T.TransactionDate < @Start
                                GROUP BY ta.FinancialAcID ,
                                         FA.Name;
                END;


            -- balance calculation
            CREATE TABLE #tempParentAcc
            (   Id INT IDENTITY (1, 1) ,
                [PFinancialAcID] INT NOT NULL );

            CREATE TABLE #tempFaTransaction
            (   Id INT IDENTITY (1, 1) ,
                [FinancialAcID] INT NOT NULL ,
                [Debit] DECIMAL (18, 2) NOT NULL ,
                [Credit] DECIMAL (18, 2) NOT NULL );

            DECLARE @PID INT ,
                    @PMaxID INT ,
                    @PFinancialAcID INT ,
                    @ID INT ,
                    @Debit DECIMAL (18, 2) ,
                    @Credit DECIMAL (18, 2) ,
                    @Balance DECIMAL (18, 2);


            IF ( @IsGroup = 1 )
                BEGIN
                    INSERT INTO #tempParentAcc ( PFinancialAcID )
                                SELECT DISTINCT PFinancialAcID
                                FROM   #AccountLedger
                                WHERE  PFinancialAcID <> 0;

                END;
            ELSE
                BEGIN
                    INSERT INTO #tempParentAcc ( PFinancialAcID )
                                SELECT DISTINCT FinancialAcID
                                FROM   #AccountLedger
                                WHERE  PFinancialAcID <> 0;

                END;

            SELECT   TOP ( 1 ) @PID = Id
            FROM     #tempParentAcc
            ORDER BY Id;

            SELECT @PMaxID = MAX (Id)
            FROM   #tempParentAcc;

            WHILE @PID > 0
            AND   @PID <= @PMaxID
                BEGIN
                    SELECT @PFinancialAcID = al.PFinancialAcID
                    FROM   #tempParentAcc AS al
                    WHERE  al.Id = @PID;

                    SELECT @Balance = al.Balance
                    FROM   #AccountLedger AS al
                    WHERE  al.FinancialAcID = @PFinancialAcID
                    AND    al.AccountHead = 'Opening Balance';

                    IF ( @IsGroup = 1 )
                        BEGIN
                            INSERT INTO #tempFaTransaction ( FinancialAcID ,
                                                             Debit ,
                                                             Credit )
                                        SELECT   FinancialAcID ,
                                                 Debit ,
                                                 Credit
                                        FROM     #AccountLedger
                                        WHERE    PFinancialAcID = @PFinancialAcID
                                        ORDER BY [Date] ,
                                                 TransactionID;
                        END;
                    ELSE
                        BEGIN
                            INSERT INTO #tempFaTransaction ( FinancialAcID ,
                                                             Debit ,
                                                             Credit )
                                        SELECT   FinancialAcID ,
                                                 Debit ,
                                                 Credit
                                        FROM     #AccountLedger
                                        WHERE    FinancialAcID = @PFinancialAcID
                                        AND      AccountHead <> 'Opening Balance'
                                        ORDER BY [Date] ,
                                                 TransactionID;
                        END;


                    WHILE EXISTS ( SELECT TOP ( 1 ) 1
                                   FROM   #tempFaTransaction )
                        BEGIN
                            SELECT   TOP ( 1 ) @ID = al.Id ,
                                               @Debit = al.Debit ,
                                               @Credit = al.Credit
                            FROM     #tempFaTransaction AS al
                            ORDER BY al.Id;

                            SELECT @Balance = ISNULL (@Balance, 0.00) + ISNULL (@Debit, 0.00) - ISNULL (@Credit, 0.00);

                            UPDATE #AccountLedger
                            SET    Balance = @Balance
                            WHERE  Id = @ID;

                            DELETE FROM #tempFaTransaction
                            WHERE Id = @ID;
                        END;

                    SELECT @PID = @PID + 1;
                END;


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
            DROP TABLE IF EXISTS #tempParentAcc;
            DROP TABLE IF EXISTS #tempFaTransaction;
        END TRY
        BEGIN CATCH
            THROW;
        END CATCH;
    END;
GO

