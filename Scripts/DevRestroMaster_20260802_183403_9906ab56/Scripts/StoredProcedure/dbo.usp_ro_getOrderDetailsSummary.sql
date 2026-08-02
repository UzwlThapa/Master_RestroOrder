SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP proc usp_ro_getOrderDetailsSummary '02/19/2019','02/19/2019',0,0
CREATE PROCEDURE [dbo].[usp_ro_getOrderDetailsSummary] 
@startDate date,
@endDate date,
@tableId int,
@costCenter int
as
select im.ITName as ItemName
,sum (isnull(od.Quantity,0)) as Quantity
,isnull(od.Rate,0) as Rate
,ci.CostCenterName
 from RO_Order_Detail od
inner join RO_OrderMasters om on od.OrderMasterId = om.OrderMasterID
left join RO_restroTable rt on rt.restrotableId = om.TableId
inner join ROI_ITEMMain im on im.ITId = od.ROI_ItemId 
--and isnull(od.IsCombo,0) = 0
inner join CostCenterInfo ci on ci.CostCenterId = od.CostCenterId
where isnull(od.IsCancelled,0) = 0
and (om.TableId = @tableId or @tableId = 0)
and (cast(od.Date as Date) between @startDate and @endDate)
and (od.CostCenterId = @costCenter or @costCenter=0)
and od.IsCombo=0
group by  im.ITName,od.Rate,ci.CostCenterName
 union

 select im.Name as ItemName
,sum (isnull(od.Quantity,0)) as Quantity
,isnull(od.Rate,0) as Rate
,ci.CostCenterName
 from RO_Order_Detail od
inner join RO_OrderMasters om on od.OrderMasterId = om.OrderMasterID
left join RO_restroTable rt on rt.restrotableId = om.TableId
inner join RO_Combo im on im.ComboID = od.ROI_ItemId
-- and isnull(od.IsCombo,1) = 0
inner join CostCenterInfo ci on ci.CostCenterId = od.CostCenterId
where isnull(od.IsCancelled,0) = 0
and (om.TableId = @tableId or @tableId = 0)
and (cast(od.Date as Date) between @startDate and @endDate)
and (od.CostCenterId = @costCenter or @costCenter=0)
and od.IsCombo=1
group by  im.Name,od.Rate,ci.CostCenterName

GO
