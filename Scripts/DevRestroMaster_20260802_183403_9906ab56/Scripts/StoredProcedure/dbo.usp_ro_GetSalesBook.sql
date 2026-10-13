SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ro_GetSalesBook]
    @FromDate NVARCHAR(256),
    @ToDate NVARCHAR(256)
AS
SELECT cbpl.LogID,
       cbpl.seller_pan,
       cbpl.buyer_pan,
       cbpl.fiscal_year,
       CASE
           WHEN NULLIF(RTRIM(LTRIM(cbpl.buyer_name)), '') IS NULL THEN
               -- Concatenate all payment modes with comma separator
               STUFF((
                   SELECT ', ' + 
                       CASE
                           WHEN LOWER(pm2.PaymentMode) = 'credit' THEN
                               pm2.PaymentMode + '/' + ISNULL(spm2.Customer, '')
                           ELSE
                               pm2.PaymentMode
                       END
                   FROM dbo.RO_SalesPaymentMode spm2
                   INNER JOIN dbo.RO_PaymentModes pm2
                       ON pm2.PaymentModeID = spm2.PaymentModeID
                   WHERE spm2.salesMasterId = cbpl.SalesMasterId
                   FOR XML PATH('')
               ), 1, 2, '')  -- Removes first 2 chars: ', '
           ELSE
               cbpl.buyer_name
       END AS buyer_name,
       cbpl.invoice_number,
       cbpl.invoice_date,
       cbpl.total_sales,
       cbpl.taxable_sales_vat,
       cbpl.vat,
       cbpl.excisable_amount,
       cbpl.excise,
       cbpl.taxable_sales_hst,
       cbpl.hst,
       cbpl.amount_for_esf,
       cbpl.esf,
       cbpl.export_sales,
       cbpl.tax_exempted_sales,
       cbpl.isrealtime,
       cbpl.datetimeClient,
       cbpl.BillPostDateTime,
       cbpl.StatusCode,
       cbpl.StatusDetails,
       cbpl.SalesMasterId,
       cbpl.EnglishInvDate,
       cbpl.SalesType,
       ISNULL([dbo].[ufn_getsalesbillquantity](cbpl.SalesMasterId), 0) AS Qty
FROM CBMS_BillPostLog cbpl
WHERE invoice_date BETWEEN REPLACE(@FromDate, '-', '.') AND REPLACE(@ToDate, '-', '.')

UNION ALL

SELECT 0 AS LogID,
             ci.PAN AS seller_pan,
             sm.PAN AS buyer_pan,
             fy.fyName AS fiscal_year,
             sm.CustomerName AS buyer_name,
             ci.Code + fy.fyName + '-' + CAST(sm.InvoiceNo - fy.FirstSalesMasterID AS VARCHAR(20)) AS invoice_number,
             sm.NepaliInvoiceDate AS invoice_date,
             sm.BasicAmount AS total_sales,
             sm.BasicAmount AS taxable_sales_vat,
             ISNULL(vat.Amount, 0) AS vat,
             0 AS excisable_amount,
             0 AS excise,
             0 AS taxable_sales_hst,
             0 AS hst,
             0 AS amount_for_esf,
             0 AS esf,
             0 AS export_sales,
             0 AS tax_exempted_sales,
             0 AS isrealtime,
             sm.AddedOn AS datetimeClient,
             sm.BillDate AS BillPostDateTime,
             'LOCAL' AS StatusCode,
             'LOCAL - NOT IRD SUBMITTED' AS StatusDetails,
             sm.SalesMasterId,
             sm.BillDate AS EnglishInvDate,
             sm.SalesType,
             ISNULL(qty.Qty, 0) AS Qty
FROM dbo.RO_CakeSalesMaster sm
INNER JOIN dbo.RO_fiscalYear fy ON fy.fyId = sm.FiscalYearID
CROSS JOIN (SELECT TOP (1) Code, PAN FROM dbo.RO_CompanyInfo) ci
LEFT JOIN dbo.RO_CAKE_BillingAmount vat
        ON vat.SalesMasterID = sm.SalesMasterId
     AND vat.BilingID = 54
     AND LOWER(ISNULL(vat.SalesType, '')) = LOWER(ISNULL(sm.SalesType, ''))
OUTER APPLY
(
        SELECT SUM(sd.Quantity) AS Qty
        FROM dbo.RO_CakeSalesDetail sd
        WHERE sd.SalesMasterId = sm.SalesMasterId
            AND LOWER(ISNULL(sd.SalesType, '')) = LOWER(ISNULL(sm.SalesType, ''))
) qty
WHERE sm.IsArchived = 0
    AND sm.IsUpdated = 1
    AND LOWER(ISNULL(sm.SalesType, '')) IN ('cake', 'retail', 'wholesale')
    AND sm.NepaliInvoiceDate BETWEEN REPLACE(@FromDate, '-', '.') AND REPLACE(@ToDate, '-', '.')
    AND NOT EXISTS
    (
            SELECT 1
            FROM dbo.CBMS_BillPostLog posted
            WHERE posted.SalesMasterId = sm.SalesMasterId
                AND LOWER(ISNULL(posted.SalesType, '')) = LOWER(ISNULL(sm.SalesType, ''))
    );

GO
