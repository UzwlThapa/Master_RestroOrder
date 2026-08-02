SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* =============================================  
 Author:  <Saroj Kumar Chaudhary>  
 Create date: <02-Mar-2021>  
 Description: View to get cake billing details 
 EXECUTE: SELECT * FROM [dbo].[vw_CakeBillingDetails]  ORDER BY SalesMasterID
 ============================================= */
CREATE VIEW [dbo].[vw_CakeBillingDetails]
AS
SELECT        SM.SalesMasterId, SM.OrderMasterId, CAST(CONVERT(VARCHAR(16), SM.BillDate, 20) AS VARCHAR(120)) AS BillDate,
                             (SELECT        TOP (1) Code
                               FROM            dbo.RO_CompanyInfo) + fy.fyName + '-' + CAST(SM.InvoiceNo - fy.FirstSalesMasterID AS VARCHAR(20)) AS billNo, ISNULL(SPM.PaymentModeID, 1) AS PaymentModeID, CASE WHEN ISNULL(SPM.PaymentModeID, 
                         1) = 4 THEN PM.PaymentMode + '/' + SPM.Customer ELSE ISNULL(PM.PaymentMode, 'CASH') END AS PaymentMode, ISNULL(D.BasicAmount, 0.00) AS Total, ISNULL(D.TotalDiscount, 0.00) AS TotalDiscount, 
                         ISNULL(D.BasicAmount, 0.00) - ISNULL(D.TotalDiscount, 0.00) AS BasicAmount, ISNULL(SC.Amount, 0.00) AS ServiceCharge, ISNULL(D.BasicAmount, 0.00) + ISNULL(SC.Amount, 0.00) AS [Taxable Amt], ISNULL(Vat.Amount, 0.00) 
                         AS Vat, ISNULL(SM.NetAmount, 0.00) AS NetAmount, CASE WHEN SPM.PaymentModeID IN (2, 3, 4, 5, 6) THEN 0.00 ELSE ISNULL(SPM.PayAmount, 0.00) END AS ReceivedAmt, ISNULL(SM.ReturnAmount, 0.00) AS ReturnAmount, 
                         CASE WHEN SPM.PaymentModeID = 1 THEN CASE WHEN ISNULL(SM.TenderAmount, 0.00) < ISNULL(SM.NetAmount, 0.00) THEN (ISNULL(SM.TenderAmount, 0.00) - ISNULL(SM.NetAmount, 0.00)) 
                         ELSE (ISNULL(SM.TenderAmount, 0.00) - ISNULL(SM.NetAmount, 0.00) - ISNULL(SM.ReturnAmount, 0.00)) END ELSE 0.00 END AS Surplus, ISNULL(SM.PrintCount, 0) AS PrintCount, SM.SalesType, CASE LOWER(SM.SalesType) 
                         WHEN 'cake' THEN 6 WHEN 'wholesale' THEN 7 WHEN 'retail' THEN 8 END AS OrderType, CASE WHEN SPM.salesPaymentID = 4 THEN SPM.Customer ELSE SM.CustomerName END AS CustomerName, 1 AS GuestNo, 
                         SM.IsArchived
FROM            dbo.RO_CakeSalesMaster AS SM INNER JOIN
                         dbo.RO_fiscalYear AS fy ON fy.fyId = SM.FiscalYearID LEFT OUTER JOIN
                         dbo.RO_Discount AS D ON SM.SalesMasterId = D.SalesMasterId LEFT OUTER JOIN
                         dbo.RO_CAKE_SalesPaymentMode AS SPM ON SPM.salesMasterId = SM.SalesMasterId LEFT OUTER JOIN
                         dbo.RO_PaymentModes AS PM ON PM.PaymentModeID = SPM.PaymentModeID LEFT OUTER JOIN
                         dbo.vw_CakeServiceCharge AS SC ON SC.SalesMasterID = SM.SalesMasterId LEFT OUTER JOIN
                         dbo.vw_CakeVAT AS Vat ON Vat.SalesMasterID = SM.SalesMasterId

GO
