SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GetTableByRoomTypeId_backup] @RoomTypeId INT
AS
BEGIN
	--select rt.*,rr.restroRoom, mt.*, (select restrotableTitle from RO_restroTable rt where rt.restrotableId = mt.MergeTableList) as MergeTableName FROM dbo.RO_restroTable rt
	--INNER JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId = rt.restroRoomId
	--Inner join dbo.RO_MergeTable mt on mt.TableID = rt.restrotableId
	-- WHERE rt.restroRoomId = @RoomTypeId
	-- BY Avinash -------
	SELECT rt.*
		,(
			SELECT TOP 1 convert(CHAR(5), om.DATE, 108) [time]
			FROM RO_OrderMasters om
			INNER JOIN RO_Order_Detail od ON om.OrderMasterID = od.OrderMasterId
			WHERE om.TableId = rt.restrotableId
				AND om.BillPaid = 0
			ORDER BY om.OrderMasterID DESC
			) AS tabletime
		,(
			SELECT TOP 1 om.DATE
			FROM RO_OrderMasters om
			INNER JOIN RO_Order_Detail od ON om.OrderMasterID = od.OrderMasterId
			WHERE om.TableId = rt.restrotableId
				AND om.BillPaid = 0
			ORDER BY om.OrderMasterID DESC
			) AS tabledate
		,(
			SELECT TOP 1 om.BillPaid
			FROM RO_OrderMasters om
			INNER JOIN RO_Order_Detail od ON om.OrderMasterID = od.OrderMasterId
			WHERE om.TableId = rt.restrotableId
			ORDER BY om.OrderMasterID DESC
			) AS BillPaid
		,(
			SELECT TOP 1 om.IsCancelled
			FROM RO_OrderMasters om
			WHERE om.TableId = rt.restrotableId
			ORDER BY OrderMasterID DESC
			) AS IsCancelled
		,rr.restroRoom
		,mt.MergeID
		,mt.TableID
		,isnull(mt.MergeTableList, 0) AS MergeTableList
		,(
			SELECT restrotableTitle
			FROM RO_restroTable rt
			WHERE rt.restrotableId = mt.MergeTableList
			) AS MergeTableName
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
	FROM dbo.RO_restroTable rt
	INNER JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId = rt.restroRoomId
	LEFT JOIN dbo.RO_MergeTable mt ON mt.TableID = rt.restrotableId
	WHERE rt.restroRoomId = @RoomTypeId
END
	--SELECT  BillPaid from RO_OrderMasters order by TableId desc
	--SELECT * FROM dbo. 
	--.
	--SELECT TOP 1 * FROM RO_OrderMasters  WHERE TableId = 71
	--ORDER BY OrderMasterID DESC



GO
