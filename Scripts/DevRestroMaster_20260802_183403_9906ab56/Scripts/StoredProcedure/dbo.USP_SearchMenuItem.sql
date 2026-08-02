SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SearchMenuItem]
  @MenuItem varchar(250)='',
 @ItemCategory int=0,
 @Costcenterid int = 0
 as
select distinct im.ITId,im.PITId,im.ITName,id.ITCode,id.ImagePath,im.IsMenu
,im.IsCategory,id.IsExpirable,id.IsProdMaterial,id.ItemCostCentreID
,id.Details,im.IsActive,id.SmallUnit,ir.LargeUnit,ir.Conversion
,ir.IsDefaultPurchaseUnit,ir.IsDefaultSalesUnit,ir.SRate,ir.ValidFrom,id.IsExtra
,cci.CostCenterName
,(select distinct ItemID from ROI_ItemRate where ItemID =im.ITId )as ItemRateID 
,(select ITName from ROI_ITEMMain where ITId = im.PITId) as ParentItem
  from ROI_ITEMMain im 
	inner join ROI_ITEMMain cat on im.PITId=cat.ITId
  left join ROI_ItemDetails id on id.ITId = im.ITId
   left join ROI_ItemRate ir on ir.ItemID=im.ITId 
 left join RO_ExtraItem ex on  ex.ItemID=id.ITId
 left join CostCenterInfo cci on cci.CostCenterId= id.ItemCostCentreID
 where (im.ITName LIKE '%'+@MenuItem+'%') 
and (im.PITId =  @ItemCategory or  @ItemCategory =0)
and (id.ItemCostCentreID = @Costcenterid or @Costcenterid =0)
 and im.IsArchived=0 
and im.IsCategory=0
and cat.IsArchived=0
 and cat.IsActive=1 and cat.IsMenu=1
  order by im.ITName asc


 -- select * from CostCenterInfo 

GO
