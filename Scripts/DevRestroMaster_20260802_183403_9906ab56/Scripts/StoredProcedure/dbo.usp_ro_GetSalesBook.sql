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
WHERE invoice_date BETWEEN REPLACE(@FromDate, '-', '.') AND REPLACE(@ToDate, '-', '.');

GO
