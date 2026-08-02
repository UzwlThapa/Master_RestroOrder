SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GETAllORDER]

AS
BEGIN

	select * FROM dbo.RO_OrderMasters om
	left JOIN dbo.RO_restroTable rt ON rt.restrotableId= om.TableId
	left JOIN dbo.RO_RestroRoom rm ON rm.restroRoomId =  rt.restroRoomId
	 where om.RoomId != 0 or om.TableId !=0 --and CAST(om.Date AS DATE) = CAST(GETDATE() AS DATE)
	 ORDER BY om.Date asc 
end



--select * FROM dbo.RO_OrderMasters om
-- * FROM dbo.RO_restroTable om
--select * FROM dbo.RO_RestroRoom om
--select * from dbo.RO_OrderMasters inner join RO_RestroRoom on  RO_OrderMasters.RoomId = RO_RestroRoom.restroRoomId






GO
