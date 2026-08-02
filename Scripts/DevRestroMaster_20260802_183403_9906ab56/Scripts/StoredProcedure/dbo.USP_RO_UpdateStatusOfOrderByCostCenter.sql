SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[USP_RO_UpdateStatusOfOrderByCostCenter]96,2
CREATE PROCEDURE [dbo].[USP_RO_UpdateStatusOfOrderByCostCenter]
@ItemId INT,
@StatusID INT
AS
DECLARE @orderitemid INT
DECLARE @repeatedItem INT

SELECT @orderitemid = OrderDetailsID from dbo.RO_Order_Detail WHERE OrderDetailsID=@ItemId

UPDATE dbo.RO_OrderItemStatus SET StatusID=@StatusID WHERE  OrderDetailID=@orderitemid
--IF(@StatusID = 3)
--BEGIN
--UPDATE dbo.RO_OrderMasters SET IsRunningOrder = 1 WHERE 
----(SELECT StatusID FROM dbo.RO_OrderItemStatus WHERE OrderDetailID=@orderitemid)=3
--(SELECT @repeatedItem=(COUNT(order))
-- AND (SELECT BillPaid FROM dbo.RO_OrderMasters WHERE OrderMasterID =(SELECT OrderMasterID FROM dbo.RO_Order_Detail WHERE OrderDetailsID=@orderitemid )) != 1 
--AND OrderMasterID=(SELECT OrderMasterID FROM dbo.RO_Order_Detail WHERE OrderDetailsID=@orderitemid)
--END

--SELECT * FROM dbo.RO_OrderItemStatus
--SELECT * FROM dbo.RO_Order_Detail





GO
