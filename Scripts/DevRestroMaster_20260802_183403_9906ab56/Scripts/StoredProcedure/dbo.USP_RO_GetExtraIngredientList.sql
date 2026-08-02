SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GetExtraIngredientList]
AS
BEGIN
	SELECT ri.ExtraItemID AS ItemID
		,ri.IngredientID
		,ri.IngredientID AS Ingredient
		,ri.Quantity
		,im.ITName + ', ' + u1.Symbol AS ITName
	FROM RO_ExtraIngredient ri
	JOIN ROI_ITEMMain im ON ri.ingredientid = im.ITId
	JOIN ROI_ItemDetails id ON id.ITId = ri.ingredientid
	JOIN ROI_Unit1 u1 ON u1.Unit1Id = id.SmallUnit
END


GO
