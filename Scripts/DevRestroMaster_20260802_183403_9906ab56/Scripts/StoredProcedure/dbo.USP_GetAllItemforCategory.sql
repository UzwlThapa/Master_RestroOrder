SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetAllItemforCategory]
as
BEGIN
select  *,
 (select ITName from ROI_ITEMMain where ITId = im.PITId) as ParentItem from ROI_ITEMMain im 
  join ROI_ItemDetails id on id.ITId = im.ITId
 join CostCenterInfo cci on cci.CostCenterId= id.ItemCostCentreID
 where im.IsArchived=0 and im.IsCategory=1
 --  and id.IsMenu=1
end

--select * from ROI_ITEMMain im
--join ROI_ItemDetails id on id.ITId = im.ITId
--join CostCenterInfo cci on cci.CostCenterId= id.ItemCostCentreID
-- where im.IsArchived=0 and im.IsCategory=1



GO
