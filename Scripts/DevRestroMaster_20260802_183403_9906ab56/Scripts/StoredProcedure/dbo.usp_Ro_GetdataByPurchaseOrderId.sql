SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[usp_Ro_GetdataByPurchaseOrderId]
@Id int
as
 select ad.*,it.ITName as ItName,u1.UnitDescription as unitName
 ,at.AdjustmentTypeName as AdName from ROI_AdjustmentDetls ad
 inner join ROI_ITEMMain it on it.ITId=ad.ITId
 inner join ROI_Unit1 u1 on u1.Unit1Id=ad.UsedUnitId 
 inner join Ro_AdjustmentType  at on at.AdjustmentTypeID=ad.AdType
 --inner join ROI_PurchaseDetails pd on pd.PurchaseDetailsID=ad.PDId
 where ad.AMId = @Id



GO
