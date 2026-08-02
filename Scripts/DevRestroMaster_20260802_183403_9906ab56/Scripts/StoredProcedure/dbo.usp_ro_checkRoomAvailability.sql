SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ro_checkRoomAvailability] @startDate DATETIME
	,@endDate DATETIME
	,@roombookDetailId INT
	,@TableId INT
AS
BEGIN
	SELECT COUNT(*)
	FROM Ro_RoomBookings rb
	INNER JOIN RO_OrderMasters om ON rb.OrderMasterId = om.OrderMasterID
	WHERE rb.TableId = @TableId
		AND om.IsCancelled != 1
		AND om.BillPaid != 1
		AND rb.BookedFrom <= @endDate
		AND @startDate <= rb.BookedTo
		and rb.RoomBookDetailsID != @roombookDetailId
END



GO
