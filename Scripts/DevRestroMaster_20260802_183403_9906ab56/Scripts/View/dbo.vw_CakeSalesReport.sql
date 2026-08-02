SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* =============================================  
 Author:  <Saroj Kumar Chaudhary>  
 Create date: <02-Mar-2021>  
 Description: View to get cake Sales Report 
 EXECUTE: SELECT * FROM [dbo].[vw_CakeSalesReport]
 ============================================= */
CREATE VIEW [dbo].[vw_CakeSalesReport]
AS
SELECT        OrderMasterId, SalesMasterId, BillDate, billNo, '' AS Waiter, '' AS restrotableTitle, 0 AS TableId, 
                         CASE WHEN VW.SalesType = 'cake' THEN 'Cake Order' WHEN VW.SalesType = 'wholesale' THEN 'WholeSale' WHEN VW.SalesType = 'retail' THEN 'Retail' END AS restroRoom, Total AS SubTotal, TotalDiscount, BasicAmount, 
                         ServiceCharge, Vat, NetAmount, PrintCount, PaymentMode AS PaymentModes, 1 AS Status, ReceivedAmt AS ReceivedAmount, Surplus AS SurplusDeficit, ReturnAmount AS ReturnPayment, SalesType, CustomerName, GuestNo, 
                         IsArchived
FROM            dbo.vw_CakeBillingDetails AS VW

GO
