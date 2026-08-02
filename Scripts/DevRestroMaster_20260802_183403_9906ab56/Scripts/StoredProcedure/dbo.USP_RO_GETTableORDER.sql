SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [USP_RO_GETTableORDER] 0,0,18
CREATE PROCEDURE [dbo].[USP_RO_GETTableORDER]    
@BillPayed bit,    
@IsCancel bit,    
@TableID int
AS    
BEGIN    
  DECLARE @ORderMASTERID int   
  if @TableID <> 0  
  select @ORderMASTERID = OrderMasterID from RO_OrderMasters OM where OM.IsCancelled = @IsCancel and OM.BillPaid = @BillPayed  and (OM.TableId = @TableID)   
  else   
  select @ORderMASTERID = OrderMasterID from RO_OrderMasters OM where OM.IsCancelled = @IsCancel and OM.BillPaid = @BillPayed  and OM.TableId = @TableID  

 select * FROM RO_Order_Detail od    
 inner join RO_OrderMasters om on od.OrderMasterId=om.OrderMasterID    
 left JOIN dbo.RO_restroTable rt ON rt.restrotableId= om.TableId    
 left JOIN dbo.RO_RestroRoom rm ON rm.restroRoomId =  rt.restroRoomId    
  where om.OrderMasterID =  @ORderMASTERID 
  ORDER BY om.Date asc     
end    
    
    
    
--select * FROM dbo.RO_OrderMasters om    
-- * FROM dbo.RO_restroTable om    
--select * FROM dbo.RO_RestroRoom om    
--select * from dbo.RO_OrderMasters inner join RO_RestroRoom on  RO_OrderMasters.RoomId = RO_RestroRoom.restroRoomId    
    



GO
