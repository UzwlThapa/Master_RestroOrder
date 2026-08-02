SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawa
	Last Modified Date: 11/21/2023
====================================

 EXEC dbo.usp_AC_GeneralLedgerReport_New @ACID = '3684',
                                         @Start = '01/01/2023',
                                         @End = '01/01/2024',
										 @IsGroup = 0


*/
CREATE PROCEDURE [dbo].[usp_AC_GeneralLedgerReport_New]
    @ACID VARCHAR (MAX) ,
    @Start DATE ,
    @End DATE ,
    @IsGroup BIT
AS
    BEGIN
        BEGIN TRY
		 
            CREATE TABLE #TempACID
            ( FinancialAcID INT NOT NULL );

            CREATE TABLE #tempParent
            ( [FinancialAcID] INT NOT NULL );


            CREATE TABLE #tempParent2
            ( [FinancialAcID] INT NOT NULL );


            DECLARE @TransactionNodeId INT;
            SELECT @TransactionNodeId = s.FinancialSysID
            FROM   dbo.Ac_FinancialSys s
            WHERE  s.Name = 'Transaction Node';

            DECLARE @BankAccount INT;
            SELECT @BankAccount = s.FinancialSysID
            FROM   dbo.Ac_FinancialSys s
            WHERE  s.Name = 'Bank Account';

            IF ( ISNULL (@ACID, '') = '' )
                BEGIN
                    INSERT INTO #TempACID ( FinancialAcID )
                                SELECT A.FinancialAcID
                                FROM   dbo.Ac_FinancialAc AS A
                                       INNER JOIN Ac_FinancialSys s ON s.FinancialSysID = A.FinancialSysID
                                WHERE  s.IsGroup = 0;
                END;
            BEGIN

                -- insert all child
                INSERT INTO #TempACID ( FinancialAcID )
                            SELECT A.FinancialAcID
                            FROM   dbo.Ac_FinancialAc AS A
                                   INNER JOIN STRING_SPLIT(ISNULL (@ACID, ''), ',') t ON t.value = A.FinancialAcID
                                   INNER JOIN Ac_FinancialSys s ON s.FinancialSysID = A.FinancialSysID;
                --WHERE  s.IsGroup = 1;

                -- insert child if id is parent 
                INSERT INTO #tempParent
                            SELECT A.FinancialAcID
                            FROM   dbo.Ac_FinancialAc AS A
                                   INNER JOIN STRING_SPLIT(ISNULL (@ACID, ''), ',') t ON t.value = A.FinancialAcID
                                   INNER JOIN Ac_FinancialSys s ON s.FinancialSysID = A.FinancialSysID
                            WHERE  s.IsGroup = 1;

                DECLARE @CurrentFinancialAcId INT;
                DECLARE @CurrentFinancialAcId2 INT;

                WHILE EXISTS ( SELECT TOP ( 1 ) 1
                               FROM   #tempParent )
                    BEGIN
                        SELECT TOP ( 1 ) @CurrentFinancialAcId = FinancialAcID
                        FROM   #tempParent;

                        -- insert all child
                        INSERT INTO #TempACID ( FinancialAcID )
                                    SELECT A.FinancialAcID
                                    FROM   dbo.Ac_FinancialAc AS A
                                           INNER JOIN Ac_FinancialSys s ON s.FinancialSysID = A.FinancialSysID
                                    WHERE  s.IsGroup = 0
                                    AND    A.PFinancialAcID = @CurrentFinancialAcId;

                        -- insert if child has grand child
                        INSERT INTO #tempParent2 ( FinancialAcID )
                                    SELECT A.FinancialAcID
                                    FROM   dbo.Ac_FinancialAc AS A
                                           INNER JOIN Ac_FinancialSys s ON s.FinancialSysID = A.FinancialSysID
                                    WHERE  s.IsGroup = 1
                                    AND    A.PFinancialAcID = @CurrentFinancialAcId;


                        WHILE EXISTS ( SELECT TOP ( 1 ) 1
                                       FROM   #tempParent2 )
                            BEGIN
                                SELECT TOP ( 1 ) @CurrentFinancialAcId2 = FinancialAcID
                                FROM   #tempParent2;

                                -- insert all child
                                INSERT INTO #TempACID ( FinancialAcID )
                                            SELECT A.FinancialAcID
                                            FROM   dbo.Ac_FinancialAc AS A
                                                   INNER JOIN Ac_FinancialSys s ON s.FinancialSysID = A.FinancialSysID
                                            WHERE  s.IsGroup = 0
                                            AND    A.PFinancialAcID = @CurrentFinancialAcId2;

                                DELETE t
                                FROM   #tempParent2 t
                                WHERE  FinancialAcID = @CurrentFinancialAcId2;
                            END;

                        DELETE t
                        FROM   #tempParent t
                        WHERE  FinancialAcID = @CurrentFinancialAcId;
                    END;

            END;


            CREATE TABLE #AccountLedger
            (   Id INT IDENTITY (1, 1) ,
                TransactionID INT NULL ,
                PFinancialAcID INT NULL ,
                FinancialAcID INT NULL ,
                [Date] DATE NULL ,
                ParentAccount VARCHAR (200) NULL ,
                OpeningBalance VARCHAR (200) NULL ,
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
                            INNER JOIN dbo.Ac_TransactionDetail TD ON T.TransactionID = TD.TransactionID --  select * from Ac_Transaction;
                            INNER JOIN dbo.Ac_FinancialAc FA ON FA.FinancialAcID = TD.FinancialAcID --   select * from Ac_TransactionDetail where FinancialAcID = 3684;
                            LEFT JOIN dbo.Ac_FinancialAc AS afa ON afa.FinancialAcID = FA.PFinancialAcID --  select * from Ac_FinancialAc where PFinancialAcID = 1;
                            INNER JOIN #TempACID tt ON tt.FinancialAcID = FA.FinancialAcID
                   WHERE    T.TransactionDate BETWEEN @Start AND @End
                   --AND      T.Descriptions <> 'Opening Balance'
                   --AND      T.VoucherNo <> 'Opening'
                   ORDER BY afa.Name ,
                            T.TransactionDate;

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
                                SELECT   DISTINCT 0 ,
                                                  afa2.PFinancialAcID ,
                                                  afa2.FinancialAcID ,
                                                  @Start ,
                                                  afa2.Name ,
                                                  'Opening Balance' ,
                                                  '' ,
                                                  ISNULL (SUM (TD.Debit), 0) ,
                                                  ISNULL (SUM (TD.Credit), 0) ,
                                                  ISNULL (SUM (TD.Debit) - SUM (TD.Credit), 0) ,
                                                  ''
                                FROM     dbo.Ac_Transaction T
                                         INNER JOIN dbo.Ac_TransactionDetail TD ON T.TransactionID = TD.TransactionID
                                         INNER JOIN dbo.Ac_FinancialAc FA ON FA.FinancialAcID = TD.FinancialAcID
                                         INNER JOIN dbo.Ac_FinancialAc AS afa2 ON afa2.FinancialAcID = FA.PFinancialAcID
                                         INNER JOIN #TempACID tt ON tt.FinancialAcID = FA.FinancialAcID
                                WHERE    T.TransactionDate < @Start
                                GROUP BY afa2.PFinancialAcID ,
                                         afa2.FinancialAcID ,
                                         afa2.Name;


                    INSERT #tempParent ( FinancialAcID )
                           SELECT afa.FinancialAcID
                           FROM   #AccountLedger AS al
                                  INNER JOIN dbo.Ac_FinancialAc AS afa ON afa.FinancialAcID = al.FinancialAcID
                           WHERE  afa.FinancialSysID NOT IN ( @TransactionNodeId, @BankAccount );


                    -- insert row for displaying opening balance when no transaction on selected date range, or num of tran is equal to total selected facc count
                    IF NOT EXISTS ( SELECT TOP ( 1 ) 1
                                    FROM   #AccountLedger a
                                           INNER JOIN #tempParent AS al ON al.FinancialAcID = a.FinancialAcID )
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
                                        SELECT DISTINCT 0 ,
                                                        afa.PFinancialAcID ,
                                                        0 ,
                                                        @Start ,
                                                        afa2.Name ,
                                                        'Opening Balance' ,
                                                        '' ,
                                                        0 ,
                                                        0 ,
                                                        0 ,
                                                        ''
                                        FROM   #TempACID AS ta
                                               INNER JOIN dbo.Ac_FinancialAc AS afa ON afa.FinancialAcID = ta.FinancialAcID
                                               INNER JOIN dbo.Ac_FinancialAc AS afa2 ON afa2.FinancialAcID = afa.PFinancialAcID;

                        END;


                END;
            ELSE
                BEGIN

                    INSERT INTO #AccountLedger ( TransactionID ,
                                                 PFinancialAcID ,
                                                 FinancialAcID ,
                                                 [Date] ,
                                                 OpeningBalance ,
                                                 AccountHead ,
                                                 Particulars ,
                                                 Debit ,
                                                 Credit ,
                                                 Balance ,
                                                 [Descriptions] )
                                SELECT   0 ,
                                         afa2.FinancialAcID ,
                                         FA.FinancialAcID ,
                                         @Start ,
                                         'Opening Balance' ,
                                         CONCAT (FA.Name, ' # ') ,
                                         '' ,
                                         ISNULL (SUM (TD.Debit), 0) ,
                                         ISNULL (SUM (TD.Credit), 0) ,
                                         ISNULL (SUM (TD.Debit) - SUM (TD.Credit), 0) ,
                                         ''
                                FROM     dbo.Ac_Transaction T
                                         INNER JOIN dbo.Ac_TransactionDetail TD ON T.TransactionID = TD.TransactionID
                                         INNER JOIN dbo.Ac_FinancialAc FA ON FA.FinancialAcID = TD.FinancialAcID -- select * from Ac_FinancialAc
                                         INNER JOIN dbo.Ac_FinancialAc AS afa2 ON afa2.FinancialAcID = FA.PFinancialAcID
                                         INNER JOIN #TempACID tt ON tt.FinancialAcID = FA.FinancialAcID
                                WHERE    T.TransactionDate < @Start
                                GROUP BY afa2.FinancialAcID ,
                                         FA.FinancialAcID ,
                                         FA.Name;

                    -- insert row for displaying opening balance when no transaction on selected date range, or num of tran is equal to total selected facc count
                    INSERT INTO #AccountLedger ( TransactionID ,
                                                 PFinancialAcID ,
                                                 FinancialAcID ,
                                                 [Date] ,
                                                 OpeningBalance ,
                                                 ParentAccount ,
                                                 AccountHead ,
                                                 Particulars ,
                                                 Debit ,
                                                 Credit ,
                                                 Balance ,
                                                 [Descriptions] )
                                SELECT 0 ,
                                       afa.PFinancialAcID ,
                                       ta.FinancialAcID ,
                                       @Start ,
                                       'Opening Balance' ,
                                       afa2.Name ,
                                       afa.Name ,
                                       '' ,
                                       0 ,
                                       0 ,
                                       0 ,
                                       ''
                                FROM   #TempACID AS ta
                                       INNER JOIN dbo.Ac_FinancialAc AS afa ON afa.FinancialAcID = ta.FinancialAcID
                                       INNER JOIN dbo.Ac_FinancialAc AS afa2 ON afa2.FinancialAcID = afa.PFinancialAcID
                                WHERE  NOT EXISTS ( SELECT TOP ( 1 ) 1
                                                    FROM   #AccountLedger a
                                                    WHERE  a.FinancialAcID = afa.FinancialAcID
                                                    AND    a.AccountHead = 'Opening Balance' );

                END;




            SELECT TransactionID ,
                   PFinancialAcID ,
                   FinancialAcID ,
                   Date ,
                   ParentAccount ,
                   OpeningBalance ,
                   AccountHead ,
                   Particulars ,
                   Debit ,
                   Credit ,
                   Balance ,
                   Descriptions
            FROM   #AccountLedger;

            DROP TABLE IF EXISTS #AccountLedger;
            DROP TABLE IF EXISTS #TempACID;
            DROP TABLE IF EXISTS #tempParent;
            DROP TABLE IF EXISTS #tempParent2;


        END TRY
        BEGIN CATCH
            THROW;
        END CATCH;
    END;

GO
