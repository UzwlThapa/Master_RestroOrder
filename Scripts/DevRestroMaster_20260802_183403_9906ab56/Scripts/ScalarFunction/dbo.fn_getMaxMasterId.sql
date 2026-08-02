SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_getMaxMasterId] 
(
	
	@tableId varchar(128)
)
RETURNS int
AS
BEGIN
Declare @val varchar(128)
	select @val=max(m.OrderMasterID) from RO_OrderMasters m
	where m.tableId=@tableId and BillPaid!=1 and IsCancelled!=1
	return @val

	
END
--select max(m.OrderMasterID) from RO_OrderMasters m where m.tableId=0







GO
