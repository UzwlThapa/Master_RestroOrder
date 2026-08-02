SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_getTableInfo] @TableId INT
AS
BEGIN
	SELECT rt.*
		,isnull((
				SELECT rb.OrderMasterId
				FROM Ro_RoomBookings rb
				INNER JOIN RO_OrderMasters om ON om.OrderMasterID = rb.OrderMasterId
				WHERE rb.BookedFrom <= GETDATE()
					AND rb.BookedTo >= GETDATE()
					AND rb.TableId = rt.restrotableId
					AND om.BillPaid != 1
					AND om.IsCancelled != 1
				), 0) AS OrderMasterId
	FROM RO_restroTable rt
	WHERE rt.restrotableId = @TableId
END



GO
