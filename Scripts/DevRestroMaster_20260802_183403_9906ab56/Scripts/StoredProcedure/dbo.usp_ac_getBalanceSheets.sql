SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 10/11/2023
====================================

Balance Sheet Test

EXEC dbo.usp_ac_getBalanceSheets '2018-10-14','2024-02-22'

*/
CREATE PROCEDURE [dbo].[usp_ac_getBalanceSheets]
    @StartDate DATETIME ,
    @EndDate DATETIME
AS
    DECLARE @StockBalance DECIMAL (18, 2);

    IF OBJECT_ID ('tempdb.dbo.#Temp_AccountHead_Balance', 'U') IS NOT NULL
        DROP TABLE #Temp_AccountHead_Balance;

    IF OBJECT_ID ('tempdb.dbo.#Temp_TrialBalance', 'U') IS NOT NULL
        DROP TABLE #Temp_TrialBalance;


    IF OBJECT_ID ('tempdb.dbo.#TmpBalanceSheetHead', 'U') IS NOT NULL
        DROP TABLE #TmpBalanceSheetHead;

    IF OBJECT_ID ('tempdb.dbo.#TmpBalanceSheet', 'U') IS NOT NULL
        DROP TABLE #TmpBalanceSheet;


    IF OBJECT_ID ('tempdb.dbo.#TempIngrediants', 'U') IS NOT NULL
        DROP TABLE #TempIngrediants;

    --Calculating Stock Balance Bishal Raj Parajuli

    SELECT SRV.StockTranMasterId
    INTO   #Temp1
    FROM   [dbo].[vw_ROI_StockReportView] SRV
           INNER JOIN ( SELECT   MAX (TransactionDate) AS TransactionDate ,
                                 ITId ,
                                 StoreId
                        FROM     [dbo].[vw_ROI_StockReportView] sv
                        WHERE    sv.TransactionDate BETWEEN @StartDate AND DATEADD (DAY, 1, @EndDate)
                        GROUP BY ITId ,
                                 StoreId ) SV ON  SRV.ITId = SV.ITId
                                              AND SRV.TransactionDate = SV.TransactionDate;
    WITH CTE
    AS ( SELECT   ITId ,
                  ITCode AS ITName ,
                  SUM (ItemBalance) AS CLBal ,
                  Symbol ,
                  SUM (ItemValue) AS TotalValue
         FROM     [dbo].[vw_ROI_StockReportView]
         WHERE    StockTranMasterId IN ( SELECT t.StockTranMasterId
                                         FROM   #Temp1 t )
         GROUP BY ITId ,
                  ITCode ,
                  Symbol ,
                  ItemValue )
    SELECT   ITId ,
             ITName ,
             SUM (CLBal) AS CLBal ,
             Symbol ,
             SUM (TotalValue) AS TotalValue
    INTO     #Temp2
    FROM     CTE
    GROUP BY ITId ,
             ITName ,
             Symbol
    ORDER BY ITName;

    SET @StockBalance = ISNULL (( SELECT SUM (TotalValue)
                                  FROM   #Temp2 ) ,
                                0);

    --Profit & Loss

    --Checking if Temp Table Exist
    BEGIN
        IF OBJECT_ID ('tempdb.dbo.#Temp_AccountHead_Balance', 'U') IS NOT NULL
            DROP TABLE #PLTemp_AccountHead_Balance;
    END;
    BEGIN
        IF OBJECT_ID ('tempdb.dbo.#Temp_TrialBalance', 'U') IS NOT NULL
            DROP TABLE #PLTemp_TrialBalance;
    END;
    WITH Hierarchy ( [FinancialAcID], [FinancialSysID], [Name], [PFinancialAcID], [Parents], [level] ,
                     GroupFinancialAcID , IsDebit )
    AS ( SELECT [FinancialAcID] ,
                [FinancialSysID] ,
                [Name] ,
                [PFinancialAcID] ,
                CAST ([FinancialAcID] AS VARCHAR (MAX)) ,
                0 AS Level ,
                [FinancialAcID] AS GroupFinancialAcID ,
                IsDebit
         FROM   [dbo].[Ac_FinancialAc] AS FirtGeneration
         WHERE  ISNULL (PFinancialAcID, 0) = 0
         AND    IsArchived = 0
         AND    AccEntryType = 2
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
                END ,
                NextGeneration.IsDebit
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
             SUM (Credit) Credit ,
             a.IsDebit
    INTO     #PLTemp_AccountHead_Balance
    FROM     Hierarchy a
             LEFT JOIN dbo.Ac_TransactionDetail td ON a.FinancialAcID = td.FinancialAcID
             INNER JOIN dbo.Ac_Transaction TM ON TM.TransactionID = td.TransactionID
    WHERE    TM.TransactionDate IS NOT NULL
    AND      @StartDate IS NOT NULL
    AND      @EndDate IS NOT NULL
    AND      CAST (TM.TransactionDate AS DATE) BETWEEN @StartDate AND @EndDate
    GROUP BY a.[FinancialAcID] ,
             [a].[FinancialSysID] ,
             [a].[Name] ,
             [a].[PFinancialAcID] ,
             [a].[Parents] ,
             [a].[level] ,
             a.GroupFinancialAcID ,
             a.IsDebit;

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
           ISNULL (b.[level], 0) AS [LEVEL] ,
           b.Credit ,
           b.Debit ,
           a.IsDebit
    INTO   #PLTemp_TrialBalance
    FROM   dbo.Ac_FinancialAc a
           INNER JOIN dbo.Ac_FinancialSys AS fs ON a.FinancialSysID = fs.FinancialSysID
           LEFT JOIN ( SELECT   GroupFinancialAcID ,
                                [level] ,
                                SUM (Debit) Debit ,
                                SUM (Credit) Credit
                       FROM     #PLTemp_AccountHead_Balance
                       GROUP BY GroupFinancialAcID ,
                                [level] ,
                                IsDebit ) b ON a.FinancialAcID = b.GroupFinancialAcID
    WHERE  ISNULL (a.IsArchived, 0) = 0
    AND    ( a.FinancialAcID = 3
          OR a.FinancialAcID = 4
          OR a.PFinancialAcID > 0 );

    WITH cte ( FinancialAcID, Name, PFinancialAcID, Items, IsGroup, GroupFinancialAcID, [LEVEL], Credit, Debit ,
               AcOrder , IsDebit )
    AS ( SELECT FinancialAcID ,
                Name ,
                PFinancialAcID ,
                Items ,
                IsGroup ,
                GroupFinancialAcID ,
                [LEVEL] ,
                Credit ,
                Debit ,
                ROW_NUMBER () OVER ( ORDER BY Name ) * 1000 AS AcOrder ,
                IsDebit
         FROM   #PLTemp_TrialBalance
         WHERE  PFinancialAcID = 0
         UNION ALL
         SELECT tb.FinancialAcID ,
                tb.Name ,
                tb.PFinancialAcID ,
                tb.Items ,
                tb.IsGroup ,
                tb.GroupFinancialAcID ,
                tb.[LEVEL] ,
                tb.Credit ,
                tb.Debit ,
                p.AcOrder + ROW_NUMBER () OVER ( ORDER BY tb.Name ) * 100 AS AcOrder ,
                tb.IsDebit
         FROM   #PLTemp_TrialBalance tb
                INNER JOIN cte p ON tb.PFinancialAcID = p.FinancialAcID
         WHERE  tb.PFinancialAcID <= 4
         UNION ALL
         SELECT tb.FinancialAcID ,
                tb.Name ,
                tb.PFinancialAcID ,
                tb.Items ,
                tb.IsGroup ,
                tb.GroupFinancialAcID ,
                tb.[LEVEL] ,
                tb.Credit ,
                tb.Debit ,
                p.AcOrder + ROW_NUMBER () OVER ( ORDER BY tb.Name ) * 10 AS AcOrder ,
                tb.IsDebit
         FROM   #PLTemp_TrialBalance tb
                INNER JOIN cte p ON tb.PFinancialAcID = p.FinancialAcID
         WHERE  tb.PFinancialAcID >= 5 )
    SELECT   FinancialAcID ,
             Name ,
             PFinancialAcID ,
             Items ,
             IsGroup ,
             GroupFinancialAcID ,
             [LEVEL] ,
             ISNULL (Credit, 0) AS Credit ,
             ISNULL (Debit, 0) AS Debit ,
             IsDebit
    INTO     #Temp_ProfitLoss
    FROM     cte
    ORDER BY AcOrder;


    WITH Hierarchy ( [FinancialAcID], [FinancialSysID], [Name], [PFinancialAcID], [Parents], [level] ,
                     GroupFinancialAcID , IsDebit )
    AS ( SELECT [FinancialAcID] ,
                [FinancialSysID] ,
                [Name] ,
                [PFinancialAcID] ,
                CAST ([FinancialAcID] AS VARCHAR (MAX)) ,
                0 AS Level ,
                [FinancialAcID] AS GroupFinancialAcID ,
                IsDebit
         FROM   [dbo].[Ac_FinancialAc] AS FirtGeneration
         WHERE  ISNULL (PFinancialAcID, 0) = 0
         AND    IsArchived = 0
         AND    ( FinancialAcID = 1
               OR FinancialAcID = 2 )
         UNION ALL
         SELECT NextGeneration.FinancialAcID ,
                NextGeneration.[FinancialSysID] ,
                NextGeneration.[Name] ,
                Parent.FinancialAcID ,
                CAST (CASE WHEN Parent.Parents = '' THEN ( CAST (NextGeneration.FinancialAcID AS VARCHAR (MAX)))
                           ELSE ( Parent.Parents + '.' + CAST (NextGeneration.PFinancialAcID AS VARCHAR (MAX)))
                      END AS VARCHAR (MAX)) ,
                [Parent].[level] + 1 ,
                CASE WHEN ( ISNULL (NextGeneration.IsShownInBalanceSheet, 0) = 1 ) THEN NextGeneration.FinancialAcID
                     ELSE Parent.GroupFinancialAcID
                END ,
                NextGeneration.IsDebit
         FROM   dbo.Ac_FinancialAc AS NextGeneration
                INNER JOIN Hierarchy AS Parent ON  NextGeneration.PFinancialAcID = Parent.FinancialAcID
                                               AND NextGeneration.IsArchived = 0 )


    SELECT   a.[FinancialAcID] ,
             [a].[FinancialSysID] ,
             [a].[Name] ,
             [a].[PFinancialAcID] ,
             [a].[Parents] ,
             [a].[level] ,
             [a].GroupFinancialAcID ,
             a.IsDebit
    INTO     #Temp_AccountHead_Balance
    FROM     Hierarchy a
             LEFT JOIN dbo.Ac_TransactionDetail td ON a.FinancialAcID = td.FinancialAcID
             LEFT JOIN dbo.Ac_Transaction TM ON  TM.TransactionID = td.TransactionID
                                           AND TM.TransactionDate BETWEEN @StartDate AND @EndDate
    GROUP BY a.[FinancialAcID] ,
             [a].[FinancialSysID] ,
             [a].[Name] ,
             [a].[PFinancialAcID] ,
             [a].[Parents] ,
             [a].[level] ,
             [a].GroupFinancialAcID ,
             a.IsDebit;

	-----------------kishor changes---------------------------------------------------
	     SELECT a.TransactionID INTO  #tempTransactionIds FROM Ac_Transaction a
		 where a.TransactionID in (select TransactionID from Ac_TransactionDetail);
   --------------------------------------------------------------------------------
		
		SELECT  
		     AH.FinancialAcID ,
             AH.[FinancialSysID] ,
             AH.[Name] ,
             AH.[PFinancialAcID] ,
            AH.[Parents] ,
             AH.[level] ,
             AH.GroupFinancialAcID ,
             ISNULL (SUM (ISNULL (td.Debit, 0.00)), 0) Debit ,
             ISNULL (SUM (ISNULL (td.Credit, 0.00)), 0) Credit ,
            AH.IsDebit
    INTO     #New_Temp_AccountHead_Balance
    FROM     #Temp_AccountHead_Balance AH
	         INNER JOIN dbo.Ac_TransactionDetail td ON AH.FinancialAcID = td.FinancialAcID
			 INNER JOIN #tempTransactionIds TDs ON  TDs.TransactionID = td.TransactionID

    GROUP BY AH.[FinancialAcID] ,
             AH.[FinancialSysID] ,
             AH.[Name] ,
             AH.[PFinancialAcID] ,
             AH.[Parents] ,
             AH.[level] ,
             AH.GroupFinancialAcID ,
             AH.IsDebit;

    SELECT   ahb.GroupFinancialAcID ,
             ISNULL (SUM (ISNULL (Debit, 0.00)), 0) Debit ,
             ISNULL (SUM (ISNULL (Credit, 0.00)), 0) Credit
    INTO     #TmpBalanceSheet
    FROM     #New_Temp_AccountHead_Balance ahb
             INNER JOIN dbo.Ac_FinancialSys fs ON fs.FinancialSysID = ahb.FinancialSysID
    GROUP BY ahb.GroupFinancialAcID;
 

    SELECT ahb.FinancialAcID ,
           ahb.Name ,
           ahb.PFinancialAcID ,
           CASE WHEN ISNULL ([ahb].[level], 0) = 0
                AND  ahb.PFinancialAcID = 0 THEN ahb.Name
                WHEN ISNULL ([ahb].[level], 0) = 0
                AND  ahb.PFinancialAcID > 0 THEN REPLICATE ('-- ', 1) + ' ' + ahb.Name
                ELSE REPLICATE ('-- ', [ahb].[level]) + ' ' + ahb.Name
           END [Items] ,
           fs.IsGroup ,
           ahb.GroupFinancialAcID ,
           ISNULL ([ahb].[level], 0) AS [LEVEL] ,
           [ahb].[Parents] ,
           ahb.IsDebit
    INTO   #TmpBalanceSheetHead
    FROM   #Temp_AccountHead_Balance ahb
           INNER JOIN dbo.Ac_FinancialAc a ON  ahb.FinancialAcID = a.FinancialAcID
                                           AND a.IsShownInBalanceSheet = 1
           INNER JOIN dbo.Ac_FinancialSys fs ON fs.FinancialSysID = ahb.FinancialSysID;
		    

    SELECT   bsh.FinancialAcID ,
             bsh.Name ,
             bsh.PFinancialAcID ,
             bsh.Items ,
             bsh.IsGroup ,
             bsh.GroupFinancialAcID ,
             bsh.LEVEL ,
             bsh.Parents ,
             CASE WHEN bsh.FinancialAcID = 37 THEN @StockBalance
                  ELSE ISNULL (Debit, 0)
             END AS Debit ,
             ISNULL (Credit, 0) Credit ,
             bsh.IsDebit ,
             ( SELECT SUM (t.Credit) - SUM (t.Debit)
               FROM   #Temp_ProfitLoss t ) PLBalance
    INTO     #tempResult
    FROM     #TmpBalanceSheetHead bsh
             LEFT JOIN #TmpBalanceSheet bs ON bs.GroupFinancialAcID = bsh.GroupFinancialAcID
    ORDER BY bsh.[Parents];

    -- account details
    DECLARE @startDateFy DATE;
    SELECT @startDateFy = CAST (StartDate AS DATE)
    FROM   dbo.RO_fiscalYear
    WHERE  @EndDate BETWEEN StartDate AND EndDate;

	 

    SELECT   Fa.FinancialAcID ,
             Fa.Name AS FinancialAcName ,
             Fa.PFinancialAcID ,
             CONCAT (REPLICATE ('-- ', t.LEVEL + 1), Fa.Name) AS Items ,
             Fs.IsGroup ,
             0 AS GroupFinancialAcID ,
             t.LEVEL + 1 AS [LEVEL] ,
             CONCAT (t.Parents, '.', Fa.PFinancialAcID) AS Parents ,
             SUM (ISNULL (AD.Debit, 0)) AS Debit ,
             SUM (ISNULL (AD.Credit, 0)) AS Credit ,
             ISNULL (Fa.IsDebit, t.IsDebit) AS IsDebit ,
             0 AS PLBalance
    INTO #tempAll
    FROM     dbo.Ac_FinancialAc Fa
             INNER JOIN dbo.Ac_FinancialSys Fs ON Fa.FinancialSysID = Fs.FinancialSysID
             INNER JOIN dbo.Ac_TransactionDetail AD ON Fa.FinancialAcID = AD.FinancialAcID
             INNER JOIN dbo.Ac_Transaction TM ON TM.TransactionID = AD.TransactionID
             INNER JOIN #tempResult t ON t.FinancialAcID = Fa.PFinancialAcID
    WHERE    CAST (TM.TransactionDate AS DATE) BETWEEN @startDateFy AND @EndDate
    AND      NOT EXISTS ( SELECT 1
                          FROM   #tempResult t
                          WHERE  t.FinancialAcID = Fa.FinancialAcID )
    GROUP BY Fa.FinancialAcID ,
             Fa.PFinancialAcID ,
             Fa.Name ,
             t.Parents ,
             t.LEVEL ,
             Fa.IsDebit ,
             t.IsDebit ,
             Fs.IsGroup
    UNION
    SELECT FinancialAcID ,
           Name AS FinancialAcName ,
           PFinancialAcID ,
           Items ,
           IsGroup ,
           GroupFinancialAcID ,
           LEVEL ,
           Parents ,
           Debit ,
           Credit ,
           IsDebit ,
           PLBalance
    FROM   #tempResult;

    SELECT   t.FinancialAcID ,
             t.FinancialAcName ,
             t.PFinancialAcID ,
             t.Items ,
             t.IsGroup ,
             t.GroupFinancialAcID ,
             t.LEVEL ,
             t.Parents ,
             t.Debit ,
             t.Credit ,
             t.IsDebit ,
             t.PLBalance
    FROM     #tempAll t
    ORDER BY t.Parents ,
             t.LEVEL ,
             t.Items ,
             t.IsDebit;

    DROP TABLE IF EXISTS #tempAll;
    DROP TABLE IF EXISTS #tempResult;
    DROP TABLE IF EXISTS #Temp1;
    DROP TABLE IF EXISTS #Temp2;
    DROP TABLE #Temp_ProfitLoss;

GO
