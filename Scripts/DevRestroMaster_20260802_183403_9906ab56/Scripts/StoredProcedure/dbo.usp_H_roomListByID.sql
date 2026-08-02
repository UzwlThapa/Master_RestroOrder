SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--usp_H_roomListByID

CREATE PROCEDURE [dbo].[usp_H_roomListByID] 
@OutOfOrderID int

AS
BEGIN

select roo.OutOfOrderID,roo.RoomID,rt.restrotableTitle as RoomType, roo.OO_Status,roo.FromDate,roo.ThroughDate,roo.ReturnAs,roo.Reason,roo.OO_Remarks,roo.IsOutOfOrder,roo.IsOutOfService 
from RO_OutOfOrder roo

join RO_restroTable rt
 on rt.restrotableId = roo.RoomID
 where OutOfOrderID =@OutOfOrderID

END

GO
