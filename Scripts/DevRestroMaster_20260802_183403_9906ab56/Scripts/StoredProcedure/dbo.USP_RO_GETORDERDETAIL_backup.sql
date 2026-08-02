SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[USP_RO_GETORDERDETAIL] 341
CREATE PROCEDURE [dbo].[USP_RO_GETORDERDETAIL_backup]  
@OrderMasterId int  
as  
begin  
 -- declare @OrderMasterId int=137
select im.ITName as ROI_ItemName,   
    od.ROI_ItemId as ItemId,  
	od.ROI_ItemId,
    --OrderDetailsID,  
    od.OrderMasterId,  
    sum(od.Quantity) as Quantity,  
    od.Rate,  
    sum(od.Amount) as Amount,  
    od.CostCenterId,  
    --IsRunningOrder,  
    --od.IsHomeDelivery,  
    --od.HomeDeliveyNumber,  
   -- od.ExtraItem,  
    od.IsCombo,  
    im.IsActive,
	  (SELECT  t1.Note +CASE WHEN t1.Note IS NOT NULL AND t1.Note<>'' THEN '('+ CAST(t1.Quantity as VARCHAR(3))+');' END
    FROM RO_Order_Detail t1
    WHERE (t1.OrderMasterId=od.OrderMasterId and t1.ROI_ItemID = od.ROI_ItemID and t1.iscancelled=0 and t1.IsCombo=0) 
    FOR XML PATH('')) AS  Note,
	od.SeatNo
	,om.GuestNo

	,its.ItemStatus as [Status]
     FROM  dbo.RO_Order_Detail od  
join ROI_ITEMMain im on od.ROI_ItemId = im.ITId  
inner join RO_OrderItemStatus ois on od.OrderDetailsID = ois.OrderDetailID 
inner join ro_ordermasters om on om.ordermasterid = od.ordermasterid
left join RO_ItemStatus its on ois.StatusID =its.StatusID
  WHERE od.OrderMasterId = @OrderMasterId and ISCombo = 0 and od.IsCancelled = 0 and isnull(od.BillPaid,0) = 0
  group by im.ITName ,   
    od.ROI_ItemId ,  
   -- OrderDetailsID,  
    od.OrderMasterId,  
    od.Rate,    
    od.CostCenterId,  
    --IsRunningOrder,  
    --od.IsHomeDelivery,  
    --od.HomeDeliveyNumber,  
    --od.ExtraItem,  
    od.IsCombo,  
    im.IsActive,
	--Note,
	od.SeatNo
	,om.GuestNo
	,its.ItemStatus
  --select * from RO_Order_Detail where OrderMasterId=153

  UNION


   -- declare @OrderMasterId int=488
select cm.Name as ROI_ItemName,   
    od.ROI_ItemId as ItemId,  
	od.ROI_ItemId,
    --OrderDetailsID,  
    od.OrderMasterId,  
    sum(od.Quantity) as Quantity,  
    od.Rate,  
    sum(od.Amount) as Amount,  
    cm.CostCenterID,  
    --IsRunningOrder,  
    --od.IsHomeDelivery,  
    --od.HomeDeliveyNumber,  
    --od.ExtraItem,  
    od.IsCombo,  
    cm.IsActive,
	(SELECT  t1.Note +CASE WHEN t1.Note IS NOT NULL AND t1.Note<>'' THEN '('+ CAST(t1.Quantity as VARCHAR(3))+');' END
    FROM RO_Order_Detail t1
    WHERE (t1.OrderMasterId=od.OrderMasterId and t1.ROI_ItemID = od.ROI_ItemID and t1.iscancelled=0 and t1.IsCombo=1) 
    FOR XML PATH('')) AS  Note,
	od.SeatNo
	,om.GuestNo
	,its.ItemStatus as [Status]
	FROM  dbo.RO_Order_Detail od  
inner join RO_Combo cm on cm.ComboID= od.ROI_ItemId
inner join RO_OrderItemStatus ois on od.OrderDetailsID = ois.OrderDetailID 
inner join ro_ordermasters om on om.ordermasterid = od.ordermasterid
left join RO_ItemStatus its on ois.StatusID=its.StatusID
  WHERE od.OrderMasterId = @OrderMasterId and ISCombo = 1 and od.IsCancelled = 0 and isnull(od.BillPaid,0) = 0
  group by cm.Name ,   
    od.ROI_ItemId ,  
   -- OrderDetailsID,  
    od.OrderMasterId,  
    od.Rate,   
    cm.CostCenterID,  
  --IsRunningOrder,  
    --od.IsHomeDelivery,  
    --od.HomeDeliveyNumber,  
    --od.ExtraItem,  
    od.IsCombo,  
    cm.IsActive,
	--Note,
	od.SeatNo
	,om.GuestNo
	,its.ItemStatus
end  

GO
