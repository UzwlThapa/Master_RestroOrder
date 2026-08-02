SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GetdataforViewBilltest]
@OrderMasterID INT
AS
BEGIN
-----for footitem------------------------------------------------------
DECLARE @fooditem TABLE(Amount DECIMAL(18, 2))
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
WHERE om.BillPaid=1 AND itd.ItemCostCentreID='Kot' AND	om.IsCancelled=0 -- AND CAST(om.Date AS DATE)=CAST(GETDATE() AS DATE)  
AND om.OrderMasterID=@OrderMasterID
OR  om.BillPaid=1 AND itd.ItemCostCentreID='Kot' AND om.IsCancelled=0  -- AND CAST(om.Date AS DATE)=CAST(GETDATE() AS DATE) 
 AND om.OrderMasterID=@OrderMasterID
-----------------------------------------------------------------------



----------for bevrage item---------------------------------------------------

DECLARE @bevrage TABLE(Bevrage DECIMAL(18, 2))
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
WHERE  om.BillPaid=1 AND itd.ItemCostCentreID='Bar' AND om.IsCancelled=0 -- AND CAST(om.Date AS DATE)=CAST(GETDATE() AS DATE) 
 AND om.OrderMasterID=@OrderMasterID
OR   om.BillPaid=1 AND itd.ItemCostCentreID='Bar' AND om.IsCancelled=0 -- AND CAST(om.Date AS DATE)=CAST(GETDATE() AS DATE) 
 AND om.OrderMasterID=@OrderMasterID


 
------------------------------------------------------------------------------
SELECT DISTINCT od.OrderDetailsID,
          od.Quantity ,
         od.Rate ,
		ISNULL(f.Amount,0) AS Amount,
		 ISNULL(b.Bevrage,0) AS Bevrage,
         od.IsCancelled ,
           od.ItemId ,
         om.OrderMasterId ,
           od.SeatNo ,
           od.Note ,
           od.ExtraCharge ,
           od.BillPaid ,
           od.NetAmount ,
          od.CostCenterId ,
           it.ITName ,
           --it.ItemDescription ,
          itd.ImagePath,
           ir.SRate,
            itd.ITCode,
           itd.DSUnitId,
           it.PITId ,
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
		  om.NetAmount,
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
LEFT JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId=om.RoomId
LEFT JOIN @fooditem f ON f.Amount = od.Amount
LEFT JOIN @bevrage b ON b.Bevrage=od.Amount
WHERE  om.BillPaid=1  AND om.IsCancelled=0 -- AND CAST(om.Date AS DATE)=CAST(GETDATE() AS DATE) 
 AND om.OrderMasterID=@OrderMasterID
OR  om.BillPaid=1  AND om.IsCancelled=0 -- AND CAST(om.Date AS DATE)=CAST(GETDATE() AS DATE) 
 AND om.OrderMasterID=@OrderMasterID
END


GO
