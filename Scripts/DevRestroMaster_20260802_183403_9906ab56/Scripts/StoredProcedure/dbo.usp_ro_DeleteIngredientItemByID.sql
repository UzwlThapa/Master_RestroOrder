SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ro_DeleteIngredientItemByID]
@IngredientID int,
@ItemID int

AS
BEGIN
	DELETE FROM [dbo].[Ro_Ingredient]
	WHERE Ingredient = @IngredientID AND ItemID = @ItemID
END

GO
