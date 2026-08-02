SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext usp_ro_itemsalesreport '2017-02-01 00:00','2017-04-03 23:59'
CREATE PROCEDURE [dbo].[usp_ro_getSalesDetailsByDate] @date DATETIME
	--@Start DATETIME = '2017-01-02', @End DATETIME  = '2017-01-31'
AS
BEGIN
	SELECT CAST(SM.BillDate AS DATE) AS BillDate
		,CCI.CostCenterName
		,IM.ITName
		,sum(sd.qty) AS QTY
		,sd.rate
		--,sum(sd.Amount)  Amount
		,sum(sd.qty * sd.rate) NetAmount
		,SD.IsCombo
	FROM RO_SalesMaster SM
	INNER JOIN RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
	INNER JOIN ROI_ITEMMain Im ON IM.ITId = SD.ItemId
	LEFT JOIN CostCenterInfo CCI ON CCI.CostCenterId = sd.CostCenterId
	WHERE IsCombo = 0
		AND CONVERT(DATE, SM.BillDate) = CONVERT(DATE, @date)
	--AND (SM.BillDate >= @Start AND SM.BillDate <= @End)
	GROUP BY CAST(SM.BillDate AS DATE)
		,CCI.CostCenterName
		,IM.ITName
		,sd.rate
		,SD.IsCombo
	
	UNION
	
	SELECT CAST(SM.BillDate AS DATE) AS BillDate
		,CCI.CostCenterName
		,IM.NAME
		,sum(sd.qty) AS QTY
		,sd.rate
		--,sum(sd.Amount)  Amount
		,sum(sd.qty * sd.rate) NetAmount
		,SD.IsCombo
	FROM RO_SalesMaster SM
	INNER JOIN RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
	INNER JOIN RO_Combo Im ON IM.ComboID = SD.ItemId
	LEFT JOIN CostCenterInfo CCI ON CCI.CostCenterId = sd.CostCenterId
	WHERE IsCombo = 1
		AND CONVERT(DATE, SM.BillDate) = CONVERT(DATE, @date)
	--AND (SM.BillDate >= @Start AND SM.BillDate <= @End)
	GROUP BY CAST(SM.BillDate AS DATE)
		,CCI.CostCenterName
		,IM.NAME
		,sd.rate
		,SD.IsCombo
END




GO
