SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Usp_ro_getdataforprint 7     
CREATE PROCEDURE [dbo].[USP_RO_GetdataforPrint] @TableId INT
AS
DECLARE @Seatno INT
DECLARE @OrderMasterId INT

SELECT TOP 1 @OrderMasterId = ordermasterid
FROM ro_ordermasters
WHERE tableid = @TableId
	--OR roomid = @TableId
ORDER BY ordermasterid DESC

SELECT DISTINCT OD.orderdetailsid
	,OD.quantity
	,OD.rate
	,itd.itemcostcentreid
	,itd.itemdetailsid
	,CASE 
		WHEN itd.itemcostcentreid = 1
			OR itd.itemcostcentreid = 95
			OR itd.ItemCostCentreID = 97
			THEN OD.amount
		ELSE 0
		END AS Amount
	,CASE 
		WHEN itd.itemcostcentreid = 2
			THEN OD.amount
		ELSE 0
		END AS Bevrage
	,od.iscancelled
	,od.roi_itemid
	,om.ordermasterid
	,od.seatno
	,od.note
	,od.extracharge
	,od.billpaid
	,od.netamount
	,od.costcenterid
	,it.itname
	,ir.srate
	,itd.itcode
	,itd.dsunitid
	,it.pitid
	,om.roomid
	,om.billno
	,om.DATE
	,om.basicamount
	,om.termamount
	,om.remarks
	,om.username
	,om.issplit
	,om.guestno
	,rt.restrotableid
	,rt.restrotabletitle
	,rt.restroroomid
	,rt.restrotablesstatusid
	,od.costcenterid
	,om.netamount
	,
	-- sm.totaldiscount,             
	sm.cusname
	,sm.PAN
	,sm.[Address]
	,totaldiscount
	,(
		sm.InvoiceNo - (
			SELECT fy.firstsalesmasterid
			FROM dbo.ro_fiscalyear fy
			WHERE fy.fyid = sm.fiscalyearid
			)
		) AS BillNo
	,(
		SELECT fy.fyname
		FROM dbo.ro_fiscalyear fy
		WHERE fy.fyid = sm.fiscalyearid
		) AS fiscalYear
		,sm.salesMasterId,
	   sm.AddedBy as Cashier              
FROM dbo.ro_order_detail od
INNER JOIN dbo.roi_itemmain it ON it.itid = od.roi_itemid
INNER JOIN roi_itemdetails itd ON it.itid = itd.itid
LEFT JOIN roi_itemrate ir ON it.itid = ir.itemid
LEFT JOIN dbo.ro_ordermasters om ON om.ordermasterid = od.ordermasterid
LEFT JOIN dbo.ro_restrotable rt ON rt.restrotableid = om.tableid
LEFT JOIN dbo.ro_salesmaster sm ON sm.ordermasterid = om.ordermasterid
LEFT JOIN dbo.ro_restroroom rr ON rr.restroroomid = om.roomid
WHERE OD.ordermasterid = @OrderMasterId
	AND isnull(od.billpaid, 0) = 0
	AND om.billpaid = 1
	AND OD.IsCombo = 0

UNION

SELECT DISTINCT OD.orderdetailsid
	,OD.quantity
	,OD.rate
	,it.CostCenterID itemcostcentreid
	,it.ComboID itemdetailsid
	,CASE 
		WHEN it.CostCenterID = 1
			OR it.CostCenterID = 95
			OR it.CostCenterID = 97
			THEN OD.amount
		ELSE 0
		END AS Amount
	,CASE 
		WHEN it.CostCenterID = 2
			THEN OD.amount
		ELSE 0
		END AS Bevrage
	,od.iscancelled
	,od.roi_itemid
	,om.ordermasterid
	,od.seatno
	,od.note
	,od.extracharge
	,od.billpaid
	,od.netamount
	,od.costcenterid
	,it.NAME itname
	,it.SalesPrice srate
	,it.ComboCode itcode
	,0 dsunitid
	,0 pitid
	,om.roomid
	,om.billno
	,om.DATE
	,om.basicamount
	,om.termamount
	,om.remarks
	,om.username
	,om.issplit
	,om.guestno
	,rt.restrotableid
	,rt.restrotabletitle
	,rt.restroroomid
	,rt.restrotablesstatusid
	,od.costcenterid
	,om.netamount
	,
	-- sm.totaldiscount,             
	sm.cusname
	,sm.PAN
	,sm.[Address]
	,totaldiscount
	,(
		sm.InvoiceNo - (
			SELECT fy.firstsalesmasterid
			FROM dbo.ro_fiscalyear fy
			WHERE fy.fyid = sm.fiscalyearid
			)
		) AS BillNo
	,(
		SELECT fy.fyname
		FROM dbo.ro_fiscalyear fy
		WHERE fy.fyid = sm.fiscalyearid
		) AS fiscalYear
		,sm.salesMasterId,
	   sm.AddedBy as Cashier              
FROM dbo.ro_order_detail od
INNER JOIN dbo.RO_Combo it ON it.ComboID = od.roi_itemid
--INNER JOIN RO_ComboDetails itd             
--        ON it.ComboID = itd.ComboID               
LEFT JOIN dbo.ro_ordermasters om ON om.ordermasterid = od.ordermasterid
LEFT JOIN dbo.ro_restrotable rt ON rt.restrotableid = om.tableid
LEFT JOIN dbo.ro_salesmaster sm ON sm.ordermasterid = om.ordermasterid
LEFT JOIN dbo.ro_restroroom rr ON rr.restroroomid = om.roomid
WHERE om.ordermasterid = @OrderMasterId
	AND isnull(od.billpaid, 0) = 0
	AND om.billpaid = 1
	AND od.IsCombo = 1




GO
