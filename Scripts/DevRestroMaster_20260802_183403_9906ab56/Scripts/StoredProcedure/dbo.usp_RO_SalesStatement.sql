SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_RO_SalesStatement]    
@DATE date    
as     
begin    
SELECT cast(sm.BillDate as DATE) as [DATE], sum(1) as [BillNo]    
,SUM(sm.BasicAmount) as [TotalAll]    
,sum(sm.sumBev) as BEV    
, sum(SM.sumKot) as KOT    
,sum(sm.totaldiscount) as [DISCOUNT]    
,sum(sm.sumBev+sm.sumKot) as Total    
,sum(isnull(b1.Amount,0)) as ServiceCharge    
,sum(isnull(b2.Amount,0)) as TaxCharge   
,sum(sm.NetAmount) as NetAmount    
,sum(sm.NetAmount)/sum(1) as [SalesPerBill]    
 from RO_SalesMaster sm      
 left join RO_BillingAmount b1 on B1.SalesMasterID = sm.salesMasterId and b1.BilingID = 62    
 left join RO_BillingAmount b2 on B2.SalesMasterID = sm.salesMasterId and b2.BilingID = 54    
 where cast(sm.BillDate as DATE) = CAST(@DATE as date)    
group by cast(sm.BillDate as DATE)  
  
end



GO
