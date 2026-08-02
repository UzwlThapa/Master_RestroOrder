SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_H_GetLostAndFound]  
AS  
 BEGIN  
  
  select * from H_LostAndFound
 --select h.RoomType ,h.Room , h.Date , h.Guest_Name, h.Type, h.Item_Name FROM  H_LostAndFound h  
 
 --WHERE @HkID=@HkID  

 
END  
  

GO
