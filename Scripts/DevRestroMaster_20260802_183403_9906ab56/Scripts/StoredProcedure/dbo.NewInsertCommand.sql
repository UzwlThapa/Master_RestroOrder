SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[NewInsertCommand]
(
	@Quantity nvarchar(256),
	@ItemName nvarchar(256)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [tblPurchaseOrder] ([Quantity], [ItemName]) VALUES (@Quantity, @ItemName);
	
SELECT Quantity, ItemName, OrderId FROM tblPurchaseOrder WHERE (OrderId = SCOPE_IDENTITY())

GO
