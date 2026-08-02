SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_getbasicsumamount]
@Todaydate DateTime
as
begin
 select sum(om.BasicAmount) as sumAmount from RO_OrderMasters om
 where cast(om.Date as Date)=@Todaydate
end




GO
