SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_CostCenterwiseDailyReport]
@startDate DATETIME,
@endDate DATETIME,
@costCenter INT

AS
BEGIN
	SELECT
		CAST(sm.BillDate AS DATE) AS BillDate
		,cc.CostCenterName AS CostCenterName
		,SUM(sd.qty * sd.rate) AS Total
	FROM dbo.RO_SalesMaster sm
	Inner join CBMS_BillPostLog bp on bp.SalesMasterId = sm.salesMasterId
	INNER JOIN dbo.RO_SalesDetail sd ON sd.salesMasterId = sm.salesMasterId
	LEFT JOIN CostCenterInfo cc ON cc.CostCenterId = sd.CostCenterId
	WHERE (sd.CostCenterId=@CostCenter or @CostCenter=0)
	AND (sm.BillDate BETWEEN dateadd(hour,4,@startDate) AND dateadd(hour,4,@endDate))
	and sm.IsArchived=0 and sm.IsUpdated=1
	GROUP BY CAST(BillDate AS DATE), CostCenterName
	
	UNION

	SELECT
		CAST(sm.BillDate AS DATE) AS BillDate
		,cc.CostCenterName AS CostCenterName
		,SUM(sd.Quantity * sd.rate) AS Total
	FROM dbo.RO_CakeSalesMaster sm
	--Inner join CBMS_BillPostLog bp on bp.SalesMasterId = sm.salesMasterId
	INNER JOIN dbo.RO_CakeSalesDetail sd ON sd.salesMasterId = sm.salesMasterId
	LEFT JOIN CostCenterInfo cc ON cc.CostCenterId = sd.CostCenterId
	WHERE (sd.CostCenterId=@CostCenter or @CostCenter=0)
	AND (sm.BillDate BETWEEN dateadd(hour,4,@startDate) AND dateadd(hour,4,@endDate))
	and sm.IsArchived=0 and sm.IsUpdated=1
	GROUP BY CAST(BillDate AS DATE), CostCenterName
END

GO
