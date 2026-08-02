SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GETPREVIOUSITEMBYROOMID] 
@Id INT
AS
Begin

declare @val varchar(90)
set @val= dbo.fn_getMaxMasterIdByRoom(@Id)

 SELECT * FROM  dbo.RO_Items rt
 INNER JOIN dbo.RO_Order_Detail od ON od.ItemId = rt.ItemID
 INNER JOIN dbo.RO_OrderMasters om ON om.OrderMasterID = od.OrderMasterId
 --inner join dbo.RO_restroTable on RO_restroTable.restrotableId = om.TableId
 --inner join dbo.RO_RestroRoom on RO_RestroRoom.restroRoomId = om.RoomId 

WHERE om.RoomId =@Id AND om.BillPaid = 0 AND om.IsCancelled = 0 and om.OrderMasterID=@val

--[dbo].[USP_RO_GetPreviousItemByID]33

-- SELECT * FROM  dbo.RO_OrderMasters om
-- INNER JOIN dbo.RO_Order_Detail od ON od.OrderMasterId = om.OrderMasterID 
-- INNER JOIN dbo.RO_Items rt ON rt.ItemID = od.ItemId
--WHERE om.TableId =@Id
end

--select * from ro_restrotable




GO
