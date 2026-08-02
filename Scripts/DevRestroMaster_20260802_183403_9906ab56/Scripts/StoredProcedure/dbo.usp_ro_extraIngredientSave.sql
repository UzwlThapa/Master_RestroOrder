SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_extraIngredientSave] @ExtraItemID INT
	,@IngredientID INT
	,@Quantity DECIMAL(10, 2)
AS
BEGIN
	INSERT INTO RO_ExtraIngredient (
		ExtraItemID
		,IngredientID
		,Quantity
		)
	VALUES (
		@ExtraItemID
		,@IngredientID
		,@Quantity
		)
END


GO
