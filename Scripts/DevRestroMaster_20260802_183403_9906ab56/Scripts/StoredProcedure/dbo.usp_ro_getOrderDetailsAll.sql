SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----DROP proc usp_ro_getOrderDetailsAll  '02/19/2019','02/19/2019',0,0
CREATE PROCEDURE [dbo].[usp_ro_getOrderDetailsAll] 
@startDate datetime,
@endDate datetime,
@tableId int,
@costCenter int
as
select od.Date
,im.ITName as ItemName
, od.Quantity
,od.Rate
--,isnull(rt.restrotableTitle,'Take Away') restrotableTitle
,CASE when om.OrderTypeID=4 Then 'Food Delivery' when om.OrderTypeID=3 Then 'Food Court' else  isnull(rt.restrotableTitle, 'Take Away') END restrotableTitle
,ci.CostCenterName
 from RO_Order_Detail od
inner join RO_OrderMasters om on od.OrderMasterId = om.OrderMasterID
left join RO_restroTable rt on rt.restrotableId = om.TableId
inner join ROI_ITEMMain im on im.ITId = od.ROI_ItemId and isnull(od.IsCombo,0) = 0
inner join CostCenterInfo ci on ci.CostCenterId = od.CostCenterId
where isnull(od.IsCancelled,0) = 0
and (om.TableId = @tableId or @tableId = 0)
and (cast(od.Date AS DATE) >= @startDate OR @startDate=0 OR @startDate IS NULL OR @startDate='')
and (cast(od.Date AS DATE) <= @endDate OR @endDate=0 OR @endDate IS NULL OR @endDate='')
and (od.CostCenterId = @costCenter or @costCenter=0)
and od.IsCombo=0

 union 

 select od.Date
,im.Name as ItemName
, od.Quantity
,od.Rate
--,isnull(rt.restrotableTitle,'Take Away') restrotableTitle
,CASE when om.OrderTypeID=4 Then 'Food Delivery' when om.OrderTypeID=3 Then 'Food Court' else  isnull(rt.restrotableTitle, 'Take Away') END restrotableTitle
,ci.CostCenterName
 from RO_Order_Detail od
inner join RO_OrderMasters om on od.OrderMasterId = om.OrderMasterID
left join RO_restroTable rt on rt.restrotableId = om.TableId
inner join RO_Combo im on im.ComboID = od.ROI_ItemId and isnull(od.IsCombo,1) = 1
inner join CostCenterInfo ci on ci.CostCenterId = od.CostCenterId
where isnull(od.IsCancelled,0) = 0
and (om.TableId = @tableId or @tableId = 0)
and (cast(od.Date AS DATE) >= @startDate OR @startDate=0 OR @startDate IS NULL OR @startDate='')
and (cast(od.Date AS DATE) <= @endDate OR @endDate=0 OR @endDate IS NULL OR @endDate='')
and (od.CostCenterId = @costCenter or @costCenter=0)
and od.IsCombo=1

ORDER BY od.Date, im.ITName

GO
