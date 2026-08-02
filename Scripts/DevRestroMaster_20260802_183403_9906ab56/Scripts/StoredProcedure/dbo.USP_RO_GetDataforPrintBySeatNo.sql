SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --  Usp_ro_getdataforprintbyseatno 1,1    
CREATE PROCEDURE [dbo].[USP_RO_GetDataforPrintBySeatNo]     
@TableId INT,     
@Seatno  INT     
AS     
    
DECLARE @OrderMasterId INT     
    
SELECT TOP 1 @OrderMasterId = ordermasterid     
FROM   ro_ordermasters     
WHERE  tableid = @TableId     
      --  OR roomid = @TableId     
ORDER  BY ordermasterid DESC     
SELECT DISTINCT  OD.orderdetailsid,     
       OD.quantity,     
       OD.rate,     
       itd.itemcostcentreid,     
       itd.itemdetailsid,    
    CASE     
         WHEN itd.itemcostcentreid = 1     
               OR itd.itemcostcentreid = 95 THEN OD.amount     
         ELSE 0     
       END AS Amount,     
       CASE     
         WHEN itd.itemcostcentreid = 2 THEN OD.amount     
         ELSE 0     
       END AS Bevrage,     
       od.iscancelled,     
       od.roi_itemid,     
       om.ordermasterid,     
       od.seatno,     
       od.note,     
       od.extracharge,     
       od.billpaid,     
       od.netamount,     
       od.costcenterid,     
       it.itname,     
       ir.srate,     
       itd.itcode,     
       itd.dsunitid,     
       it.pitid ,     
       om.roomid,     
       om.billno,     
       om.date,     
       om.basicamount,     
       om.termamount,     
       om.remarks,     
       om.username,     
       om.issplit,     
       om.guestno,     
       rt.restrotableid,     
       rt.restrotabletitle,     
       rt.restroroomid,     
       rt.restrotablesstatusid,     
       od.costcenterid,     
       om.netamount,       
       sm.cusname,     
    totaldiscount,    
       ( sm.InvoiceNo - (SELECT fy.firstsalesmasterid     
                             FROM   dbo.ro_fiscalyear fy     
                             WHERE  fy.fyid = sm.fiscalyearid) )     
       AS     
       BillNo,     
       (SELECT fy.fyname     
        FROM   dbo.ro_fiscalyear fy     
        WHERE  fy.fyid = sm.fiscalyearid)     
       AS     
       fiscalYear     
	   ,sm.salesMasterId     
FROM   dbo.ro_order_detail od     
       INNER JOIN dbo.roi_itemmain it     
               ON it.itid = od.roi_itemid     
       INNER JOIN roi_itemdetails itd     
               ON it.itid = itd.itid     
       LEFT JOIN roi_itemrate ir     
              ON it.itid = ir.itemid     
       LEFT JOIN dbo.ro_ordermasters om     
              ON om.ordermasterid = od.ordermasterid     
       LEFT JOIN dbo.ro_restrotable rt     
              ON rt.restrotableid = om.tableid     
       LEFT JOIN dbo.ro_salesmaster sm     
              ON sm.ordermasterid = om.ordermasterid and SM.SeatNo = @Seatno    
       LEFT JOIN dbo.ro_restroroom rr     
              ON rr.restroroomid = om.roomid     
WHERE  OD.ordermasterid = @OrderMasterId     
       AND OD.seatno = @Seatno     
       AND OD.billpaid = 1     
    and OD.IsCombo = 0  
  
    UNION  
  
  
    SELECT DISTINCT  OD.orderdetailsid,     
       OD.quantity,     
       OD.rate,     
       it.CostCenterID  itemcostcentreid,     
       it.ComboID itemdetailsid,    
    CASE     
         WHEN it.CostCenterID = 1     
               OR it.CostCenterID = 95 THEN OD.amount     
         ELSE 0     
       END AS Amount,     
       CASE     
         WHEN it.CostCenterID = 2 THEN OD.amount     
         ELSE 0     
       END AS Bevrage,     
       od.iscancelled,     
       od.roi_itemid,     
       om.ordermasterid,     
       od.seatno,     
       od.note,     
       od.extracharge,     
       od.billpaid,     
       od.netamount,     
       od.costcenterid,     
       it.Name itname,     
       it.SalesPrice srate,     
       it.ComboCode itcode,     
       0 dsunitid,     
       it.ComboID ,     
       om.roomid,     
       om.billno,     
       om.date,     
       om.basicamount,     
       om.termamount,     
       om.remarks,     
       om.username,     
       om.issplit,     
       om.guestno,     
       rt.restrotableid,     
       rt.restrotabletitle,     
       rt.restroroomid,     
       rt.restrotablesstatusid,     
       od.costcenterid,     
       om.netamount,       
       sm.cusname,     
    totaldiscount,    
       ( sm.InvoiceNo - (SELECT fy.firstsalesmasterid     
                             FROM   dbo.ro_fiscalyear fy     
                             WHERE  fy.fyid = sm.fiscalyearid) )     
       AS     
       BillNo,     
       (SELECT fy.fyname     
        FROM   dbo.ro_fiscalyear fy     
        WHERE  fy.fyid = sm.fiscalyearid)     
       AS     
       fiscalYear
	   ,sm.salesMasterId     
FROM   dbo.ro_order_detail od     
       INNER JOIN dbo.RO_Combo it     
               ON it.ComboID = od.roi_itemid     
       --INNER JOIN roi_itemdetails itd     
       --        ON it.itid = itd.itid     
       --LEFT JOIN roi_itemrate ir     
       --       ON it.itid = ir.itemid     
       LEFT JOIN dbo.ro_ordermasters om     
              ON om.ordermasterid = od.ordermasterid     
       LEFT JOIN dbo.ro_restrotable rt     
              ON rt.restrotableid = om.tableid     
       LEFT JOIN dbo.ro_salesmaster sm     
              ON sm.ordermasterid = om.ordermasterid and SM.SeatNo = @Seatno    
       LEFT JOIN dbo.ro_restroroom rr     
              ON rr.restroroomid = om.roomid     
WHERE  OD.ordermasterid = @OrderMasterId     
       AND OD.seatno = @Seatno     
       AND OD.billpaid = 1     
    and OD.IsCombo = 1 



GO
