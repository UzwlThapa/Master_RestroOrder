
GO
/****** Object:  StoredProcedure [dbo].[usp_ac_getProfitLoss]    Script Date: 15/10/2023 10:59:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 11/10/2023
====================================

EXEC dbo.usp_ac_getProfitLoss '2023-09-06','2023-09-06'

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

        --DECLARE @SalesVoucherTypeId INT;
        --SELECT @SalesVoucherTypeId = VoucherTypeID
        --FROM   dbo.Ac_VoucherType t
        --WHERE  t.VoucherName = 'Sales Voucher';

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
               WHERE    ISNULL (T.BillDate, T.PostedOn) BETWEEN @StartDateTime AND @EndDateTime
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
               GROUP BY TD.FinancialAcID ,
                        FA.Name ,
                        FA.PFinancialAcID ,
                        afa.Name ,
                        FA.IsDebit 

        DECLARE @OpeningStock DECIMAL (18, 2);
        SELECT @OpeningStock = SUM (TD.Debit) - SUM (TD.Credit)
        FROM   dbo.Ac_Transaction tt
               INNER JOIN dbo.Ac_TransactionDetail TD ON tt.TransactionID = TD.TransactionID
        WHERE  ISNULL (tt.BillDate, tt.PostedOn) < @StartDateTime;

        DECLARE @ClosingStock DECIMAL (18, 2);
        SELECT @ClosingStock = SUM (TD.Debit) - SUM (TD.Credit)
        FROM   dbo.Ac_Transaction tt
               INNER JOIN dbo.Ac_TransactionDetail TD ON tt.TransactionID = TD.TransactionID
        WHERE  ISNULL (tt.BillDate, ISNULL (tt.BillDate, tt.PostedOn)) <= @EndDateTime;

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
    END;
