SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getdatabyeRange]
@StartDate datetime,
@Todate datetime
as
begin
select 
om.Date,
om.BasicAmount,
om.UserName,
rt.restrotableTitle,
rr.restroRoom
 from dbo.RO_OrderMasters om
 left join dbo.RO_restroTable rt on rt.restrotableId = om.TableId
 left join RO_RestroRoom rr on rr.restroRoomId=om.RoomId
 where om.Date between @StartDate and @Todate

end






GO
