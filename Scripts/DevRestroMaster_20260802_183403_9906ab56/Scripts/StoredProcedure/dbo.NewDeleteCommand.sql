SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[NewDeleteCommand]
(
	@Original_OrderId int
)
AS
	SET NOCOUNT OFF;
DELETE FROM [tblPurchaseOrder] WHERE (([OrderId] = @Original_OrderId))

GO
