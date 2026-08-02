SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_GETAllPICKORDER]

AS
BEGIN

	select * FROM dbo.RO_OrderMasters om
	left JOIN dbo.RO_restroTable rt ON rt.restrotableId= om.TableId
	left JOIN dbo.RO_RestroRoom rm ON rm.restroRoomId =  om.RoomId
	 where OM.OID!=0
	 ORDER BY om.Date asc 
end

--select * from dbo.RO_OrderMasters inner join RO_RestroRoom on  RO_OrderMasters.RoomId = RO_RestroRoom.restroRoomId






GO
