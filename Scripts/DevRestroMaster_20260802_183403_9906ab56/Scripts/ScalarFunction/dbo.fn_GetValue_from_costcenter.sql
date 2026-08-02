SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_GetValue_from_costcenter](@table_id INT,@costcenter INT)
RETURNS DECIMAL(8,2)
AS
BEGIN
DECLARE @fooditem DECIMAL(8,2)	
	SELECT @fooditem = od.Amount
	FROM dbo.RO_Order_Detail od
		INNER JOIN dbo.RO_Items it ON it.ItemID = od.ItemId
		LEFT JOIN dbo.RO_OrderMasters om ON om.OrderMasterID = od.OrderMasterId
		LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
		LEFT JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId=om.RoomId
	WHERE om.TableId = @table_id 
		AND om.BillPaid=1 
		AND it.CostCenterID=1 
		OR om.RoomId=@table_id
		AND om.BillPaid=1 
		AND it.CostCenterID=1
	RETURN @fooditem

END




GO
