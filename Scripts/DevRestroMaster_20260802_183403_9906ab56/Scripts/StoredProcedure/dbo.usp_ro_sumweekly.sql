SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_sumweekly]
@FromDate DateTime
as
begin 
	select sum(BasicAmount) as sumAmount from RO_OrderMasters	
	where cast(Date as date) between DateAdd(DD,-7,@FromDate) and @FromDate
end




GO
