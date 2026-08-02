SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [usp_CostCenterwiseAllReport] '2018-05-01','2018-05-01',0
CREATE PROCEDURE [dbo].[usp_CostCenterwiseAllReport]
@startDate DATETIME,          
@endDate DATETIME,          
@CostCenter INT

AS
BEGIN
	SELECT
		im.ITName AS ItemName
		,SUM(sd.qty) AS Quantity
		,sd.rate AS Rate
		,SUM(sd.qty * sd.rate) AS Total
		,cc.CostCenterName AS CostCenterName
	FROM dbo.RO_SalesDetail sd
	INNER JOIN ROI_ITEMMain im ON im.ITId = sd.ItemId
	LEFT JOIN dbo.RO_SalesMaster sm ON sm.salesMasterId = sd.salesMasterId
	Inner join CBMS_BillPostLog bp on bp.SalesMasterId = sm.salesMasterId
	LEFT JOIN CostCenterInfo cc ON cc.CostCenterId = sd.CostCenterId
	WHERE (sd.CostCenterId=@CostCenter or @CostCenter=0)
	AND (sm.BillDate BETWEEN dateadd(hour,4, @startDate) AND dateadd(hour,4,  @endDate))
	and sm.IsArchived = 0 and sm.IsUpdated = 1
	GROUP BY ITName, rate, CostCenterName

	UNION

	SELECT
		im.ITName AS ItemName
		,SUM(sd.Quantity) AS Quantity
		,sd.rate AS Rate
		,SUM(sd.Quantity * sd.rate) AS Total
		,cc.CostCenterName AS CostCenterName
	FROM dbo.RO_CakeSalesDetail sd
	INNER JOIN ROI_ITEMMain im ON im.ITId = sd.ItemId
	LEFT JOIN dbo.RO_CakeSalesMaster sm ON sm.salesMasterId = sd.salesMasterId
	--Inner join CBMS_BillPostLog bp on bp.SalesMasterId = sm.salesMasterId
	LEFT JOIN CostCenterInfo cc ON cc.CostCenterId = sd.CostCenterId
	WHERE (sd.CostCenterId=@CostCenter or @CostCenter=0)
	AND (sm.BillDate BETWEEN dateadd(hour,4, @startDate) AND dateadd(hour,4,  @endDate))
	and sm.IsArchived = 0 and sm.IsUpdated = 1
	GROUP BY ITName, rate, CostCenterName
END

GO
