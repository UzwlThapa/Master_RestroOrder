SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- usp_getIngredientByID 31
CREATE PROCEDURE [dbo].[usp_getIngredientByID]
    @ItemID INT
AS
    SELECT ri.* ,
           im.ITName + ', ' + u1.Symbol AS ITName ,
           --(select im.ITName +', '+ u1.Symbol as ITName from ROI_ITEMMain im JOIN ROI_Unit1 u1 ON u1.Unit1Id =ri.SmallUnit
           ISNULL (( pd.UnitRate / CASE WHEN ISNULL (pd.Conversion, 1) = 0 THEN 1
                                        ELSE ISNULL (pd.Conversion, 1)
                                   END ) ,
                   0) AS Amount
    FROM   dbo.Ro_Ingredient ri
           JOIN dbo.ROI_ITEMMain im ON ri.Ingredient = im.ITId
           JOIN dbo.ROI_ItemDetails id ON id.ITId = ri.Ingredient
           JOIN dbo.ROI_Unit1 u1 ON u1.Unit1Id = id.SmallUnit
           LEFT JOIN dbo.ROI_PurchaseDetails pd ON  pd.ItemID = ri.Ingredient
                                                AND pd.PurchaseDetailsID = ( SELECT MAX (PurchaseDetailsID)
                                                                             FROM   dbo.ROI_PurchaseDetails
                                                                             WHERE  ItemID = ri.Ingredient )
    WHERE  ri.ItemID = @ItemID;

GO
