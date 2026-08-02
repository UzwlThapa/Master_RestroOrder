SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_SALES_REPORTByBillNo]        
 @StartBill int,
@EndBill int,
@Status INT
AS     
BEGIN   
   --declare @StartBill int=5
   --declare @EndBill int=200
     
SELECT         
  sm.OrderMasterId          
  ,sm.salesMasterId          
  ,CAST(CONVERT(VARCHAR(16), sm.BillDate, 20) AS VARCHAR(120)) AS BillDate          
  ,'RO' + fy.fyName + '-' + CAST((sm.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR(20)) AS billNo          
  ,sm.Waiter          
  ,rt.restrotableTitle          
  ,sm.TableId          
  ,rr.restroRoom        
  ,sm.BasicAmount + sm.totaldiscount AS SubTotal        
  ,sm.totaldiscount        
  ,sm.BasicAmount        
  ,b1.Amount AS ServiceCharge        
  ,b2.Amount AS Vat        
  ,sm.NetAmount        
  ,ISNULL(sm.PrintCount,0)   PrintCount      
  ,sm.SPMID     
  ,sm.IsArchived as [Status]       
 FROM dbo.RO_SalesMaster sm          
 INNER JOIN RO_fiscalYear fy ON fy.fyId = sm.FiscalYearID          
 INNER JOIN RO_BillingAmount b1 ON B1.SalesMasterID = sm.salesMasterId AND b1.BilingID = 62        
 INNER JOIN RO_BillingAmount b2 ON B2.SalesMasterID = sm.salesMasterId AND b2.BilingID = 54        
 LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = sm.RoomId          
 LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = sm.TableId          
 WHERE 
 (sm.InvoiceNo BETWEEN @StartBill AND @EndBill)        
 --AND (sm.SPMID = @PaymentMode OR @PaymentMode=0)       
 AND (sm.IsArchived = @Status OR @Status = -1)    
 ORDER BY salesMasterId DESC;         
END;	



GO
