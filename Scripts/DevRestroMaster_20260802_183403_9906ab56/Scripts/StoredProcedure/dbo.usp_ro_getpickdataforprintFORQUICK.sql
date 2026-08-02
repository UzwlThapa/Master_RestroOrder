SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[usp_ro_getpickdataforprint] 0
CREATE PROCEDURE [dbo].[usp_ro_getpickdataforprintFORQUICK]
@TableId INT
AS
BEGIN
DECLARE @OrderMasterId VARCHAR(128)
SELECT @OrderMasterId=OrderMasterID FROM dbo.RO_OrderMasters WHERE OID=@TableId

-----for footitem------------------------------------------------------
DECLARE @fooditem TABLE(Amount DECIMAL(8,2))
INSERT INTO @fooditem
	SELECT od.Amount
 FROM dbo.RO_Order_Detail od
INNER JOIN 
dbo.ROI_ITEMMain it ON it.ITId = od.ROI_ItemId
Inner Join 
ROI_ItemDetails itd ON it.ITId = itd.ITId
left JOIN 
ROI_ItemRate ir ON it.ITId = ir.ItemID
left JOIN 
dbo.RO_OrderMasters om ON om.OrderMasterID = od.OrderMasterId
left JOIN
dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
LEFT JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId=om.RoomId
WHERE om.OrderMasterID=@OrderMasterId AND om.BillPaid=1 AND (itd.ItemCostCentreID=1 OR itd.ItemCostCentreID=95) AND om.IsPrinted=0
 OR om.OrderMasterID=@OrderMasterId AND om.BillPaid=1 AND (itd.ItemCostCentreID=1 OR itd.ItemCostCentreID=95) AND om.IsPrinted=0
-----------------------------------------------------------------------

----------for bevrage item---------------------------------------------------

DECLARE @bevrage TABLE(Bevrage DECIMAL(8,2))
INSERT INTO @bevrage
SELECT od.Amount
  FROM dbo.RO_Order_Detail od
INNER JOIN 
dbo.ROI_ITEMMain it ON it.ITId = od.ROI_ItemId
Inner Join 
ROI_ItemDetails itd ON it.ITId = itd.ITId
left JOIN 
ROI_ItemRate ir ON it.ITId = ir.ItemID
left JOIN  
dbo.RO_OrderMasters om ON om.OrderMasterID = od.OrderMasterId
left JOIN
dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
LEFT JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId=om.RoomId
WHERE om.OrderMasterID=@OrderMasterId AND om.BillPaid=1 AND itd.ItemCostCentreID=2 AND om.IsPrinted=0
OR om.OrderMasterID=@OrderMasterId AND om.BillPaid=1 AND itd.ItemCostCentreID=2 AND om.IsPrinted=0

------------------------------------------------------------------------------
--SELECT * FROM @fooditem
--SELECT * FROM @bevrage
SELECT DISTINCT od.OrderDetailsID,
          od.Quantity ,
         od.Rate ,
         CASE WHEN (itd.ItemCostCentreID=1 OR itd.ItemCostCentreID=95) THEN  f.Amount ELSE 0 END AS Amount,
		 CASE WHEN itd.ItemCostCentreID=2 THEN b.Bevrage ELSE 0 end AS Bevrage,
         od.IsCancelled ,
           od.ROI_ItemId ,
         od.OrderMasterId ,
           od.SeatNo ,
           od.Note ,
           od.ExtraCharge ,
           om.BillPaid ,
           od.NetAmount ,
          od.CostCenterId ,
           it.ITName ,
		   it.PITId,
          om.RoomId ,
       om.BillNo,
         om.Date ,
         om.BasicAmount ,
           om.TermAmount,
         om.Remarks,
            om.UserName,
         om.IsSplit,
           om.GuestNo,
          rt.restrotableId,
           rt.restrotableTitle ,
           rt.restroRoomId,
          rt.restrotablesStatusID,
		  od.CostCenterId,
		  sm.totaldiscount
  FROM dbo.RO_Order_Detail od
INNER JOIN 
dbo.ROI_ITEMMain it ON it.ITId = od.ROI_ItemId
Inner Join 
ROI_ItemDetails itd ON it.ITId = itd.ITId
left JOIN 
ROI_ItemRate ir ON it.ITId = ir.ItemID
left JOIN  
dbo.RO_OrderMasters om ON om.OrderMasterID = od.OrderMasterId
left JOIN
dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
LEFT JOIN dbo.RO_SalesMaster sm ON sm.OrderMasterId=om.OrderMasterID
LEFT JOIN @fooditem f ON f.Amount = od.Amount
LEFT JOIN @bevrage b ON b.Bevrage=od.Amount
LEFT JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId=om.RoomId
WHERE om.OrderMasterID=@OrderMasterId AND om.BillPaid=0 AND om.IsPrinted=0
END	





GO
