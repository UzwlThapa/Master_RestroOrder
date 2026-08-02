SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ro_DeleteIngredientItemByID] @IngredientID INT
	,@ItemID INT
AS
DELETE Ro_Ingredient
WHERE ItemID = @ItemID
	AND Ingredient = @IngredientID



GO
