SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
-- [USP_RO_GettabledataById] 19, 1    
CREATE PROCEDURE [dbo].[USP_RO_GettabledataById]                    
@TableId INT     
 ,@seatNo INT    
AS        
DECLARE @val INT        
        
SET @val = dbo.fn_getMaxMasterId((@TableId))        
        
--SELECT @val        
        
SELECT distinct OD.OrderDetailsID        
 ,OD.Quantity        
 ,OD.Rate        
 ,OD.Amount        
 ,0 Bevrage        
 ,OD.IsCancelled      
 ,OD.ROI_ItemId        
 ,OD.OrderMasterId        
 ,OD.SeatNo        
 ,OD.Note        
 ,OD.ExtraCharge        
 ,OD.BillPaid        
 ,OD.NetAmount        
 ,Od.CostCenterId        
 ,itm.Name ITName        
 ,itm.ImagePath        
 ,itm.SalesPrice SRate        
 ,itm.ComboCode ITCode        
 ,0 DSUnitId        
 ,0 PITId        
 ,om.RoomId        
 ,om.BillNo        
 ,om.DATE        
 ,om.BasicAmount        
 ,om.TermAmount        
 ,om.Remarks        
 ,om.UserName        
 ,om.IsSplit        
 ,om.GuestNo        
 ,rt.restrotableId        
 ,rt.restrotableTitle        
 ,rt.restroRoomId        
 ,rt.restrotablesStatusID        
 ,'' restroRoom      
 ,1 as IsCombo     
FROM RO_Order_Detail OD        
INNER JOIN RO_OrderMasters OM ON OD.OrderMasterId = OM.OrderMasterID        
INNER JOIN RO_Combo itm ON OD.ROI_ItemId = itm.ComboID        
--INNER JOIN RO_ComboDetails itd ON OD.ROI_ItemId = itm.ComboID        
--INNER JOIN ROI_ItemRate ir ON itm.ITId = ir.ItemID        
LEFT JOIN RO_restroTable rt ON rt.restrotableId = om.TableId        
WHERE OD.OrderMasterId = @val        
 AND om.IsCancelled = 0        
 and OD.IsCombo = 1        
 AND od.SeatNo = @seatNo
 and isnull(OD.BillPaid,0) = 0   
union         
         
SELECT OD.OrderDetailsID        
 ,OD.Quantity        
 ,OD.Rate        
 ,CASE         
  WHEN itd.ItemCostCentreID = 1        
   OR itd.ItemCostCentreID = 95    OR itd.ItemCostCentreID = 97    
   THEN od.Amount        
  ELSE 0        
  END AS Amount        
 ,CASE         
  WHEN itd.ItemCostCentreID = 2        
   THEN od.Amount        
  ELSE 0        
  END AS Bevrage        
 ,OD.IsCancelled        
 ,OD.ROI_ItemId        
 ,OD.OrderMasterId        
 ,OD.SeatNo        
 ,OD.Note        
 ,OD.ExtraCharge        
 ,OD.BillPaid        
 ,OD.NetAmount        
 ,Od.CostCenterId        
 ,itm.ITName        
 ,itd.ImagePath        
 ,ir.SRate        
 ,itd.ITCode        
 ,itd.DSUnitId        
 ,itm.PITId        
 ,om.RoomId        
 ,om.BillNo        
 ,om.DATE        
 ,om.BasicAmount        
 ,om.TermAmount        
 ,om.Remarks        
 ,om.UserName        
 ,om.IsSplit        
 ,om.GuestNo        
 ,rt.restrotableId        
 ,rt.restrotableTitle        
 ,rt.restroRoomId        
 ,rt.restrotablesStatusID       
 ,'' restroRoom       
 ,0 as IsCombo   
FROM RO_Order_Detail OD        
INNER JOIN RO_OrderMasters OM ON OD.OrderMasterId = OM.OrderMasterID        
INNER JOIN ROI_ITEMMain itm ON OD.ROI_ItemId = itm.ITId        
INNER JOIN ROI_ItemDetails itd ON OD.ROI_ItemId = itd.ITId        
INNER JOIN ROI_ItemRate ir ON itm.ITId = ir.ItemID        
LEFT JOIN RO_restroTable rt ON rt.restrotableId = om.TableId        
WHERE OD.OrderMasterId = @val        
 AND om.IsCancelled = 0        
 and OD.IsCombo = 0  
  AND od.SeatNo = @seatNo
 and isnull(OD.BillPaid,0) = 0 



GO
