SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[USP_RO_getitemlistwithrate] 4695  
CREATE PROCEDURE [dbo].[USP_RO_getCombolistwithrate]   
@ItemID int  
AS  
BEGIN  
select m.ComboID ITId, m.Name  ITName, m.SalesPrice  SRate  from RO_Combo m    
where m.ComboID = @ItemID  
  
end  
  
--select * from Roi_ItemWithUnit   
--select * from ROI_ItemRate  
--insert into Roi_ItemWithUnit (ItemID, LargeUnit,Conversion,IsDefaultPurchaseUnit,IsDefaultSalesUnit,SalesRate,ValidFrom,AddedBy,AddedOn,IsArchived)  
--select ir.ItemID,ir.UnitID,'1',1,1,ir.SRate,GETDATE(),ir.PostedBy,ir.PostedOn,0 from ROI_ItemRate ir  
  
  
  



GO
