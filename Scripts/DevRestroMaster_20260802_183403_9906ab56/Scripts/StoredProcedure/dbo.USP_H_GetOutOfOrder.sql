SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_H_GetOutOfOrder] 
AS
BEGIN

select roo.OutOfOrderID,roo.RoomID,rt.restrotableTitle as RoomType, roo.OO_Status,roo.FromDate,roo.ThroughDate,roo.ReturnAs,roo.Reason,roo.OO_Remarks,roo.IsOutOfOrder,roo.IsOutOfService 
from RO_OutOfOrder roo

join RO_restroTable rt
 on rt.restrotableId = roo.RoomID


END

GO
