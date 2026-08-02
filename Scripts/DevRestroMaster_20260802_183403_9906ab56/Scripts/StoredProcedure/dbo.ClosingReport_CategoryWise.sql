SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[ClosingReport_CategoryWise]   '2017-07-03'
CREATE PROCEDURE [dbo].[ClosingReport_CategoryWise] @DATE DATE
AS
BEGIN
declare @startDate datetime,@endDate datetime
	set @startDate = dateadd(hour,4,cast(@DATE as datetime))
	set @endDate = dateadd(day,1,@startDate)
	--DECLARE @DATE DATE = '2017-07-03'
	SELECT DISTINCT im2.ITName
		,cci.CostCenterName
		,sum(sd.qty) AS QTY
		,u.Symbol
		,sum(sd.rate) Rate
		--,sum(sd.rate * sd.qty) Amount
	FROM RO_SalesMaster sm
	INNER JOIN RO_SalesDetail sd ON sm.salesMasterId = sd.salesMasterId
	INNER JOIN ROI_ITEMMain im ON im.ITId = sd.ItemId
	JOIN ROI_ITEMMain im2 ON im.pitid = im2.itid
	INNER JOIN ROI_ItemDetails itd ON itd.ITId = im.ITId
	INNER JOIN ROI_Unit1 u ON u.Unit1Id = itd.SmallUnit
	INNER JOIN CostCenterInfo cci ON sd.CostCenterId = cci.CostCenterId
	WHERE (sm.BillDate between @startDate and @endDate)
		AND sd.IsCombo = 0
	GROUP BY im2.ITName
		,cci.CostCenterName
		,u.Symbol
	
	UNION
	
	SELECT im.NAME ITName
		,cci.CostCenterName
		,sum(sd.qty) AS QTY
		,'Combo' Symbol
		,sum(im.salesprice)
	FROM RO_SalesMaster sm
	INNER JOIN RO_SalesDetail sd ON sm.salesMasterId = sd.salesMasterId
	INNER JOIN RO_Combo im ON im.ComboID = sd.ItemId
	INNER JOIN CostCenterInfo cci ON sd.CostCenterId = cci.CostCenterId
	WHERE cast(sm.BillDate AS DATE) = CAST(@DATE AS DATE)
		AND sd.IsCombo = 1
	GROUP BY im.NAME
		,cci.CostCenterName
	ORDER BY cci.CostCenterName
END




GO
