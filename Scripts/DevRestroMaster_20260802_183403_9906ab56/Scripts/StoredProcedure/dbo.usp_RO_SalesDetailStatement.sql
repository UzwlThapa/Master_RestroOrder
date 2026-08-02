SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--   usp_RO_SalesDetailStatement '2017-01-19'  
  
CREATE PROCEDURE [dbo].[usp_RO_SalesDetailStatement]    
@DATE date    
as    
begin    
 select im.ITName
	,cci.CostCenterName
	,sum(sd.qty) as QTY 
	,iwu.Conversion
	,u.Symbol 
	from RO_SalesMaster sm     
 inner join RO_SalesDetail sd on sm.salesMasterId = sd.salesMasterId    
 inner join ROI_ITEMMain im on im.ITId = sd.ItemId    
 inner join ROI_ItemRate iwu on im.ITId = iwu.ItemID    
 inner join ROI_Unit1 u on u.Unit1Id = iwu.LargeUnit    
 inner join CostCenterInfo cci on sd.CostCenterId = cci.CostCenterId    
 where cast(sm.BillDate as DATE) = CAST(@DATE as date)    and sd.IsCombo = 0
 group by im.ITName,cci.CostCenterName,iwu.Conversion,u.Symbol    
 --order by cci.CostCenterName   
 union  
 select im.Name ITName
	,cci.CostCenterName
	,sum(sd.qty) as QTY 
	,1 Conversion
	,'Combo' Symbol 
	from RO_SalesMaster sm     
 inner join RO_SalesDetail sd on sm.salesMasterId = sd.salesMasterId    
 inner join RO_Combo im on im.ComboID = sd.ItemId    
 --inner join ROI_ItemRate iwu on im.ComboID = iwu.ItemID    
-- inner join ROI_Unit1 u on u.Unit1Id = iwu.LargeUnit    
 inner join CostCenterInfo cci on sd.CostCenterId = cci.CostCenterId    
 where cast(sm.BillDate as DATE) = CAST(@DATE as date)    and sd.IsCombo = 1
 group by im.Name,cci.CostCenterName--,iwu.Conversion,u.Symbol    
 order by cci.CostCenterName  
end



GO
