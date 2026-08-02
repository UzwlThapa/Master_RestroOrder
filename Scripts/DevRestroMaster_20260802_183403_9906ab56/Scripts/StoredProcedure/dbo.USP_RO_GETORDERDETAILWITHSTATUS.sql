SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GETORDERDETAILWITHSTATUS] 
(
@OrderDetailsID INT
)
AS
BEGIN

declare @val1 varchar(128)
--set @val= dbo.fn_getMaxMasterId(@TableId)
set @val1 = dbo.fn_getMaxStatusId(@OrderDetailsID)
select RO_ItemStatus.ItemStatus as Status FROM  dbo.RO_ItemStatus 
join RO_OrderItemStatus on RO_OrderItemStatus.StatusID = RO_ItemStatus.StatusID 
where RO_OrderItemStatus.OrderItemStatusID = @val1
--			full	join RO_ItemStatus on RO_ItemStatus.StatusID = RO_OrderItemStatus.StatusID where dbo.RO_ItemStatus.StatusID = 6

--dbo.RO_Order_Detail join RO_Items on RO_Order_Detail.ItemId = RO_Items.ItemId 
--		full join RO_OrderItemStatus on RO_OrderItemStatus.OrderDetailID = RO_Order_Detail.OrderDetailsID 
--			full	join RO_ItemStatus on RO_ItemStatus.StatusID = RO_OrderItemStatus.StatusID
--  WHERE RO_Order_Detail.OrderDetailsID =   @val1
end





GO
