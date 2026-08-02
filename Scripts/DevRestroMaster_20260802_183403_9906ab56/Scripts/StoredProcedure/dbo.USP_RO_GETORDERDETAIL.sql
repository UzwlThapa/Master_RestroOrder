SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROC [dbo].[USP_RO_GETORDERDETAIL]
--[dbo].[USP_RO_GETORDERDETAIL] 7
CREATE PROCEDURE [dbo].[USP_RO_GETORDERDETAIL]    
@OrderMasterId int   
,@TableId int=null -- Added by Dinesh Hona, To fixed opium issue
as    
begin   
/*====  Added by Dinesh Hona, To fixed opium issue ====*/
if(@OrderMasterId=0)
BEGIN
SELECT @OrderMasterId=MaX(OrderMasterID) 
	FROM dbo.RO_OrderMasters
	WHERE isnull(BillPaid, 0) = 0
		AND isnull(IsCancelled, 0) = 0
		AND (TableId=@TableId )
	GROUP BY TableId
END	 

/*====  End of Added by Dinesh Hona, To fixed opium issue ====*/
select * FROM
(
select im.ITName as ROI_ItemName,     
    od.ROI_ItemId as ItemId,    
 od.ROI_ItemId,     
    od.OrderMasterId,    
    sum(od.Quantity) as Quantity,    
    od.Rate,    
    sum(od.Amount) as Amount,    
    od.CostCenterId,        
    od.IsCombo,    
    im.IsActive,  
   (SELECT  t1.Note +CASE WHEN t1.Note IS NOT NULL AND t1.Note<>'' THEN '('+ CAST(t1.Quantity as VARCHAR(3))+');' END  
    FROM RO_Order_Detail t1  
    WHERE (t1.OrderMasterId=od.OrderMasterId and t1.ROI_ItemID = od.ROI_ItemID and t1.iscancelled=0 and t1.IsCombo=0)   
    FOR XML PATH('')) AS  Note,  
 od.SeatNo  
 ,om.GuestNo    
 ,its.ItemStatus as [Status] 
 --,od.OrderDetailsID 
 ,isnull(od.OrderNo,0) OrderNo
 ,ccg.GroupId
     FROM  dbo.RO_Order_Detail od    
join ROI_ITEMMain im on od.ROI_ItemId = im.ITId    
inner join RO_OrderItemStatus ois on od.OrderDetailsID = ois.OrderDetailID   
inner join ro_ordermasters om on om.ordermasterid = od.ordermasterid  
inner join CostCenterInfo cci on od.CostCenterId = cci.CostCenterId
inner join RO_CostCenterGroup ccg on cci.GroupId = ccg.GroupId
left join RO_ItemStatus its on ois.StatusID =its.StatusID  
  WHERE od.OrderMasterId = @OrderMasterId and ISCombo = 0 and od.IsCancelled = 0 and isnull(od.BillPaid,0) = 0  
  group by im.ITName ,     
    od.ROI_ItemId ,      
    od.OrderMasterId,    
    od.Rate,      
    od.CostCenterId,     
    od.IsCombo,    
    im.IsActive,  
		 od.SeatNo  
		 ,om.GuestNo  
		 ,its.ItemStatus  
		  --,od.OrderDetailsID 
		 ,od.OrderNo
		 ,ccg.GroupId
  UNION    
select cm.Name as ROI_ItemName,     
    od.ROI_ItemId as ItemId,    
 od.ROI_ItemId,      
    od.OrderMasterId,    
    sum(od.Quantity) as Quantity,    
    od.Rate,    
    sum(od.Amount) as Amount,    
    cm.CostCenterID,        
    od.IsCombo,    
    cm.IsActive,  
 (SELECT  t1.Note +CASE WHEN t1.Note IS NOT NULL AND t1.Note<>'' THEN '('+ CAST(t1.Quantity as VARCHAR(3))+');' END  
    FROM RO_Order_Detail t1  
    WHERE (t1.OrderMasterId=od.OrderMasterId and t1.ROI_ItemID = od.ROI_ItemID and t1.iscancelled=0 and t1.IsCombo=1)   
    FOR XML PATH('')) AS  Note,  
 od.SeatNo  
 ,om.GuestNo  
 ,its.ItemStatus as [Status]  
 -- ,od.OrderDetailsID 
 ,isnull(od.OrderNo,0) OrderNo
 ,ccg.GroupId
 FROM  dbo.RO_Order_Detail od    
inner join RO_Combo cm on cm.ComboID= od.ROI_ItemId  
inner join RO_OrderItemStatus ois on od.OrderDetailsID = ois.OrderDetailID   
inner join ro_ordermasters om on om.ordermasterid = od.ordermasterid  
inner join CostCenterInfo cci on od.CostCenterId = cci.CostCenterId
inner join RO_CostCenterGroup ccg on cci.GroupId = ccg.GroupId
left join RO_ItemStatus its on ois.StatusID=its.StatusID  
  WHERE od.OrderMasterId = @OrderMasterId and ISCombo = 1 and od.IsCancelled = 0 and isnull(od.BillPaid,0) = 0  
  group by cm.Name ,     
    od.ROI_ItemId ,      
    od.OrderMasterId,    
    od.Rate,     
    cm.CostCenterID,    
    od.IsCombo,    
    cm.IsActive,  
	 od.SeatNo  
	 ,om.GuestNo  
	 ,its.ItemStatus  
	 -- ,od.OrderDetailsID 
	 ,od.OrderNo
	 ,ccg.GroupId
) x Order BY GroupId

END

GO
