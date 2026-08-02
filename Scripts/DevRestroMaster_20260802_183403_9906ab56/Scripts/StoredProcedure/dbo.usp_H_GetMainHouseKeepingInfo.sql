SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_H_GetMainHouseKeepingInfo]  
@RoomStatus nvarchar(50),
@AssignTo nvarchar(256)
AS  
 BEGIN  
  
  
 select rt.restrotableId as RoomID,RTT.restroRoom as RoomType, rt.restrotableTitle as Room, h.HK_ID, h.RoomStatus,h.Availability, h.HK_Date as HK_Date, h.Remarks_HK, h.AssignTo   
 FROM  RO_restroTable rt  
 inner join RO_RestroRoom RTT on RTT.restroRoomId = rt.restroRoomId  
 left join H_HouseKeeping h on rt.restrotableId = h.RoomID 
 and h.IsActive =1  
 where rt.IsTable = 0 
 and (@RoomStatus ='' or  h.RoomStatus =@RoomStatus )
 and (h.AssignTo = @AssignTo or @AssignTo = '')  
  
  
 --WHERE @HkID=@HkID  

 
END  
  


GO
