SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [usp_ro_getTargetSalesItem] '8/16/2017'
CREATE PROCEDURE [dbo].[usp_ro_getTargetSalesItem] @dates DATE
AS
BEGIN
	DECLARE @tbl TABLE (
		TopItem NVARCHAR(max)
		,Quantity INT
		,TotalPrice NVARCHAR(max)
		,CostCenterName NVARCHAR(max)
		,CostCenterId INT
		)
	DECLARE @CostCenter TABLE (costcenterid INT)

	INSERT INTO @CostCenter
	SELECT CostCenterId
	FROM CostCenterInfo

	INSERT INTO @tbl
	SELECT TopItem
		,Quantity
		,TotalPrice
		,CostCenterName
		,tab.CostCenterId
	FROM (
		SELECT IM.ITName AS TopItem
			,sum(sd.qty) AS Quantity
			,sum(sd.NetAmount) AS TotalPrice
			--,Id.ItemCostCentreID
			,cc.CostCenterName
			,cc.CostCenterId
		FROM RO_SalesMaster SM
		INNER JOIN RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
		INNER JOIN ROI_ITEMMain Im ON IM.ITId = SD.ItemId
		INNER JOIN ROI_ItemDetails Id ON Id.ITId = Im.ITId
		INNER JOIN CostCenterInfo cc ON Id.ItemCostCentreID = cc.CostCenterId
		WHERE CONVERT(DATE, SM.BillDate) = CONVERT(DATE, @dates)
		GROUP BY CAST(SM.BillDate AS DATE)
			,IM.ITName
			,Id.ItemCostCentreID
			,cc.CostCenterName
			,cc.CostCenterId
			--,sd.NetAmount,sd.qty
			--ORDER BY Quantity DESC
		) tab
	INNER JOIN (
		SELECT max(Quantity) AS QTY
			,max(TotalPrice) AS TP
			,CostCenterId
		FROM (
			SELECT IM.ITName AS TopItem
				,sum(sd.qty) AS Quantity
				,sum(sd.NetAmount) AS TotalPrice
				--,Id.ItemCostCentreID
				,cc.CostCenterName
				,cc.CostCenterId
			FROM RO_SalesMaster SM
			INNER JOIN RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
			INNER JOIN ROI_ITEMMain Im ON IM.ITId = SD.ItemId
			INNER JOIN ROI_ItemDetails Id ON Id.ITId = Im.ITId
			INNER JOIN CostCenterInfo cc ON Id.ItemCostCentreID = cc.CostCenterId
			WHERE CONVERT(DATE, SM.BillDate) = CONVERT(DATE, @dates)
			GROUP BY CAST(SM.BillDate AS DATE)
				,IM.ITName
				,Id.ItemCostCentreID
				,cc.CostCenterName
				,cc.CostCenterId
				--,sd.NetAmount,sd.qty
				--ORDER BY Quantity DESC
			) tab5
		GROUP BY CostCenterId
		) tab2 ON tab2.QTY = tab.Quantity
		AND tab2.CostCenterId = tab.CostCenterId
		AND tab2.TP = tab.TotalPrice

	--group by CostCenterId --,CostCenterName,TopItem,TotalPrice
	--where CostCenterId in (select costcenterid from @CostCenter)
	--order by ROW_NUMBER() OVER(PARTITION BY CostCenterId ORDER BY Quantity DESC)--order by Quantity desc
	SELECT *
	FROM @tbl
END






GO
