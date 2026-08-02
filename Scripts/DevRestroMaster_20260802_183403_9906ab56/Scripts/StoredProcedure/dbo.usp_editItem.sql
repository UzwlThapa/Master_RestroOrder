SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[usp_ItemWithUnitList] 4678
--[usp_editItem]  4683
CREATE PROCEDURE [dbo].[usp_editItem]
@itemID int
as
select ei.ExtraItemID,ei.ExtraItem,ei.ExtraPrice, ei.IsActive from RO_ExtraItem ei 
 --on ei.ItemID=im.ITId
--join ROI_Unit1 u1 on iwu.LargeUnit= u1.Unit1Id
--join CostCenterInfo cci on cci.CostCenterId= id.ItemCostCentreID 
where ei.ItemID=@itemID



GO
