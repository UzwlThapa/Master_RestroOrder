SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[ClosingReport_BillWiseSales] '2017-07-03'
CREATE PROCEDURE [dbo].[ClosingReport_BillWiseSales]    
@DATE date    
as     
BEGIN
	--DECLARE @DATE DATE = '2017-07-10'
	declare @startDate datetime,@endDate datetime
	set @startDate = dateadd(hour,4,cast(@DATE as datetime))
	set @endDate = dateadd(day,1,@startDate)

	SELECT 
	--[BillNo] [DATE]
	'RO' + (
			SELECT fy.fyName
			FROM dbo.ro_fiscalyear fy
			WHERE fy.fyid = sm.fiscalyearid
			) + '-' + convert(NVARCHAR(100), (
				sm.InvoiceNo - (
					SELECT fy.firstsalesmasterid
					FROM dbo.ro_fiscalyear fy
					WHERE fy.fyid = sm.fiscalyearid
					)
				)) AS [DATE]
		,SUM(sm.BasicAmount) AS [TotalAll]
		,sum(sm.totaldiscount) AS [DISCOUNT]
		,sum(sm.BasicAmount) AS Total
		,sum(isnull(b1.Amount, 0)) AS ServiceCharge
		,sum(isnull(b2.Amount, 0)) AS TaxCharge
		,sum(sm.NetAmount) AS NetAmount
	FROM RO_SalesMaster sm
	--LEFT JOIN UsedBillingTerm b1 ON B1.SalesMasterID = sm.salesMasterId
	--	AND b1.BillingTerm = 'Service Charge '
	--LEFT JOIN UsedBillingTerm b2 ON B2.SalesMasterID = sm.salesMasterId
		--AND b2.BillingTerm = 'VAT'
		 inner join RO_BillingAmount b1 on B1.SalesMasterID = sm.salesMasterId and b1.BilingID = 62    
 inner join RO_BillingAmount b2 on B2.SalesMasterID = sm.salesMasterId and b2.BilingID = 54
	WHERE (sm.BillDate between @startDate and @endDate)
	GROUP BY cast(sm.BillDate AS DATE)
		--,billNo
		,sm.fiscalyearid,sm.InvoiceNo
END
	--select * from RO_SalesMaster

	




GO
