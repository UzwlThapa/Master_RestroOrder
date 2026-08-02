SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[NewUpdateCommand]
(
	@Quantity nvarchar(256),
	@ItemName nvarchar(256),
	@Original_OrderId int,
	@OrderId int
)
AS
	SET NOCOUNT OFF;
UPDATE [tblPurchaseOrder] SET [Quantity] = @Quantity, [ItemName] = @ItemName WHERE (([OrderId] = @Original_OrderId));
	
SELECT Quantity, ItemName, OrderId FROM tblPurchaseOrder WHERE (OrderId = @OrderId)

GO
