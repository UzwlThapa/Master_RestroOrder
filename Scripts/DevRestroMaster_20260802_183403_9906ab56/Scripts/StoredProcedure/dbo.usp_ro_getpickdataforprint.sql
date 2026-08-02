SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_ro_getpickdataforprint] 5 
CREATE PROCEDURE [dbo].[usp_ro_getpickdataforprint]    
@TableId INT    
AS    
BEGIN    
DECLARE @OrderMasterId VARCHAR(128)    
SELECT @OrderMasterId=OrderMasterID FROM dbo.RO_OrderMasters WHERE OID=@TableId    
    
-----for footitem------------------------------------------------------    
SELECT     
          SD.qty Quantity ,        
         SD.rate Rate ,        
   CASE WHEN sd.CostCenterId=1 OR sd.CostCenterId=95 THEN  SD.qty * SD.rate ELSE 0 END AS Amount,        
   CASE WHEN sd.CostCenterId=2 THEN  SD.qty * SD.rate  ELSE 0 END AS Bevrage,        
         SM.OrderMasterId ,        
         '' Note ,        
         0  ExtraCharge ,         
           it.ITName ,        
         SM.BillDate DATE ,        
         SM.BasicAmount ,         
           rt.restrotableTitle ,      
    sm.totaldiscount,        
    sm.PrintCount,        
    (sm.InvoiceNo -fy.FirstSalesMasterID ) AS BillNo        
    ,( fy.fyName ) AS fiscalYear       
 ,SM.CusName  
 ,SM.PAN  
 ,SM.Address   
 ,sm.salesMasterId      
 FROM RO_SalesMaster SM    
INNER JOIN RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId    
INNER JOIN RO_fiscalYear fy ON fy.fyId = sm.FiscalYearID    
LEFT JOIN RO_restroTable rt ON rt.restrotableId = sm.TableId    
LEFT JOIN ROI_ITEMMain it ON it.ITId = sd.ItemId    
WHERE SM.salesMasterId = @OrderMasterID  and SD.IsCombo = 0    
union     
SELECT     
          SD.qty Quantity ,        
         SD.rate Rate ,        
   CASE WHEN sd.CostCenterId=1 OR sd.CostCenterId=95 THEN  SD.qty * SD.rate ELSE 0 END AS Amount,        
   CASE WHEN sd.CostCenterId=2 THEN  SD.qty * SD.rate  ELSE 0 END AS Bevrage,        
         SM.OrderMasterId ,        
         '' Note ,        
         0  ExtraCharge ,         
           it.Name ITName ,        
         SM.BillDate DATE ,        
         SM.BasicAmount ,         
           rt.restrotableTitle ,      
    sm.totaldiscount,        
    sm.PrintCount,        
    (sm.InvoiceNo -fy.FirstSalesMasterID ) AS BillNo        
    ,( fy.fyName ) AS fiscalYear     
 ,SM.CusName  
 ,SM.PAN  
 ,SM.Address
 ,sm.salesMasterId      
 FROM RO_SalesMaster SM    
INNER JOIN RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId    
INNER JOIN RO_fiscalYear fy ON fy.fyId = sm.FiscalYearID    
LEFT JOIN RO_restroTable rt ON rt.restrotableId = sm.TableId    
LEFT JOIN RO_Combo it ON it.ComboID = sd.ItemId    
WHERE SM.salesMasterId = @OrderMasterID  and SD.IsCombo = 1     
END



GO
