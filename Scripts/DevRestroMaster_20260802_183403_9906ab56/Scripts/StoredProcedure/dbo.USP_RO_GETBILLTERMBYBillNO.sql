SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GETBILLTERMBYBillNO]  @BillNo nvarchar(128)
AS
SELECT bt.NAME as BillTerm
	,ba.rate as Rate
	,ba.Amount
	,bt.IsAdd
	,bt.SequenceOrder as seq
FROM RO_SalesMaster sm
JOIN RO_BillingAmount ba ON sm.salesMasterId = ba.SalesMasterID
LEFT JOIN RO_BillTerm bt ON bt.BilingID = ba.BilingID
WHERE sm.billNo = @BillNo
	AND ba.rate <> 0 --(ba.rate <> 0 or ba.Amount <> 0)
--ORDER BY bt.SequenceOrder ASC

union
select 'NetAmount' as BillTerm
	,0 as Rate
	,NetAmount as Amount
	,1 as IsAdd
	,999 as seq
 from RO_SalesMaster
 where billNo=@BillNo
 ORDER BY seq ASC  
 


GO
