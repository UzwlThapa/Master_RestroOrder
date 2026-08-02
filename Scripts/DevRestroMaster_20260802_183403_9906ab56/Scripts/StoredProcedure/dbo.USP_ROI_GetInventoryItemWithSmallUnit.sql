SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext [USP_ROI_GetInventoryItemWithSmallUnit]
CREATE PROCEDURE [dbo].[USP_ROI_GetInventoryItemWithSmallUnit]
AS
BEGIN
select distinct rim.ITId,rim.ITName,id.SmallUnit,u1.UnitDescription,u1.Symbol, rim.IsCategory
 from dbo.ROI_ITEMMain rim
 join dbo.ROI_ItemDetails id on id.ITId=rim.ITId
 left join ROI_ItemRate ir on ir.ItemID=rim.ITId
 left join ROI_Unit1 u1 on u1.Unit1Id=id.SmallUnit
 where 
 --rim.PITId!=0 and 
 rim.IsArchived=0 
 --and rim.IsCategory is not null 
 and rim.IsCategory=0
 and id.IsProdMaterial=1
end




GO
