SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[USP_RO_GetRoomListByRoomTypeId] 17
--DROP PROC [dbo].[USP_RO_GetRoomListByRoomTypeId]
CREATE PROCEDURE [dbo].[USP_RO_GetRoomListByRoomTypeId]
@RoomTypeID int
AS
BEGIN
	select * FROM RO_RestroRoom rr
	INNER JOIN dbo.Ro_RoomType rt ON rt.RoomTypeID = rr.RoomTypeID 
	 WHERE rt.RoomTypeID = @RoomTypeID
	order by restroRoom 
--	 dbo.RO_OrderItemStatus ois

--	--INNER JOIN dbo.RO_OrderMasters om ON om.RoomId = rm.restroRoomId
--	--INNER JOIN dbo.Ro_RoomType rt ON rt.RoomTypeID = rm.RoomTypeID
--	INNER JOIN dbo.RO_OrderItemStatus os ON os.OrderItemStatusID = ois.OrderItemStatusID
--	INNER JOIN dbo.RO_Order_Detail od ON os.OrderDetailID=od.OrderDetailsID
--	INNER JOIN dbo.RO_OrderMasters om ON om.OrderMasterID = od.OrderMasterId 
--	INNER JOIN RO_RestroRoom rm ON  om.RoomId = rm.restroRoomId
--	WHERE rm.RoomTypeID=@RoomTypeID
END







GO
