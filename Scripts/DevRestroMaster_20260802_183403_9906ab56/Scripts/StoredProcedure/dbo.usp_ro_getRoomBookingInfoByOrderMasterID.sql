SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_getRoomBookingInfoByOrderMasterID]
    @orderMasterId INT
AS
    BEGIN
        SELECT ISNULL (rb.RoomBookDetailsID, 0) AS RoomBookDetailsID ,
               rb.BookedFrom ,
               rb.BookedTo ,
               om.OrderMasterID ,
               rb.CustomerName ,
               om.TableId ,
               rb.PhoneNo ,
               rt.restrotableTitle ,
               ISNULL (rb.Rate, 0) AS Rate ,
               ISNULL (rb.BookedDays, 0) AS BookedDays ,
               rb.CustomerId ,
               ISNULL (rb.TotalAmount, 0) AS TotalAmount ,
               ISNULL (rb.AdvancePayment, 0) AS AdvancePayment ,
               om.BillNo ,
               CONVERT (VARCHAR (MAX), om.Date, 110) AS [Date] ,
               om.BasicAmount ,
               om.RoomId ,
               om.UserName AS Waiter ,
               ISNULL (lm.discount, 0) AS LoyaltyDiscount
        FROM   RO_OrderMasters om
               LEFT JOIN Ro_RoomBookings rb ON om.OrderMasterID = rb.OrderMasterId
               LEFT JOIN RO_restroTable rt ON rt.restrotableId = om.TableId
               LEFT JOIN RO_LoyaltyMembership lm ON lm.MembershipID = rb.CustomerId
        WHERE  om.OrderMasterID = @orderMasterId;
    END;



GO
