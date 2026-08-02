SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
--  [dbo].[usp_ro_getpickdata] 2
CREATE PROCEDURE [dbo].[usp_ro_getpickdata]    
@TableId INT    
AS    
BEGIN    
DECLARE @OrderMasterId VARCHAR(128)    
SELECT @OrderMasterId=OrderMasterID FROM dbo.RO_OrderMasters WHERE OID=@TableId    
    
SELECT DISTINCT od.OrderDetailsID,    
          od.Quantity ,    
         od.Rate sRate,     
    CASE WHEN itd.ItemCostCentreID=1 or itd.ItemCostCentreID=95  THEN  od.Amount ELSE 0 END AS Amount,    
   CASE WHEN itd.ItemCostCentreID=2 THEN od.Amount ELSE 0 end AS Bevrage,    
         od.IsCancelled ,  
		 od.CostCenterId  ,
           od.ROI_ItemId ,    
         od.OrderMasterId ,    
           od.SeatNo ,    
           od.Note ,    
           od.ExtraCharge ,    
           om.BillPaid ,    
           od.NetAmount ,    
          od.CostCenterId ,    
          it.ITName ,    
     it.PITId,    
          om.RoomId ,    
       om.BillNo,    
         om.Date ,    
         om.BasicAmount ,    
           om.TermAmount,    
         om.Remarks,    
            om.UserName,    
         om.IsSplit,    
           om.GuestNo,    
          rt.restrotableId,    
           rt.restrotableTitle ,    
           rt.restroRoomId,    
          rt.restrotablesStatusID  
		  ,0 as IsCombo  
   -- ,od.CostCenterId    
  FROM dbo.RO_Order_Detail od    
left JOIN     
ROI_ITEMMain it ON it.ITId = od.ROI_ItemId    
Inner Join     
ROI_ItemDetails itd ON it.ITId = itd.ITId    
left JOIN     
dbo.RO_OrderMasters om ON om.OrderMasterID = od.OrderMasterId    
left JOIN    
dbo.RO_restroTable rt ON rt.restrotableId = om.TableId    
LEFT JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId=om.RoomId    
WHERE om.OrderMasterID=@OrderMasterId AND om.BillPaid=0 AND IsPrinted = 0  and IsCombo = 0  
union all  
SELECT DISTINCT od.OrderDetailsID,    
          od.Quantity ,    
         od.Rate sRate,     
    CASE WHEN it.CostCenterID=1 or it.CostCenterID=95  THEN  od.Amount ELSE 0 END AS Amount,    
   CASE WHEN it.CostCenterID=2 THEN od.Amount ELSE 0 end AS Bevrage,    
         od.IsCancelled ,   
		 od.CostCenterId, 
           od.ROI_ItemId ,    
         od.OrderMasterId ,    
           od.SeatNo ,    
           od.Note ,    
           od.ExtraCharge ,    
           om.BillPaid ,    
           od.NetAmount ,    
          od.CostCenterId ,    
          it.Name ITName ,    
     0 PITId,    
          om.RoomId ,    
       om.BillNo,    
         om.Date ,    
         om.BasicAmount ,    
           om.TermAmount,    
         om.Remarks,    
            om.UserName,    
         om.IsSplit,    
           om.GuestNo,    
          rt.restrotableId,    
           rt.restrotableTitle ,    
           rt.restroRoomId,    
          rt.restrotablesStatusID    
   -- ,od.CostCenterId    
		  ,1 as IsCombo  
  FROM dbo.RO_Order_Detail od    
left JOIN     
RO_Combo it ON it.ComboID = od.ROI_ItemId    
--Inner Join     
--ROI_ItemDetails itd ON it.ITId = itd.ITId    
left JOIN     
dbo.RO_OrderMasters om ON om.OrderMasterID = od.OrderMasterId    
left JOIN    
dbo.RO_restroTable rt ON rt.restrotableId = om.TableId    
LEFT JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId=om.RoomId    
WHERE om.OrderMasterID=@OrderMasterId AND om.BillPaid=0 AND IsPrinted = 0  and IsCombo = 1  
END 



GO
