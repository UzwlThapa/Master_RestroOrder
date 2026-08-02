SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_extraitemforitemsave] @ItemID INT
	,@ExtraItemID INT
AS
BEGIN
	INSERT INTO Roi_ExtraItemForItem (
		ItemID
		,ExtraItemID
		)
	VALUES (
		@ItemID
		,@ExtraItemID
		)
END

GO
