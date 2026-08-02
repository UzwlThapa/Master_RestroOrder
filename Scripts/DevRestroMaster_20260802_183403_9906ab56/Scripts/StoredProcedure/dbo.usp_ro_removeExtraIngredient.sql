SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_removeExtraIngredient] @ExtraItemID INT
AS
BEGIN
	DELETE
	FROM RO_ExtraIngredient
	WHERE ExtraItemID = @ExtraItemID
END

GO
