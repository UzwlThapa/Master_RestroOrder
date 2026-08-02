SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  <Saroj Kumar Chaudhary>  
-- Create date: <10-Jan-2021>  
-- Description: <Get billing term>  
-- EXECUTE: USP_RO_GETBILLTERMBYSalesMasterId 1,'wholesale' 
-- ============================================= 
CREATE PROCEDURE [dbo].[USP_RO_GETBILLTERMBYSalesMasterId] @salesMasterID INT
,@SalesType varchar(30) = null
AS
if(isnull(@SalesType,'') = '')
begin
	SELECT bt.NAME as BillTerm
	,ba.rate as Rate
	,ba.Amount
	,bt.IsAdd
	,bt.SequenceOrder as seq
FROM RO_BillingAmount ba
JOIN RO_SalesMaster sm ON sm.salesMasterId = ba.SalesMasterID
LEFT JOIN RO_BillTerm bt ON bt.BilingID = ba.BilingID
WHERE 
ba.SalesMasterID = @salesMasterID
	AND
	 ba.rate <> 0 --(ba.rate <> 0 or ba.Amount <> 0)
--ORDER BY bt.SequenceOrder ASC
union
select 'DeliveryCharge' as BillTerm
	,0 as Rate
	,isnull(DeliveryCharge,0) as Amount
	,1 as IsAdd
	,999 as seq
 from RO_SalesMaster
 where 
 salesMasterId=@salesMasterID

union

select 'NetAmount' as BillTerm
	,0 as Rate
	,NetAmount as Amount
	,1 as IsAdd
	,9999 as seq
 from RO_SalesMaster
 where 
 salesMasterId=@salesMasterID
 ORDER BY seq ASC  
 
end
else
begin
	SELECT bt.NAME as BillTerm
	,ba.rate as Rate
	,ba.Amount
	,bt.IsAdd
	,bt.SequenceOrder as seq
FROM RO_CAKE_BillingAmount ba
JOIN RO_CakeSalesMaster sm ON sm.salesMasterId = ba.SalesMasterID and lower(isnull(sm.SalesType,'')) = lower(isnull(ba.SalesType,''))
LEFT JOIN RO_BillTerm bt ON bt.BilingID = ba.BilingID
WHERE 
ba.SalesMasterID = @salesMasterID and lower(isnull(ba.SalesType,'')) = lower(isnull(@SalesType,''))
	AND
	 ba.rate <> 0 
union
select 'DeliveryCharge' as BillTerm
	,0 as Rate
	,0 as Amount
	,1 as IsAdd
	,999 as seq
 from RO_CakeSalesMaster
 where 
 salesMasterId=@salesMasterID and lower(isnull(SalesType,'')) = lower(isnull(@SalesType,''))

union

select 'NetAmount' as BillTerm
	,0 as Rate
	,NetAmount as Amount
	,1 as IsAdd
	,9999 as seq
 from RO_CakeSalesMaster
 where 
 salesMasterId=@salesMasterID and lower(isnull(SalesType,'')) = lower(isnull(@SalesType,''))
 ORDER BY seq ASC  
 
end




GO
