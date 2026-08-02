SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--usp_H_getOOReport '12','','05/11/2017','0','1'
--usp_H_getOOReport 0, 0,'', '', 0, 0
--usp_H_getOOReport 0, '4','', '', 0, 0

CREATE PROCEDURE [dbo].[usp_H_getOOReport] 
@RoomID int,
@RoomTypeID int,
@RoomClass varchar(128),
@StartDate nvarchar(150),
@IsOutOfOrder int,
@IsOutOfService int
--select * from Ro_RoomType
AS
BEGIN

select roo.OutOfOrderID,roo.RoomID,rt.restrotableTitle as RoomType, rr.restroRoom as Roomvalue, rr.restroRoomId as RoomTypeID, roo.OO_Status,roo.FromDate,roo.ThroughDate,roo.ReturnAs,roo.Reason,roo.OO_Remarks,roo.IsOutOfOrder,roo.IsOutOfService 
from RO_OutOfOrder roo

join RO_restroTable rt
on rt.restrotableId = roo.RoomID
join RO_RestroRoom rr
on rr.restroRoomId = rt.restroRoomId

where ( rt.restrotableId = @RoomID OR @RoomID = 0 )
AND (rr.restroRoomId= @RoomTypeID or @RoomTypeID = 0)
AND @RoomClass = ''
AND (roo.FromDate = @StartDate or @StartDate = '')
AND (@IsOutOfOrder = 0 OR roo.IsOutOfOrder = @IsOutOfOrder)
AND (@IsOutOfService = 0 OR roo.IsOutOfService = @IsOutOfService)
END

--select * from RO_RestroRoom

GO
