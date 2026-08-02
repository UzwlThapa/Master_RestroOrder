SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[USP_RO_GETROOMDATAFORMENU]
@RoomId INT
AS

Begin

declare @val varchar(90)
	set @val= dbo.fn_getMaxMasterIdByRoom(@roomId)

SELECT * FROM dbo.RO_Order_Detail od
--inner join dbo.Ro_companyinfo c on c.CurrencyID = od.ItemId
INNER JOIN 
dbo.RO_Items it ON it.ItemID = od.ItemId
INNER JOIN 
dbo.RO_OrderMasters om ON om.OrderMasterID = @val --od.OrderMasterId
Inner join 
dbo.RO_RestroRoom rd on rd.restroRoomId = om.RoomId
--INNER JOIN
--dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
WHERE om.RoomId = @RoomId AND om.BillPaid = 0 
and om.IsCancelled =0 and od.Quantity != 0 and od.IsCancelled = 0 and od.OrderMasterID = @val
--and CONVERT(date, om.Date)=CONVERT(DATE,getdate())

end




GO
