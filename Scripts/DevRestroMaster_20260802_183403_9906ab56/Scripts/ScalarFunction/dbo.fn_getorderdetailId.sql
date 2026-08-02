SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_getorderdetailId]
(
	@OrderMasterId varchar(128)
)
RETURNS int
AS
BEGIN
Declare @val varchar(128)
	select @val=OrderDetailID from RO_OrderItemStatus m
	where m.OrderDetailID=@OrderMasterId
	return @val
	
END





GO
