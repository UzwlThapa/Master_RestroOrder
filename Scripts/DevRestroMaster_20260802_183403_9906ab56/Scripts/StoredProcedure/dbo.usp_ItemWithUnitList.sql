SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[usp_ItemWithUnitList] 4683
CREATE PROCEDURE [dbo].[usp_ItemWithUnitList]
@itemID int
as
select * from 
--ROI_ITEMMain im 
 --join ROI_ItemDetails id on im.ITId=id.ITIdjoin 
 Roi_ItemWithUnit iwu 
 --on iwu.ItemID=im.ITId
 --join RO_ExtraItem ei on ei.ItemID=im.ITId
--join ROI_Unit1 u1 on iwu.LargeUnit= u1.Unit1Id
--join CostCenterInfo cci on cci.CostCenterId= id.ItemCostCentreID 
where iwu.ItemID=@itemID



GO
