SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_getMaxStatusId] 
(
	@OrderDetailID varchar(128)
)
RETURNS int
AS
BEGIN
Declare @val varchar(128)
	select @val=max(m.OrderItemStatusID) from RO_OrderItemStatus m
	where m.OrderDetailID=@OrderDetailID
	return @val
	
END





GO
