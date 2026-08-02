SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Ro_SalesChart]
as
SELECT
	COUNT(1) AS NoOfBill
 , cast(SM.BillDate as date) AS Bill_Date        
 , sum(SM.BasicAmount +SM.totaldiscount) AS Amount        
 , sum(SM.totaldiscount) AS Discount        
 , sum(isnull(ba1.Amount,0)) AS ServiceCharge        
 , sum(isnull(sm.BasicAmount,0) + isnull(ba1.Amount,0)) AS TaxableAmount        
 , sum(bA2.Amount )AS Tax_Amount 
 --, sum(sm.BasicAmount + ba1.Amount)*.13  
FROM   dbo.RO_SalesMaster AS SM               
   left join dbo.RO_BillingAmount bA1 on bA1.SalesMasterID = sm.salesMasterId and BA1.IsVoid = 0 and bA1.BilingID = 62       
   left join dbo.RO_BillingAmount bA2 on bA2.SalesMasterID = sm.salesMasterId and BA2.IsVoid = 0 and bA2.BilingID = 54       
      WHERE (sm.BillDate BETWEEN dateadd(MONTH,-1,GETDATE()) AND GETDATE() )   and   (sm.IsArchived = 0)
   group by  cast(SM.BillDate as date) 
      Order by  cast(SM.BillDate as date) 


GO
