SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

ALTER PROCEDURE [dbo].usp_ac_getVerifiedTransactionByID
    @transactionID INT
/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: ADARSHA KARKI
	Last Modified Date: 10/05/2023 MM/DD/YYYY
	Last Modified By: Yawa
	Last Modified Date: 11/07/2023
====================================

	EXEC usp_ac_getVerifiedTransactionByID  10
*/
AS
    BEGIN
        DECLARE @SalesVoucherTypeId INT;
        SELECT @SalesVoucherTypeId = VoucherTypeID
        FROM   dbo.Ac_VoucherType t
        WHERE  t.VoucherName = 'Sales Voucher';
        IF (( SELECT   TOP ( 1 ) VoucherTypeID
              FROM     dbo.Ac_Transaction
              WHERE    TransactionID = @transactionID
              ORDER BY VoucherTypeID ) = @SalesVoucherTypeId )
            BEGIN

                DECLARE @code VARCHAR (50);
                SELECT @code = Code
                FROM   dbo.RO_CompanyInfo;

                SELECT DISTINCT it.ITName AS Particulars ,
                                CASE WHEN fa.IsDebit = 1 THEN ( SD.qty * SD.rate )
                                     ELSE 0
                                END AS Debit ,
                                CASE WHEN fa.IsDebit = 0 THEN ( SD.qty * SD.rate )
                                     ELSE 0
                                END AS Credit ,
                                fa.Name AS financialAcName ,
                                td.FinancialAcID AS FinancialAcID ,
                                td.ChequeNo ,
                                td.ChequeDate ,
                                t.PostedBy ,
                                CAST(t.PostedOn AS DATE) AS PostedOn ,
                                td.TransactionDetailID ,
                                t.VoucherTypeID ,
                                avt.VoucherName
                INTO   #temptrandetail
                FROM   dbo.RO_SalesMaster SM
                       LEFT JOIN dbo.RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
                       INNER JOIN dbo.RO_fiscalYear fy ON fy.fyId = SM.FiscalYearID
                       INNER JOIN dbo.ROI_ITEMMain it ON it.ITId = SD.ItemId
                       INNER JOIN dbo.RO_SalesPaymentMode sp ON sp.salesMasterId = SM.salesMasterId
                       INNER JOIN dbo.CostCenterInfo CC ON CC.CostCenterId = SD.CostCenterId
                       LEFT JOIN dbo.RO_CostCenterGroup CCG ON CCG.GroupId = CC.GroupId
                       INNER JOIN dbo.Ac_Transaction t ON CAST(SUBSTRING (
                                                                   SUBSTRING (
                                                                       t.Descriptions ,
                                                                       CHARINDEX (@code, t.Descriptions, 0),
                                                                       LEN (t.Descriptions)) ,
                                                                   CHARINDEX (
                                                                       '-' ,
                                                                       SUBSTRING (
                                                                           t.Descriptions ,
                                                                           CHARINDEX (@code, t.Descriptions, 0),
                                                                           LEN (t.Descriptions)),
                                                                       0) + 1,
                                                                   LEN (
                                                                       SUBSTRING (
                                                                           t.Descriptions ,
                                                                           CHARINDEX (@code, t.Descriptions, 0),
                                                                           LEN (t.Descriptions)))) AS INT)
                                                          + fy.FirstSalesMasterID = SM.InvoiceNo
                       INNER JOIN dbo.Ac_TransactionDetail td ON td.TransactionID = t.TransactionID
                       LEFT JOIN dbo.Ac_VoucherType AS avt ON avt.VoucherTypeID = t.VoucherTypeID
                       LEFT JOIN dbo.Ac_FinancialAc fa ON  fa.FinancialAcID = td.FinancialAcID
                                                       AND CCG.FinancialAcId = fa.FinancialAcID
                WHERE  t.TransactionID = @transactionID
                AND    fa.FinancialAcID IS NOT NULL
                AND    t.VoucherTypeID = @SalesVoucherTypeId;


                INSERT #temptrandetail
                       SELECT DISTINCT td.Particulars AS Particulars ,
                                       td.Debit AS Debit ,
                                       td.Credit AS Credit ,
                                       FAA.Name AS financialAcName ,
                                       FAA.FinancialAcID AS FinancialAcID ,
                                       td.ChequeNo AS ChequeNo ,
                                       td.ChequeDate AS ChequeDate ,
                                       t.PostedBy AS PostedBy ,
                                       CAST(t.PostedOn AS DATE) AS PostedOn ,
                                       td.TransactionDetailID AS TransactionDetailID ,
                                       t.VoucherTypeID AS VoucherTypeID ,
                                       avt.VoucherName
                       FROM   dbo.RO_SalesMaster SM
                              LEFT JOIN dbo.RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
                              INNER JOIN dbo.RO_fiscalYear FY ON FY.fyId = SM.FiscalYearID
                              INNER JOIN dbo.ROI_ITEMMain it ON it.ITId = SD.ItemId
                              INNER JOIN dbo.RO_SalesPaymentMode sp ON sp.salesMasterId = SM.salesMasterId
                              INNER JOIN dbo.CostCenterInfo CC ON CC.CostCenterId = SD.CostCenterId
                              LEFT JOIN dbo.RO_CostCenterGroup CCG ON CCG.GroupId = CC.GroupId
                              INNER JOIN dbo.Ac_Transaction t ON CAST(SUBSTRING (
                                                                          SUBSTRING (
                                                                              t.Descriptions ,
                                                                              CHARINDEX (@code, t.Descriptions, 0),
                                                                              LEN (t.Descriptions)) ,
                                                                          CHARINDEX (
                                                                              '-' ,
                                                                              SUBSTRING (
                                                                                  t.Descriptions ,
                                                                                  CHARINDEX (@code, t.Descriptions, 0),
                                                                                  LEN (t.Descriptions)),
                                                                              0) + 1,
                                                                          LEN (
                                                                              SUBSTRING (
                                                                                  t.Descriptions ,
                                                                                  CHARINDEX (@code, t.Descriptions, 0),
                                                                                  LEN (t.Descriptions)))) AS INT)
                                                                 + FY.FirstSalesMasterID = SM.InvoiceNo
                              INNER JOIN dbo.Ac_TransactionDetail td ON td.TransactionID = t.TransactionID
                              LEFT JOIN dbo.Ac_VoucherType AS avt ON avt.VoucherTypeID = t.VoucherTypeID
                              LEFT JOIN dbo.Ac_FinancialAc fa ON fa.FinancialAcID = td.FinancialAcID
                              LEFT JOIN dbo.Ac_FinancialAc FAA ON FAA.FinancialAcID = td.FinancialAcID
                       WHERE  t.TransactionID = @transactionID
                       AND    t.VoucherTypeID = @SalesVoucherTypeId
                       AND    CCG.FinancialAcId <> td.FinancialAcID
                       AND    NOT EXISTS ( SELECT TOP ( 1 ) 1
                                           FROM   dbo.RO_CostCenterGroup
                                           WHERE  FinancialAcId = td.FinancialAcID );


                SELECT   td.Particulars ,
                         td.Debit ,
                         td.Credit ,
                         td.financialAcName ,
                         td.FinancialAcID ,
                         td.ChequeNo ,
                         td.ChequeDate ,
                         td.PostedBy ,
                         td.PostedOn ,
                         td.TransactionDetailID ,
                         td.VoucherTypeID ,
                         td.VoucherName
                FROM     #temptrandetail AS td
                ORDER BY td.FinancialAcID ,
                         td.financialAcName ,
                         td.Particulars ,
                         td.ChequeNo ,
                         td.ChequeDate ,
                         td.PostedBy ,
                         CAST(td.PostedOn AS DATE) ,
                         td.TransactionDetailID ,
                         td.VoucherTypeID;

                DROP TABLE IF EXISTS #temptrandetail;

            END;
        ELSE
            BEGIN

                SELECT fa.Name AS financialAcName ,
                       ttd.FinancialAcID ,
                       ttd.Particulars ,
                       ttd.Debit ,
                       ttd.Credit ,
                       ttd.ChequeNo ,
                       ttd.ChequeDate ,
                       tt.PostedBy ,
                       CAST(tt.PostedOn AS DATE) AS PostedOn ,
                       ttd.TransactionDetailID ,
                       tt.VoucherTypeID ,
                       avt.VoucherName
                FROM   dbo.Ac_TransactionDetail ttd
                       JOIN dbo.Ac_FinancialAc fa ON ttd.FinancialAcID = fa.FinancialAcID
                       JOIN dbo.Ac_Transaction tt ON tt.TransactionID = ttd.TransactionID
                       LEFT JOIN dbo.Ac_VoucherType AS avt ON avt.VoucherTypeID = tt.VoucherTypeID
                WHERE  ttd.TransactionID = @transactionID;
            END;
    END;
GO

