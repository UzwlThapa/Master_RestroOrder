SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_getRoomBookingInfoyBillNo]
 @BillNo nvarchar(128)
AS
BEGIN
	SELECT ISNULL(rb.RoomBookDetailsID, 0) AS RoomBookDetailsID
		,rb.BookedFrom
		,rb.BookedTo
		,om.OrderMasterId
		,rb.CustomerName
		,om.TableId
		,rt.restrotableTitle
		,ISNULL(rb.Rate, 0) AS Rate
		,ISNULL(rb.BookedDays, 0) AS BookedDays
		,rb.CustomerId
		,ISNULL(rb.TotalAmount, 0) AS TotalAmount
		,ISNULL(rb.AdvancePayment, 0) AS AdvancePayment
		,om.BillNo
		,om.Date
		,om.BasicAmount
		,om.RoomId
		,om.OrderMasterID
		,om.UserName AS Waiter
		,ISNULL(lm.discount, 0) as LoyaltyDiscount
	FROM RO_OrderMasters om
	LEFT JOIN Ro_RoomBookings rb ON om.OrderMasterID = rb.OrderMasterId
	INNER JOIN RO_restroTable rt ON rt.restrotableId = om.TableId
	left join RO_LoyaltyMembership lm on lm.MembershipID = rb.CustomerId
	WHERE om.BillNo = @BillNo
END



GO
