SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GETTABLENAME]
AS
BEGIN
	declare @val varchar(90)
	--set @val= dbo.fn_getMaxMasterId(TableId)
	--select * RO_OrderMasters where RO_OrderMasters.OrderMasterId = @val
select distinct TableId from RO_OrderMasters where RO_OrderMasters.IsCancelled = 0 and dbo.fn_getMaxMasterId(TableId)=  RO_OrderMasters.OrderMasterID and BillPaid = 0
end





GO
