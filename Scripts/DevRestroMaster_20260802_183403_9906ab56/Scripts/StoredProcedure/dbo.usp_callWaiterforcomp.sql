SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_callWaiterforcomp] 
@CompId int

as



select 

om.UserName as WaiterName,

cci.CostCenterName as Department,

item.ITCode as ItemName,

room.restroRoom as RoomName,

rtable.restrotableTitle as TableName,

wnl.WaiterIP as WaiterIP

from RO_ComplementaryItems odr 

left join tblComplementaryMaster om on om.CompMasterID=odr.CompMasterID

left join ROI_ItemDetails item on item.ITId = odr.ROI_ItemId

left join RO_restroTable rtable on om.TableId = rtable.restrotableId

left join RO_RestroRoom room on room.restroRoomId = om.RoomId

left join CostCenterInfo cci on cci.CostCenterId = odr.CostCenterId

left join WaiterNotificationLog wnl on wnl.WaiterName = om.UserName

where odr.CompId= @CompId

GO
