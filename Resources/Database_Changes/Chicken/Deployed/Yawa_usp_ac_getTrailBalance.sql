SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 10/11/2023
====================================

EXEC dbo.usp_ac_getTrailBalance '2018-10-14'

*/
ALTER PROCEDURE [dbo].[usp_ac_getTrailBalance]
    @Date DATETIME
AS
    BEGIN

        IF OBJECT_ID ('tempdb.dbo.#Temp_AccountHead_Balance', 'U') IS NOT NULL
            DROP TABLE #Temp_AccountHead_Balance;
    END;
    BEGIN
        IF OBJECT_ID ('tempdb.dbo.#Temp_TrialBalance', 'U') IS NOT NULL
            DROP TABLE #Temp_TrialBalance;
    END;
    WITH Hierarchy ( [FinancialAcID], [FinancialSysID], [Name], [PFinancialAcID], [Parents], [level] ,
                     GroupFinancialAcID )
    AS ( SELECT [FinancialAcID] ,
                [FinancialSysID] ,
                [Name] ,
                [PFinancialAcID] ,
                CAST ([FinancialAcID] AS VARCHAR (MAX)) ,
                0 AS Level ,
                [FinancialAcID] AS GroupFinancialAcID
         FROM   [dbo].[Ac_FinancialAc] AS FirtGeneration
         WHERE  ISNULL (PFinancialAcID, 0) = 0
         AND    IsArchived = 0
         UNION ALL
         SELECT NextGeneration.FinancialAcID ,
                NextGeneration.[FinancialSysID] ,
                NextGeneration.[Name] ,
                Parent.FinancialAcID ,
                CAST (CASE WHEN Parent.Parents = '' THEN ( CAST (NextGeneration.FinancialAcID AS VARCHAR (MAX)))
                           ELSE ( Parent.Parents + '.' + CAST (NextGeneration.PFinancialAcID AS VARCHAR (MAX)))
                      END AS VARCHAR (MAX)) ,
                [Parent].[level] + 1 ,
                CASE WHEN ( fs.IsGroup = 1
                         OR ISNULL (NextGeneration.IsShownInBalanceSheet, 0) = 1 ) THEN NextGeneration.FinancialAcID
                     ELSE Parent.GroupFinancialAcID
                END
         FROM   dbo.Ac_FinancialAc AS NextGeneration
                INNER JOIN dbo.Ac_FinancialSys AS fs ON NextGeneration.FinancialSysID = fs.FinancialSysID
                INNER JOIN Hierarchy AS Parent ON  NextGeneration.PFinancialAcID = Parent.FinancialAcID
                                               AND NextGeneration.IsArchived = 0 )
    SELECT   a.[FinancialAcID] ,
             [a].[FinancialSysID] ,
             [a].[Name] ,
             [a].[PFinancialAcID] ,
             [a].[Parents] ,
             [a].[level] ,
             a.GroupFinancialAcID ,
             SUM (Debit) Debit ,
             SUM (Credit) Credit
    INTO     #Temp_AccountHead_Balance
    FROM     Hierarchy a
             LEFT JOIN dbo.Ac_TransactionDetail td ON a.FinancialAcID = td.FinancialAcID
             INNER JOIN dbo.Ac_Transaction TM ON TM.TransactionID = td.TransactionID
    WHERE    TM.TransactionDate IS NOT NULL
    AND      @Date IS NOT NULL 
    AND      CAST (TM.TransactionDate AS DATE) BETWEEN ( SELECT   TOP ( 1 ) StartDate
                                                         FROM     dbo.RO_fiscalYear
                                                         WHERE    @Date BETWEEN StartDate AND EndDate
                                                         ORDER BY StartDate ) AND @Date
    GROUP BY a.[FinancialAcID] ,
             [a].[FinancialSysID] ,
             [a].[Name] ,
             [a].[PFinancialAcID] ,
             [a].[Parents] ,
             [a].[level] ,
             a.GroupFinancialAcID;

    SELECT a.FinancialAcID ,
           a.Name ,
           a.PFinancialAcID ,
           CASE WHEN ISNULL ([b].[level], 0) = 0
                AND  a.PFinancialAcID = 0 THEN a.Name
                WHEN ISNULL ([b].[level], 0) = 0
                AND  a.PFinancialAcID > 0 THEN REPLICATE ('- ', 1) + ' ' + a.Name
                ELSE REPLICATE ('- ', [b].[level]) + ' ' + a.Name
           END [Items] ,
           fs.IsGroup ,
           b.GroupFinancialAcID ,
           CAST (ISNULL(b.Parents,a.PFinancialAcID) AS VARCHAR (MAX)) AS Parents ,
           b.[level] AS [LEVEL] ,
           b.Credit ,
           b.Debit
    INTO   #Temp_TrialBalance
    FROM   dbo.Ac_FinancialAc a
           INNER JOIN dbo.Ac_FinancialSys AS fs ON a.FinancialSysID = fs.FinancialSysID
           LEFT JOIN ( SELECT   GroupFinancialAcID ,
                                CAST (Parents AS VARCHAR (MAX)) AS Parents ,
                                [level] ,
                                SUM (Debit) Debit ,
                                SUM (Credit) Credit
                       FROM     #Temp_AccountHead_Balance
                       GROUP BY GroupFinancialAcID ,
                                Parents ,
                                [level] ) b ON a.FinancialAcID = b.GroupFinancialAcID
    WHERE  ( fs.IsGroup = 1
          OR b.Debit IS NOT NULL )
    AND    ISNULL (a.IsArchived, 0) = 0;

    WITH cte ( FinancialAcID, Name, PFinancialAcID, Items, IsGroup, GroupFinancialAcID, Parents, [LEVEL], Credit ,
               Debit , AcOrder )
    AS ( SELECT FinancialAcID ,
                Name ,
                PFinancialAcID ,
                Items ,
                IsGroup ,
                GroupFinancialAcID ,
                CAST (t.Parents AS VARCHAR (MAX)) AS Parents ,
                [LEVEL] ,
                Credit ,
                Debit ,
                ROW_NUMBER () OVER ( ORDER BY Name ) * 1000 AS AcOrder
         FROM   #Temp_TrialBalance t
         WHERE  PFinancialAcID = 0
         UNION ALL
         SELECT tb.FinancialAcID ,
                tb.Name ,
                tb.PFinancialAcID ,
                tb.Items ,
                tb.IsGroup ,
                tb.GroupFinancialAcID ,
                CAST (tb.Parents AS VARCHAR (MAX)) AS Parents ,
                tb.[LEVEL] ,
                tb.Credit ,
                tb.Debit ,
                p.AcOrder + ROW_NUMBER () OVER ( ORDER BY tb.Name ) * 100 AS AcOrder
         FROM   #Temp_TrialBalance tb
                INNER JOIN cte p ON tb.PFinancialAcID = p.FinancialAcID
         WHERE  tb.PFinancialAcID <= 4
         UNION ALL
         SELECT tb.FinancialAcID ,
                tb.Name ,
                tb.PFinancialAcID ,
                tb.Items ,
                tb.IsGroup ,
                tb.GroupFinancialAcID ,
                CAST (tb.Parents AS VARCHAR (MAX)) AS Parents ,
                tb.[LEVEL] ,
                tb.Credit ,
                tb.Debit ,
                p.AcOrder + ROW_NUMBER () OVER ( ORDER BY tb.Name ) * 10 AS AcOrder
         FROM   #Temp_TrialBalance tb
                INNER JOIN cte p ON tb.PFinancialAcID = p.FinancialAcID
         WHERE  tb.PFinancialAcID >= 5 )
    SELECT   FinancialAcID ,
             Name ,
             PFinancialAcID ,
             Items ,
             IsGroup ,
             GroupFinancialAcID ,
             CAST (Parents AS VARCHAR (MAX)) AS Parents ,
             [LEVEL] ,
             ISNULL (Credit, 0) AS Credit ,
             ISNULL (Debit, 0) AS Debit
    INTO     #tempResult
    FROM     cte
    ORDER BY AcOrder;

    -- account details
    DECLARE @startDateFy DATE;
    SELECT @startDateFy = CAST (StartDate AS DATE)
    FROM   dbo.RO_fiscalYear
    WHERE  @Date BETWEEN StartDate AND EndDate;

    CREATE TABLE [#tempAll]
    (   [FinancialAcID] INT NOT NULL ,
        [FinancialAcName] NVARCHAR (256) ,
        [PFinancialAcID] INT ,
        [Items] VARCHAR (MAX) ,
        [IsGroup] BIT ,
        [GroupFinancialAcID] INT ,
        [Parents] VARCHAR (MAX) ,
        [LEVEL] INT ,
        [Debit] MONEY ,
        [Credit] MONEY );

    INSERT #tempAll ( FinancialAcID ,
                      FinancialAcName ,
                      PFinancialAcID ,
                      Items ,
                      IsGroup ,
                      GroupFinancialAcID ,
                      Parents ,
                      LEVEL ,
                      Debit ,
                      Credit )
           SELECT   Fa.FinancialAcID ,
                    Fa.Name ,
                    Fa.PFinancialAcID ,
                    CONCAT (REPLICATE ('-- ', t.LEVEL + 1), Fa.Name) ,
                    Fs.IsGroup ,
                    0 ,
                    CAST (ISNULL (t.Parents, '') AS VARCHAR (MAX)) ,
                    ISNULL (t.LEVEL, 0) + 1 ,
                    SUM (ISNULL (AD.Debit, 0)) ,
                    SUM (ISNULL (AD.Credit, 0))
           FROM     dbo.Ac_FinancialAc Fa
                    INNER JOIN dbo.Ac_FinancialSys Fs ON Fa.FinancialSysID = Fs.FinancialSysID
                    INNER JOIN dbo.Ac_TransactionDetail AD ON Fa.FinancialAcID = AD.FinancialAcID
                    INNER JOIN dbo.Ac_Transaction TM ON TM.TransactionID = AD.TransactionID
                    INNER JOIN #tempResult t ON t.FinancialAcID = Fa.PFinancialAcID
           WHERE    CAST (TM.TransactionDate AS DATE) BETWEEN @startDateFy AND @Date
           AND      NOT EXISTS ( SELECT 1
                                 FROM   #tempResult t
                                 WHERE  t.FinancialAcID = Fa.FinancialAcID )
           GROUP BY Fa.FinancialAcID ,
                    Fa.PFinancialAcID ,
                    Fa.Name ,
                    t.Parents ,
                    t.LEVEL ,
                    Fs.IsGroup
           UNION
           SELECT FinancialAcID ,
                  Name AS FinancialAcName ,
                  PFinancialAcID ,
                  Items ,
                  IsGroup ,
                  GroupFinancialAcID ,
                  CAST (Parents AS VARCHAR (MAX)) AS Parents ,
                  LEVEL ,
                  Debit ,
                  Credit
           FROM   #tempResult;


    SELECT   t.FinancialAcID ,
             t.FinancialAcName ,
             t.PFinancialAcID ,
             t.Items ,
             t.IsGroup ,
             t.GroupFinancialAcID ,
             t.Parents ,
             t.LEVEL ,
             t.Debit ,
             t.Credit
    FROM     #tempAll t
    ORDER BY t.Parents ,
             t.LEVEL ,
             t.Items;

    DROP TABLE IF EXISTS #tempAll;
    DROP TABLE IF EXISTS #tempResult;

GO