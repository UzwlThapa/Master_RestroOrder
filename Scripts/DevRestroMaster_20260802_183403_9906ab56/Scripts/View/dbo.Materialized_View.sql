SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Materialized_View]
AS
SELECT        SM.FiscalYearID AS FiscalYear, 'RO' + fy.fyName + '-' + CAST(SM.InvoiceNo - fy.FirstSalesMasterID AS varchar(20)) AS Bill_No, SM.CusName AS Customer_Name, '' AS Customer_PAN, SM.BillDate AS Bill_Date, 
                         SM.BasicAmount + SM.totaldiscount AS AMOUNT, SM.totaldiscount AS Discount, bA1.Amount AS ServiceCharge, SM.BasicAmount + bA1.Amount AS TaxableAmount, bA2.Amount AS Tax_Amount, 
                         CASE WHEN PD.PrintedBy IS NULL THEN 0 ELSE 1 END AS Is_Printed, ~ SM.IsArchived AS Is_Active, MIN(PD.PrintedDate) AS Printed_Time, MIN(SM.AddedBy) AS Entered_by, MIN(PD.PrintedBy) 
                         AS Printed_by
FROM            dbo.RO_SalesMaster AS SM INNER JOIN
                         dbo.RO_fiscalYear AS fy ON SM.FiscalYearID = fy.fyId LEFT OUTER JOIN
                         dbo.PrintDetail AS PD ON SM.salesMasterId = PD.PrintBillNo LEFT OUTER JOIN
                         dbo.RO_BillingAmount AS bA1 ON bA1.SalesMasterID = SM.salesMasterId AND bA1.IsVoid = 0 AND bA1.BilingID = 62 LEFT OUTER JOIN
                         dbo.RO_BillingAmount AS bA2 ON bA2.SalesMasterID = SM.salesMasterId AND bA2.IsVoid = 0 AND bA2.BilingID = 54
GROUP BY SM.salesMasterId, SM.FiscalYearID, fy.fyName, fy.FirstSalesMasterID, SM.CusName, SM.BillDate, SM.BasicAmount, SM.totaldiscount, bA1.Amount, bA2.Amount, PD.PrintedBy, SM.IsArchived, SM.InvoiceNo




GO
