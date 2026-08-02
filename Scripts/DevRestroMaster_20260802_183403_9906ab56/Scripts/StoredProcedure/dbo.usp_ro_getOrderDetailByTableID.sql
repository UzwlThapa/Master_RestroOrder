SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ro_getOrderDetailByTableID] @TableID INT
AS
BEGIN

    DECLARE @OrderMasterID INT = 0;


    SELECT TOP (1)
           @OrderMasterID = OrderMasterID
    FROM dbo.RO_OrderMasters
    WHERE TableId = @TableID
          AND IsCancelled = 0
          AND BillPaid = 0
          AND OrderStatus = 0
    ORDER BY OrderMasterID DESC;


    SELECT od.ROI_ItemId AS ItemID,
           id.ITName AS Item,
           od.Quantity,
           om.UserName AS OrderBy,
           od.IsCombo,
           ois.StatusID AS OrderStatus
    FROM RO_Order_Detail od
        INNER JOIN RO_OrderMasters om
            ON om.OrderMasterID = od.OrderMasterId
        INNER JOIN ROI_ITEMMain id
            ON id.ITId = od.ROI_ItemId
        INNER JOIN RO_OrderItemStatus ois
            ON ois.OrderDetailID = od.OrderDetailsID
    WHERE od.OrderMasterId = @OrderMasterID
          AND od.IsCombo = 0
          AND od.IsCancelled = 0
    UNION
    SELECT od.ROI_ItemId AS ItemID,
           rc.Name AS Item,
           od.Quantity,
           om.UserName AS OrderBy,
           od.IsCombo,
           ois.StatusID AS OrderStatus
    FROM RO_Order_Detail od
        INNER JOIN RO_OrderMasters om
            ON om.OrderMasterID = od.OrderMasterId
        INNER JOIN RO_Combo rc
            ON rc.ComboID = od.ROI_ItemId
        INNER JOIN RO_OrderItemStatus ois
            ON ois.OrderDetailID = od.OrderDetailsID
    WHERE od.OrderMasterId = @OrderMasterID
          AND od.IsCombo = 1
          AND od.IsCancelled = 0;
END;



GO
