SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC USP_GetDayPartWise_Sales_Report '2018-12-19'    
-- DROP PROC USP_GetDayPartWise_Sales_Report    
CREATE PROCEDURE [dbo].[USP_GetDayPartWise_Sales_Report]     
@Date  DATE    
AS    
--DECLARE @Date  DATE    
--set @Date='2018-11-13 13:18'    
    
--SELECT * FROM  [dbo].[RO_Sales_View]    
--WHERE 1=1 AND  (CAST(DATEADD(HOUR,-4,BillDate) AS Date) >= @Date)    
--AND  DATEPART(HOUR,BillDate) >=12    
-- AND DATEPART(HOUR, BillDate) < 16    
    
  --select * from RO_SalesMaster  
    
SELECT 'BREAKFAST' as Customer,  ISNULL(SUM(BasicAmount),0) BasicAmount    
      ,ISNULL(SUM([TotalDiscount]),0) TotalDiscount    
      ,ISNULL(SUM([ServiceCharge]),0) ServiceCharge    
      ,ISNULL(SUM([Vat]),0) VAT    
FROM [dbo].DailySalesReport    
WHERE 1=1 AND CAST( [Period] as Date) = CAST( @Date as DATE)
AND  DATEPART(HOUR,BillTime) >= 4      
AND DATEPART(HOUR, BillTime) < 12    
UNION ALL    
SELECT 'LUNCH' as Customer,  ISNULL(SUM(BasicAmount),0) BasicAmount    
      ,ISNULL(SUM([TotalDiscount]),0) TotalDiscount    
      ,ISNULL(SUM([ServiceCharge]),0) ServiceCharge    
      ,ISNULL(SUM([Vat]),0) VAT    
FROM [dbo].DailySalesReport    
WHERE 1=1 AND CAST( [Period] as Date) = CAST( @Date as DATE)  
AND  DATEPART(HOUR,BillTime) >=12     
AND DATEPART(HOUR, BillTime) < 16    
    
UNION ALL    
    
SELECT 'DINNER' as Customer,  ISNULL(SUM(BasicAmount),0) BasicAmount    
      ,ISNULL(SUM([TotalDiscount]),0) TotalDiscount    
      ,ISNULL(SUM([ServiceCharge]),0) ServiceCharge    
      ,ISNULL(SUM([Vat]),0) VAT    
FROM [dbo].DailySalesReport    
WHERE 1=1   
AND (  
 (CAST( [Period] as Date) =  CAST( @Date as DATE) AND  DATEPART(HOUR,BillTime) >=16  )   
OR (CAST( [Period] as Date) =  CAST( @Date as DATE) AND DATEPART(HOUR, BillTime) <= 4  )  
)  
    
    
UNION ALL    
    
SELECT 'TOTAL' as Customer, ISNULL(SUM(BasicAmount),0) BasicAmount    
      ,ISNULL(SUM([TotalDiscount]),0) TotalDiscount    
      ,ISNULL(SUM([ServiceCharge]),0) ServiceCharge    
      ,ISNULL(SUM([Vat]),0) VAT    
FROM [dbo].DailySalesReport    
WHERE 1=1 AND  CAST( [Period] as Date) =  CAST( @Date as DATE)
  

GO
