SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP proc USP_RO_GetTakeAwayOrders
CREATE PROCEDURE [dbo].[USP_RO_GetTakeAwayOrders]
AS
    SELECT   om.[OrderMasterID] AS OrderMasterId ,
             om.[Date] AS tableDate ,
             ISNULL (om.GuestNo, 1) AS GuestNo ,
             ISNULL (om.OrderNo, 0) AS OrderNo ,
             ISNULL (ot.TokenNo, 0) AS TokenNo ,
             om.BasicAmount AS Amount
    FROM     dbo.RO_OrderMasters om
             LEFT JOIN dbo.RO_OrderToken ot ON om.OrderMasterID = ot.OrderMasterID
    WHERE    ISNULL (om.TableId, 0) = 0
    AND      ISNULL (om.BillPaid, 0) = 0
    AND      ISNULL (om.IsCancelled, 0) = 0
    AND      ISNULL (om.OrderTypeID, 0) <> 1
    AND      ISNULL (om.OrderTypeID, 0) <> 4
    ORDER BY om.Date DESC;

GO
