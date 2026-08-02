SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--usp_roi_getOrderItemCancelReport '2019-05-23 0:0','2019-05-23 23:59', '', '', 0, 0, '', ''
--DROP PROC [dbo].[usp_roi_getOrderItemCancelReport] 
CREATE PROCEDURE [dbo].[usp_roi_getOrderItemCancelReport] 
@startDate DATETIME
	,@endDate DATETIME 
	,@cancelledby varchar(250)
	,@orderby varchar(250)
	,@room int
	,@table int
	,@responsible varchar(250)
	,@itemname varchar(250)
	,@CostCenterId int = 0
AS

 If @itemname<>''
	SET @itemname= '%'+ @itemname+'%'

SELECT odc.CanceledBy
	,odc.OrderBy
	,odc.item
	,odc.Quantity
	,odc.Reason
	,odc.[Date]
	,odc.Responsible
	,CASE when rom.OrderTypeID=4 Then 'Food Delivery' when rom.OrderTypeID=3 Then 'Food Court' else  isnull(rt.restrotableTitle, 'Take Away') END restrotableTitle
	,CASE when rom.OrderTypeID=4 Then 'Food Delivery' when rom.OrderTypeID=3 Then 'Food Court' else  isnull(rr.restroRoom, 'Take Away') END restroRoom
	--,rt.restrotableTitle
	--,rr.restroRoom
	,CAST(LEFT(CONVERT(TIME(0), odc.[Date]), 5) AS VARCHAR(128)) AS billtime
	,'' as ImagePath
FROM dbo.Order_Detail_Cancel odc
LEFT JOIN RO_restroTable rt ON odc.tableId = rt.restrotableId
LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = rt.restroRoomId
LEFT JOIN RO_OrderMasters rom ON rom.OrderMasterID= odc.orderMasterID
LEFT JOIN ROI_ITEMMain it ON odc.Item = it.ITName
LEFT JOIN ROI_ItemDetails itd ON it.ITId = itd.ITId
WHERE (
		odc.[date] BETWEEN DATEADD(HOUR,4, @startDate)
			AND DATEADD(HOUR,4, @endDate)
		)
		and (odc.CanceledBy=@cancelledby or @cancelledby = '' or @cancelledby is null) 
		and (odc.OrderBy=@orderby or @orderby = '' or @orderby  is null) 
		and (rt.restrotableId = @table or @table = 0)
		and (rr.restroRoomId = @room or @room=0)
		and (odc.Responsible = @responsible or @responsible = '' or @responsible is null) 
		And (odc.item like @itemname OR @itemname ='' OR @itemname is null)
		and (itd.ItemCostCentreID = @CostCenterId or @CostCenterId = 0)

UNION

--declare @startDate DATETIME='2017-10-27 0:0',@endDate DATETIME='2017-10-27 23:59'
SELECT rom.CancelBy
	,rom.UserName AS Waiter
	,ri.ITName
	,od.quantity
	,rom.cancelreason
	,rom.canceldate
	,rom.UserName AS Waiter
	,CASE when rom.OrderTypeID=4 Then 'Order Delivery' else  isnull(rt.restrotableTitle, 'Take Away') END restrotableTitle
	,CASE when rom.OrderTypeID=4 Then 'Order Delivery' else  isnull(rr.restroRoom, 'Take Away') END restroRoom
	--,rt.restrotableTitle
	--,rr.restroRoom
		,CAST(LEFT(CONVERT(TIME(0), od.[Date]), 5) AS VARCHAR(128)) AS billtime
		,itd.ImagePath
FROM dbo.RO_OrderMasters rom
LEFT JOIN RO_Order_Detail od ON rom.OrderMasterID = od.OrderMasterId
LEFT JOIN ROI_ITEMMain ri ON ri.ITId = od.ROI_ItemId
LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = rom.TableId
LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = rom.RoomId
LEFT JOIN ROI_ItemDetails itd ON od.ItemId = itd.ITId
WHERE (
		rom.[date] BETWEEN DATEADD(HOUR,4, @startDate)
			AND DATEADD(HOUR,4, @endDate)
		)
	AND rom.IsCancelled = 1
	and (rom.CancelBy=@cancelledby or @cancelledby = '' or @cancelledby is null) 
		and (rom.UserName =@orderby or @orderby = '' or @orderby is null) 
		and (rt.restrotableId = @table or @table = 0)
		and (rr.restroRoomId = @room or @room=0)
		and (rom.UserName = @responsible or @responsible = '' or @responsible is null) 
		And (ri.ITName like @itemname OR @itemname is null)
		and (itd.ItemCostCentreID = @CostCenterId or @CostCenterId = 0)
ORDER BY [date] DESC



GO
