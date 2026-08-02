SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getItemIngreidentsList_bak] @costCenter INT
	,@ItemId INT
	,@Category INT
AS
BEGIN
	SELECT m.ITId AS ItemID
		,m.ITName AS ItemName
		,r.SRate AS MRP
		,ri.Ingredient as Ingredient 
		,isnull(ri.Quantity, 0) AS Quantity
		,isnull((im.ITName + ', ' + u2.Symbol + ' / ' + u1.Symbol), '-, ') AS IngredientName
		--,ISNULL((pd.UnitRate / isnull(pd.Conversion, 1)), 0) AS Amount
	    ,ISNULL((gd.Rate / isnull(pd.Conversion, 1)), 0) AS Amount
		,d.ImagePath
		,d.Details
	FROM ROI_ITEMMain m
	INNER JOIN ROI_ItemDetails d ON m.ITId = d.ITId
	INNER JOIN ROI_ItemRate r ON m.ITId = r.ItemID
	LEFT JOIN Ro_Ingredient ri ON ri.ItemID = m.ITId
	LEFT JOIN ROI_Unit1 u1 ON u1.Unit1Id = d.SmallUnit
	LEFT JOIN ROI_ITEMMain im ON ri.Ingredient = im.ITId
	INNER JOIN ROI_ItemDetails id ON  im.ITId = id.ITId
	LEFT JOIN ROI_Unit1 u2 ON u2.Unit1Id = id.SmallUnit
	LEFT JOIN ROI_PurchaseDetails pd ON pd.ItemID = ri.Ingredient
	LEFT JOIN RO_GoodsReceivedDetls gd ON pd.PurchaseDetailsID = gd.PDId
		AND pd.PurchaseDetailsID = (
			SELECT max(PurchaseDetailsID)
			FROM ROI_PurchaseDetails
			WHERE ItemID = ri.Ingredient
			)
	WHERE m.IsActive = 1
		AND m.IsArchived = 0
		AND d.IsProdMaterial = 0
	    AND m.IsCategory = 0
		AND (
			d.ItemCostCentreID = @costCenter
			OR @costCenter = 0
			)
		AND (
			m.ITId = @ItemId
			OR @ItemId = 0
			)

	  and (m.PITId =@Category 
	  OR @Category =0)
	  order by m.ITName
	  END


GO
