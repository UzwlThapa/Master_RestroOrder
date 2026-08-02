SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[ClosingReport_StateWise] '2017-07-03'

CREATE PROCEDURE [dbo].[ClosingReport_StateWise] @DATE DATE
AS
BEGIN
	--DECLARE @DATE DATE = '2017-07-03'
	declare @startDate datetime,@endDate datetime
	set @startDate = dateadd(hour,4,cast(@DATE as datetime))
	set @endDate = dateadd(day,1,@startDate)

	SELECT 'Food' ITName
		,isnull(sum(amount),0) Amount
		,1 [level]
	FROM RO_SalesMaster sm
	INNER JOIN RO_SalesDetail sd ON sm.salesMasterId = sd.salesMasterId
	INNER JOIN CostCenterInfo cci ON sd.CostCenterId = cci.CostCenterId
	WHERE (sm.BillDate between @startDate and @endDate)
		AND sd.IsCombo = 0
		AND (
			sd.CostCenterId = 1
			OR sd.CostCenterId = 95
			OR sd.CostCenterId = 97
			)
	
	UNION
	
	SELECT 'Beverage' Title
		,isnull(sum(amount),0) Amount
		,2 [level]
	FROM RO_SalesMaster sm
	INNER JOIN RO_SalesDetail sd ON sm.salesMasterId = sd.salesMasterId
	INNER JOIN CostCenterInfo cci ON sd.CostCenterId = cci.CostCenterId
	WHERE (sm.BillDate between @startDate and @endDate)
		AND sd.IsCombo = 0
		AND (sd.CostCenterId = 2)
		order by [level] asc
END




GO
