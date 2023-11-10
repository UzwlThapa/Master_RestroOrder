SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 11/10/2023
====================================

EXEC dbo.usp_ac_getProfitLoss '2023-10-16','2023-10-16'

*/
ALTER PROCEDURE [dbo].[usp_ac_getProfitLoss]
    @StartDate DATETIME ,
    @EndDate DATETIME
AS
    BEGIN;

        DECLARE @AccEntryTypeId INT;
        SELECT @AccEntryTypeId = Id
        FROM   dbo.Ac_EntryType
        WHERE  AccountEntryType = 'Profit & Loss A/C';

        DECLARE @SalesVoucherTypeId INT;
        SELECT @SalesVoucherTypeId = VoucherTypeID
        FROM   dbo.Ac_VoucherType t
        WHERE  t.VoucherName = 'Sales Voucher';

        DECLARE @StartDateTime DATETIME;
        DECLARE @EndDateTime DATETIME;
        SELECT @StartDateTime = DATEADD (HOUR, 4, @StartDate);
        SELECT @EndDateTime = DATEADD (MINUTE, -1, DATEADD (HOUR, 28, @EndDate));


        CREATE TABLE #AccountLedger
        (   PFinancialAcID INT NULL ,
            FinancialAcID INT NULL ,
            PFinancialAcName VARCHAR (200) NULL ,
            FinancialAcName VARCHAR (200) NULL ,
            Debit DECIMAL (18, 2) NULL ,
            Credit DECIMAL (18, 2) NULL ,
            IsDebit BIT
                DEFAULT ( 0 ) NULL );

        INSERT #AccountLedger ( PFinancialAcID ,
                                FinancialAcID ,
                                PFinancialAcName ,
                                FinancialAcName ,
                                Debit ,
                                Credit ,
                                IsDebit )
               SELECT   FA.PFinancialAcID ,
                        TD.FinancialAcID ,
                        afa.Name ,
                        FA.Name ,
                        SUM (TD.Debit) ,
                        SUM (TD.Credit) ,
                        FA.IsDebit
               FROM     dbo.Ac_Transaction T
                        INNER JOIN dbo.Ac_TransactionDetail TD ON T.TransactionID = TD.TransactionID
                        INNER JOIN dbo.Ac_FinancialAc FA ON FA.FinancialAcID = TD.FinancialAcID
                        LEFT JOIN dbo.Ac_FinancialAc AS afa ON afa.FinancialAcID = FA.PFinancialAcID
               WHERE    CAST(ISNULL (T.TransactionDate, T.PostedOn) AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
               AND      ISNULL (FA.AccEntryType, 0) = @AccEntryTypeId
               AND      T.Descriptions NOT LIKE 'Sales Bill No%'
               GROUP BY TD.FinancialAcID ,
                        FA.Name ,
                        FA.PFinancialAcID ,
                        afa.Name ,
                        FA.IsDebit;

        -- insert sales
        INSERT #AccountLedger ( PFinancialAcID ,
                                FinancialAcID ,
                                PFinancialAcName ,
                                FinancialAcName ,
                                Debit ,
                                Credit ,
                                IsDebit )
               SELECT   FA.PFinancialAcID ,
                        TD.FinancialAcID ,
                        afa.Name ,
                        FA.Name ,
                        SUM (TD.Debit) ,
                        SUM (TD.Credit) ,
                        FA.IsDebit
               FROM     dbo.Ac_Transaction T
                        INNER JOIN dbo.Ac_TransactionDetail TD ON T.TransactionID = TD.TransactionID
                        INNER JOIN dbo.Ac_FinancialAc FA ON FA.FinancialAcID = TD.FinancialAcID
                        LEFT JOIN dbo.Ac_FinancialAc AS afa ON afa.FinancialAcID = FA.PFinancialAcID
               WHERE    ISNULL (T.BillDate, T.PostedOn) BETWEEN @StartDateTime AND @EndDateTime
               AND      T.Descriptions NOT LIKE 'Sales Return Bill No%'
               AND      T.VoucherTypeID = @SalesVoucherTypeId
               AND      ISNULL (FA.AccEntryType, 0) = @AccEntryTypeId
               GROUP BY TD.FinancialAcID ,
                        FA.Name ,
                        FA.PFinancialAcID ,
                        afa.Name ,
                        FA.IsDebit;
  
        DECLARE @OpeningStock DECIMAL (18, 2);
        SELECT SRV.StockTranMasterId
        INTO   #TempOpening
        FROM   [dbo].[vw_ROI_StockReportView] SRV
               INNER JOIN ( SELECT   MAX (TransactionDate) AS TransactionDate ,
                                     ITId
                            FROM     [dbo].[vw_ROI_StockReportView] AS [vrsrv]
                            WHERE    vrsrv.TransactionDate < @StartDateTime
                            GROUP BY ITId ,
                                     StoreId ) SV ON  SRV.ITId = SV.ITId
                                                  AND SRV.TransactionDate = SV.TransactionDate;

        SELECT @OpeningStock = SUM (vrsrv.ItemValue)
        FROM   [dbo].[vw_ROI_StockReportView] AS [vrsrv]
        WHERE  EXISTS ( SELECT 1
                        FROM   #TempOpening t
                        WHERE  t.StockTranMasterId = vrsrv.StockTranMasterId );


        DECLARE @ClosingStock DECIMAL (18, 2);
        SELECT SRV.StockTranMasterId
        INTO   #TempClosing
        FROM   [dbo].[vw_ROI_StockReportView] SRV
               INNER JOIN ( SELECT   MAX (TransactionDate) AS TransactionDate ,
                                     ITId
                            FROM     [dbo].[vw_ROI_StockReportView] AS [vrsrv]
                            WHERE    vrsrv.TransactionDate <= @EndDateTime
                            GROUP BY ITId ,
                                     StoreId ) SV ON  SRV.ITId = SV.ITId
                                                  AND SRV.TransactionDate = SV.TransactionDate;

        SELECT @ClosingStock = SUM (vrsrv.ItemValue)
        FROM   [dbo].[vw_ROI_StockReportView] AS [vrsrv]
        WHERE  EXISTS ( SELECT 1
                        FROM   #TempClosing t
                        WHERE  t.StockTranMasterId = vrsrv.StockTranMasterId );


        INSERT #AccountLedger ( PFinancialAcID ,
                                FinancialAcID ,
                                PFinancialAcName ,
                                FinancialAcName ,
                                Debit ,
                                Credit ,
                                IsDebit )
               SELECT 0 ,
                      0 ,
                      'OPENING STOCK' ,
                      'OPENING STOCK' ,
                      ISNULL (@OpeningStock, 0) ,
                      0 ,
                      1
               UNION
               SELECT 0 ,
                      0 ,
                      'CLOSING STOCK' ,
                      'CLOSING STOCK' ,
                      0 ,
                      ISNULL (@ClosingStock, 0) ,
                      0;

        SELECT   FinancialAcID ,
                 PFinancialAcName ,
                 FinancialAcName ,
                 Debit ,
                 Credit ,
                 IsDebit
        FROM     #AccountLedger
        ORDER BY IsDebit ,
                 PFinancialAcID ,
                 PFinancialAcName ,
                 FinancialAcID ,
                 FinancialAcName;


        DROP TABLE IF EXISTS #AccountLedger;
        DROP TABLE IF EXISTS #TempOpening;
        DROP TABLE IF EXISTS #TempClosing;
    END;
GO

