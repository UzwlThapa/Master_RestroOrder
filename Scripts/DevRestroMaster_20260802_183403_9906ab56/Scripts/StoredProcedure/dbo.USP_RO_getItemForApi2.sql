SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[USP_RO_getItemForApi]
--[dbo].[USP_RO_getItemForApi2] 0, 3
CREATE PROCEDURE [dbo].[USP_RO_getItemForApi2]
@pitId int,
@level int
AS
BEGIN
select m.ITID as ItemId, m.ITName as ItemName,m.PITId as PItemId,
d.ITCode as ItemCode,d.ImagePath,d.CostCenterID,d.MUnitId,d.DSUnitId,d.DPUnitId,d.IsExpirable,IsProdMaterial,
d.ROrderLevel as Level,d.IsUnitWiseRate  from ROI_ITEMMain m  
inner join ROI_ItemDetails d on d.ITId = m.ITId
where m.PITId=@pitId and d.ROrderLevel=@level 
--where d.ROrderLevel=@level 
end
--select * from ROI_ITEMMain
--select * from ROI_ItemDetails






GO
