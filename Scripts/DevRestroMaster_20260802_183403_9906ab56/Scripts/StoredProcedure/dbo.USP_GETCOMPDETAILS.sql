SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GETCOMPDETAILS]  
@CompMasterID int  
as  
begin  
select ITName as ROI_ItemName,   
    ROI_ItemId as ItemId,  
	ROI_ItemId,
    CompMasterID,  
    sum(Quantity) as Quantity,  
    Rate,  
    sum(Amount) as Amount,  
    CostCenterId,  
    IsHomeDelivery,  
    HomeDeliveyNumber,  
    ExtraItem,  
    IsCombo,  
    IsActive,
	  (SELECT  t1.Note +CASE WHEN t1.Note IS NOT NULL AND t1.Note<>'' THEN '('+ CAST(t1.Quantity as VARCHAR(3))+');' END
    FROM RO_ComplementaryItems t1
    WHERE (t1.CompMasterID=od.CompMasterID and t1.ROI_ItemID = od.ROI_ItemID and t1.iscancelled=0 and t1.IsCombo=0) 
    FOR XML PATH('')) AS  Note,
	SeatNo
	,its.ItemStatus as [Status]
     FROM  RO_ComplementaryItems od  
join ROI_ITEMMain im on od.ROI_ItemId = im.ITId  
inner join CompItemStatus ois on od.CompId = ois.CompId
left join RO_ItemStatus its on ois.StatusID =its.StatusID
  WHERE od.CompMasterID = @CompMasterID and ISCombo = 0 and od.IsCancelled = 0
  group by ITName ,   
    ROI_ItemId ,  
   -- OrderDetailsID,  
    CompMasterID,  
    Rate,    
    CostCenterId,  
    --IsRunningOrder,  
    IsHomeDelivery,  
    HomeDeliveyNumber,  
    ExtraItem,  
    IsCombo,  
    IsActive,
	--Note,
	SeatNo,its.ItemStatus
  --select * from RO_Order_Detail where OrderMasterId=153

  UNION


   -- declare @OrderMasterId int=488
select Name as ROI_ItemName,   
    ROI_ItemId as ItemId,  
	ROI_ItemId,
    --OrderDetailsID,  
    CompMasterID,  
    sum(Quantity) as Quantity,  
    Rate,  
    sum(Amount) as Amount,  
    cm.CostCenterID,  
    --IsRunningOrder,  
    IsHomeDelivery,  
    HomeDeliveyNumber,  
    ExtraItem,  
    IsCombo,  
    IsActive,
	(SELECT  t1.Note +CASE WHEN t1.Note IS NOT NULL AND t1.Note<>'' THEN '('+ CAST(t1.Quantity as VARCHAR(3))+');' END
    FROM RO_ComplementaryItems t1
    WHERE (t1.CompMasterID=od.CompMasterID and t1.ROI_ItemID = od.ROI_ItemID and t1.iscancelled=0 and t1.IsCombo=1) 
    FOR XML PATH('')) AS  Note,
	0
	,its.ItemStatus as [Status]
	FROM  RO_ComplementaryItems od  
inner join RO_Combo cm on cm.ComboID= od.ROI_ItemId
inner join CompItemStatus ois on od.CompId = ois.CompId 
left join RO_ItemStatus its on ois.StatusID=its.StatusID
  WHERE od.CompMasterID = @CompMasterID and ISCombo = 1 and od.IsCancelled = 0
  group by Name ,   
    ROI_ItemId ,  
   -- OrderDetailsID,  
    CompMasterID,  
    Rate,   
    cm.CostCenterID,  
  --IsRunningOrder,  
    IsHomeDelivery,  
    HomeDeliveyNumber,  
    ExtraItem,  
    IsCombo,  
    IsActive,
	--Note,
	its.ItemStatus
end  




















GO
