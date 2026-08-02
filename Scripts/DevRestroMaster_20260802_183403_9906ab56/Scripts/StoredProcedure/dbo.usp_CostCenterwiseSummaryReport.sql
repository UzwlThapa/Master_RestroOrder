SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --DROP PROCEDURE [dbo].[usp_CostCenterwiseSummaryReport]  
CREATE PROCEDURE [dbo].[usp_CostCenterwiseSummaryReport]  
@startDate DATETIME,            
@endDate DATETIME,            
@CostCenter INT  
  
AS  
BEGIN  
 SELECT  
  cc.CostCenterName AS CostCenterName  
  ,SUM(sd.qty * sd.rate) AS Total  
 FROM dbo.RO_SalesMaster sm  
 Inner join CBMS_BillPostLog bp on bp.SalesMasterId = sm.salesMasterId  
 INNER JOIN dbo.RO_SalesDetail sd ON sd.salesMasterId = sm.salesMasterId  
 LEFT JOIN CostCenterInfo cc ON cc.CostCenterId = sd.CostCenterId  
 WHERE (sd.CostCenterId=@CostCenter or @CostCenter=0)  
 AND (CAST (dateadd(hour,-4,sm.BillDate) as DATE) BETWEEN CAST(@startDate as DATE) AND CAST(@endDate as DATE))  
 and sm.IsArchived=0 and sm.IsUpdated=1  
 GROUP BY CostCenterName  

 UNION

 SELECT  
  cc.CostCenterName AS CostCenterName  
  ,SUM(sd.Quantity * sd.rate) AS Total  
 FROM dbo.RO_CakeSalesMaster sm  
 --Inner join CBMS_BillPostLog bp on bp.SalesMasterId = sm.salesMasterId  
 INNER JOIN dbo.RO_CakeSalesDetail sd ON sd.salesMasterId = sm.salesMasterId  
 LEFT JOIN CostCenterInfo cc ON cc.CostCenterId = sd.CostCenterId  
 WHERE (sd.CostCenterId=@CostCenter or @CostCenter=0)  
 AND (CAST (dateadd(hour,-4,sm.BillDate) as DATE) BETWEEN CAST(@startDate as DATE) AND CAST(@endDate as DATE))  
 and sm.IsArchived=0 and sm.IsUpdated=1  
 GROUP BY CostCenterName  

END  

GO
