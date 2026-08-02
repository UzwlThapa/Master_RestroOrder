SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateStatusOfOrderByCostCenter]
@ItemId INT,
@StatusID INT
AS
DECLARE @orderitemid INT

SELECT @orderitemid =OrderDetailsID from dbo.RO_Order_Detail WHERE ItemId=@ItemId

UPDATE dbo.RO_OrderItemStatus SET StatusID=@StatusID WHERE  OrderDetailID=@orderitemid







GO
