SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP PROC [dbo].[usp_ro_getOccupiedRooms]
CREATE PROCEDURE [dbo].[usp_ro_getOccupiedRooms]
AS
BEGIN

    IF (OBJECT_ID('tempdb..#tempRoomOrderDetail') IS NOT NULL)
        DROP TABLE #tempRoomOrderDetail;

    -- Create a temporary table to hold order totals for each room booking
    SELECT rb.RoomBookDetailsID,
           rb.OrderMasterId,
           ISNULL(SUM(od.Quantity * od.Rate), 0) AS OrderTotalAmount
    INTO #tempRoomOrderDetail
    FROM dbo.Ro_RoomBookings rb
        INNER JOIN dbo.RO_OrderMasters om
            ON om.OrderMasterID = rb.OrderMasterId
        LEFT JOIN dbo.RO_Order_Detail od
            ON od.OrderMasterId = rb.OrderMasterId
        INNER JOIN dbo.RO_restroTable rt
            ON rt.restrotableId = rb.TableId
        INNER JOIN dbo.RO_RestroRoom rr
            ON rr.restroRoomId = rt.restroRoomId
    WHERE om.BillPaid <> 1
          AND om.IsCancelled <> 1
    GROUP BY rb.RoomBookDetailsID,
             rb.OrderMasterId;

    -- Select detailed room booking information including the aggregated order totals
    SELECT rb.RoomBookDetailsID,
           --CONVERT(DATETIME, rb.BookedFrom, 101) + ' ' + CONVERT(DATETIME, rb.BookedFrom, 108) AS BookedFrom,
           --CONVERT(DATETIME, rb.BookedTo, 101) + ' ' + CONVERT(DATETIME, rb.BookedTo, 108) AS BookedTo,
		   FORMAT(rb.BookedFrom, 'MM/dd/yyyy HH:mm:ss') AS BookedFrom,
		   FORMAT(rb.BookedTo, 'MM/dd/yyyy HH:mm:ss') AS BookedTo,
           rb.OrderMasterId,
           rb.CustomerName,
           rb.CustomerId,
           rb.TableId,
           rt.restrotableTitle,
           rr.restroRoom AS RestroRoom,
           rb.PhoneNo,
           rb.EmailAddress,
           rb.CtznNo,
           rb.BookedDays,
           rb.Rate,
           rb.TotalAmount + ISNULL(rod.OrderTotalAmount, 0) AS TotalAmount,
           rb.AdvancePayment,
           ISNULL(om.GuestNo, 1) AS GuestNo,
           rb.Remarks,
           ap.PaymentModeID,
           cd.ProviderName,
           ap.TransactionNo,
           pm.PaymentMode
    FROM dbo.Ro_RoomBookings rb
        INNER JOIN dbo.RO_OrderMasters om
            ON om.OrderMasterID = rb.OrderMasterId
        INNER JOIN dbo.RO_restroTable rt
            ON rt.restrotableId = rb.TableId
        INNER JOIN dbo.RO_RestroRoom rr
            ON rr.restroRoomId = rt.restroRoomId
        LEFT JOIN #tempRoomOrderDetail rod
            ON rod.RoomBookDetailsID = rb.RoomBookDetailsID
               AND om.OrderMasterID = rod.OrderMasterId
        LEFT JOIN dbo.RO_AdvancePaymentMode ap
            ON ap.RoomBookDetailsId = rb.RoomBookDetailsID
        LEFT JOIN dbo.RO_CardProvider cd
            ON cd.ProviderID = ap.ProviderID
        LEFT JOIN dbo.RO_PaymentModes pm
            ON pm.PaymentModeID = ap.PaymentModeID
    WHERE om.BillPaid <> 1
          AND om.IsCancelled <> 1
    ORDER BY rb.BookedFrom,
             ap.PaymentModeID;

END;

GO
