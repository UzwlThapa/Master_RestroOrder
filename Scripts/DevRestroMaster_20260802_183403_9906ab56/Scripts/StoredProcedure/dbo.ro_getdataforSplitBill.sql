SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ro_getdataforSplitBill]
@tableId INT
--@OrdermasterId INT
AS
begin
SELECT dbo.RO_Items.ItemName,
od.Quantity,
od.Rate,
od.Amount,
od.SeatNo
 FROM dbo.RO_Order_Detail od
JOIN dbo.RO_OrderMasters om ON om.OrderMasterID = od.OrderMasterId
JOIN dbo.RO_Items ON RO_Items.ItemID = od.ItemId
WHERE om.TableId=@tableId AND om.BillPaid=0 AND om.IsSplit=1 and om.IsCancelled =0 and od.Quantity != 0 and od.IsCancelled = 0 
GROUP BY od.SeatNo,ro_items.ItemName,od.Quantity,od.Rate,od.Amount
--AND od.OrderMasterId=@OrdermasterId
END	







GO
