SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetAllItemfromDatabases]
as
BEGIN
select distinct im.ITId,im.PITId,im.ITName,id.ITCode,id.ImagePath,im.IsMenu
,im.IsCategory,id.IsExpirable,id.IsProdMaterial,id.ItemCostCentreID
,id.Details,im.IsActive
,(case when im.LookupName = 'cake' then 1 else 0 end) as IsCake
,(case when im.LookupName = 'wholesale' then 1 else 0 end) as IsWholeSale
,id.SmallUnit,ir.LargeUnit,ir.Conversion
,ir.IsDefaultPurchaseUnit,ir.IsDefaultSalesUnit,ir.SRate,ir.ValidFrom
,ex.ExtraItemID,ex.ExtraItem,ex.ExtraPrice,ex.IsActive
,cci.CostCenterName
,(select distinct ItemID from ROI_ItemRate where ItemID =im.ITId )as ItemRateID 
,(select ITName from ROI_ITEMMain where ITId = im.PITId) as ParentItem
  from ROI_ITEMMain im 
  join ROI_ItemDetails id on id.ITId = im.ITId
 --left join Roi_ItemWithUnit iwu on iwu.ItemID=id.ITId
   join ROI_ItemRate ir on ir.ItemID=im.ITId 
 left join RO_ExtraItem ex on  ex.ItemID=id.ITId
 join CostCenterInfo cci on cci.CostCenterId= id.ItemCostCentreID
 where im.IsArchived=0 
 --and id.IsProdMaterial=0 
 --and im.IsCategory=0
  order by im.ITName asc
 --  and id.IsMenu=1
end



GO
