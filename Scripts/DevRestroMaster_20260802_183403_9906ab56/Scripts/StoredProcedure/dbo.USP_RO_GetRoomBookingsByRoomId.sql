SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_GetRoomBookingsByRoomId] @TableId INT
AS
BEGIN
	SELECT rb.*
		,rt.restrotableTitle
	FROM Ro_RoomBookings rb
	INNER JOIN RO_OrderMasters om ON rb.OrderMasterId = om.OrderMasterID
	INNER JOIN RO_restroTable rt ON rt.restrotableId = rb.TableId
	WHERE rb.TableId = @TableId
		AND rb.BookedTo > GETDATE()
		AND (
			om.BillPaid != 1
			AND om.IsCancelled != 1
			)
	ORDER BY rb.BookedFrom
END
-----------------------------------------------------------------------------



GO
