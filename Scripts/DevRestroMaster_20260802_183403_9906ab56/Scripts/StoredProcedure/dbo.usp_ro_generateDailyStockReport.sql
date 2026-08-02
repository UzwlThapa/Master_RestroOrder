SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ro_generateDailyStockReport] @date DATE
	,@viewOnly BIT
AS
BEGIN
	IF (@viewOnly = 0)
	BEGIN
		DECLARE @PreviousClosedTS DATETIME
			,@CurrentClosedTS DATETIME

		SET @PreviousClosedTS = (
				SELECT max(ClosedTS)
				FROM DailyFinancialReport
				WHERE Period < @date
				)
		SET @CurrentClosedTS = (
				SELECT ClosedTS
				FROM DailyFinancialReport
				WHERE Period = @date
				)

		---- Previous Purchases
		DECLARE @purchaseTbl TABLE (
			IngId INT
			,PurchaseQnty DECIMAL(18, 2)
			,IngredientName NVARCHAR(max)
			,Symbol NVARCHAR(max)
			)

		INSERT INTO @purchaseTbl
		SELECT pd.itemid AS IngId
			,sum(pd.quentity * pd.conversion) AS PurchaseQnty
			,im.ITName AS IngredientName
			,ru.Symbol
		FROM ROI_PurchaseDetails pd
		INNER JOIN ROI_PurchaseMain pm ON pd.PurchaseMainID = pm.PurchaseMainID
		INNER JOIN ROI_ITEMMain im ON im.ITId = pd.ItemID
		INNER JOIN ROI_ItemDetails id ON id.ITId = im.ITId
		LEFT JOIN ROI_Unit1 ru ON ru.Unit1Id = id.SmallUnit
		WHERE pm.PbDate < @PreviousClosedTS
				OR @PreviousClosedTS is null
		GROUP BY pd.itemid
			,im.ITName
			,ru.Symbol

		------- Today Purchases
		DECLARE @todayPurchaseTbl TABLE (
			IngId INT
			,PurchaseQnty DECIMAL(18, 2)
			,IngredientName NVARCHAR(max)
			,Symbol NVARCHAR(max)
			)

		INSERT INTO @todayPurchaseTbl
		SELECT pd.itemid AS IngId
			,sum(pd.quentity * pd.conversion) AS PurchaseQnty
			,im.ITName AS IngredientName
			,ru.Symbol
		FROM ROI_PurchaseDetails pd
		INNER JOIN ROI_PurchaseMain pm ON pd.PurchaseMainID = pm.PurchaseMainID
		INNER JOIN ROI_ITEMMain im ON im.ITId = pd.ItemID
		INNER JOIN ROI_ItemDetails id ON id.ITId = im.ITId
		LEFT JOIN ROI_Unit1 ru ON ru.Unit1Id = id.SmallUnit
		WHERE (
				pm.PbDate BETWEEN @PreviousClosedTS
					AND @CurrentClosedTS
				OR @PreviousClosedTS is null
				)
		GROUP BY pd.itemid
			,im.ITName
			,ru.Symbol

		---- Previous  Consumption
		DECLARE @consumedTbl TABLE (
			ItemQnty DECIMAL(18, 2)
			,IngredientId INT
			,IngredientName NVARCHAR(max)
			,IngredientQnty DECIMAL(18, 2)
			)

		INSERT INTO @consumedTbl
		SELECT DISTINCT sum(sd.qty) AS ItemQnty
			,IM.ITId AS IngredientId
			,IM.ITName IngredientName
			,sum(ing.Quantity) AS IngredientQnty
		FROM RO_SalesDetail sd
		INNER JOIN Ro_Ingredient ing ON ing.ItemID = sd.ItemId
		INNER JOIN ROI_ITEMMain IM ON IM.ITId = ing.Ingredient
		INNER JOIN RO_SalesMaster sm ON sd.salesMasterId = sm.salesMasterId
		inner join CBMS_BillPostLog cb on cb.SalesMasterId = sm.salesMasterId
		WHERE sm.IsArchived = 0
			AND (sm.BillDate < @PreviousClosedTS
				OR @PreviousClosedTS is null)
		GROUP BY IM.ITName
			,IM.ITId

		---- Today  Consumption
		DECLARE @todayConsumedTbl TABLE (
			ItemQnty DECIMAL(18, 2)
			,IngredientId INT
			,IngredientName NVARCHAR(max)
			,IngredientQnty DECIMAL(18, 2)
			)

		INSERT INTO @todayConsumedTbl
		SELECT DISTINCT sum(sd.qty) AS ItemQnty
			,IM.ITId AS IngredientId
			,IM.ITName IngredientName
			,sum(ing.Quantity) AS IngredientQnty
		FROM RO_SalesDetail sd
		INNER JOIN Ro_Ingredient ing ON ing.ItemID = sd.ItemId
		INNER JOIN ROI_ITEMMain IM ON IM.ITId = ing.Ingredient
		INNER JOIN RO_SalesMaster sm ON sd.salesMasterId = sm.salesMasterId
		inner join CBMS_BillPostLog cb on cb.SalesMasterId = sm.salesMasterId
		WHERE sm.IsArchived = 0
			AND (
				sm.BillDate BETWEEN @PreviousClosedTS
					AND @CurrentClosedTS
				OR @PreviousClosedTS is null
				)
		GROUP BY IM.ITName
			,IM.ITId

		--- deleting previously generated data
		DELETE
		FROM DailyStockReport
		WHERE Period = cast(@date AS DATE)

		--- Stock report
		INSERT INTO DailyStockReport
		SELECT cast(@date AS DATE) AS Period
			,im.ITId AS ItemID
			,im.ITName AS ItemName
			,(isnull(pt.PurchaseQnty, 0) - (isnull(ct.IngredientQnty, 0) * isnull(ct.ItemQnty, 0))) AS OpeningBalance
			,isnull(tpt.PurchaseQnty, 0) AS PurchaseBalance
			,(isnull(tct.IngredientQnty, 0) * isnull(tct.ItemQnty, 0)) AS ConsumedBalance
			,((isnull(pt.PurchaseQnty, 0) - (isnull(ct.IngredientQnty, 0) * isnull(ct.ItemQnty, 0))) + isnull(tpt.PurchaseQnty, 0) - (isnull(tct.IngredientQnty, 0) * isnull(tct.ItemQnty, 0))) AS ClosingBalance
			,ru.Symbol
		FROM ROI_ItemDetails ID
		INNER JOIN ROI_ITEMMain im ON im.ITId = id.ITId
		LEFT JOIN @consumedTbl ct ON ID.ITId = ct.IngredientId
		LEFT JOIN ROI_Unit1 ru ON ru.Unit1Id = ID.SmallUnit
		LEFT JOIN @purchaseTbl pt ON pt.IngId = ct.IngredientId
		LEFT JOIN @todayPurchaseTbl tpt ON tpt.IngId = ct.IngredientId
		LEFT JOIN @todayConsumedTbl tct ON tct.IngredientId = ct.IngredientId
		WHERE id.IsProdMaterial = 1
			AND im.IsCategory = 0
		GROUP BY ct.IngredientId
			,ct.IngredientQnty
			,tct.IngredientQnty
			,ct.ItemQnty
			,tct.ItemQnty
			,im.ITName
			,im.ITId
			,ru.Symbol
			,pt.PurchaseQnty
			,tpt.PurchaseQnty
		ORDER BY im.ITId
	END

	SELECT dsr.ItemID
		,dsr.ItemName
		,dsr.OpeningBalance
		,dsr.PurchaseBalance
		,dsr.ConsumedBalance
		,dsr.ClosingBalance
		,dsr.Symbol
	FROM DailyStockReport dsr
	WHERE dsr.Period = cast(@date AS DATE)
END


GO
