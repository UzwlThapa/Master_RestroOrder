SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- DROP PROCEDURE usp_ro_GetPreviousItemByOrderMasterId 14
-- @OID = OrderMasterId
CREATE PROCEDURE [dbo].[usp_ro_GetPreviousItemByOrderMasterId]  @OID INT
AS
BEGIN

	SELECT ITName AS ItemName
		,ROI_ItemID AS ItemId
		,sum(OD.Quantity) as Quantity
		,OD.SeatNo
		,OD.OrderMasterId
		,om.TableId
		,iss.ItemStatus
		--,od.ExtraCharge
		,om.GuestNo
		,om.UserName as Waiter
		,  (SELECT  t1.Note +CASE WHEN t1.Note IS NOT NULL AND t1.Note<>'' THEN '('+ CAST(t1.Quantity as VARCHAR(3))+');' END
    FROM RO_Order_Detail t1
    WHERE (t1.OrderMasterId=od.OrderMasterId and t1.ROI_ItemID = od.ROI_ItemID and t1.iscancelled=0 and t1.IsCombo=0) 
    FOR XML PATH('')) AS  Note
		,od.BillPaid
		,om.IsSplit
		,0 isCombo
		,ot.CustomerID
		,ot.CustomerName
		,ot.Phone
		,isnull(ot.TokenNo,0) TokenNo 
		,isnull(om.OrderNo,0) OrderNo
		,od.Rate as SRate
		,ot.Address
		--,od.OrderDetailsID
	FROM RO_Order_Detail od
	INNER JOIN RO_OrderMasters om ON od.OrderMasterId = om.OrderMasterId
	INNER JOIN ROI_ITEMMain im ON im.ITId = od.ROI_ItemId
	LEFT JOIN dbo.RO_OrderItemStatus os ON os.OrderDetailID = od.OrderDetailsID
	LEFT JOIN dbo.RO_ItemStatus iss ON iss.StatusID = os.StatusID
	LEFT JOIN RO_OrderToken ot on ot.OrderMasterId = om.OrderMasterId
	WHERE  om.BillPaid = 0
		AND om.IsCancelled = 0
		AND od.IsCancelled = 0
		AND om.OrderMasterID = @OID
		AND ISCombo = 0
		and isnull(od.BillPaid,0) != 1
	group by ITName 
		,ROI_ItemID
		,OD.SeatNo
		,OD.OrderMasterId
		,om.TableId
		,iss.ItemStatus
		,om.GuestNo
		,om.UserName
		,od.BillPaid
		,om.IsSplit
		,ot.CustomerID
		,ot.CustomerName
		,ot.Phone
		,ot.TokenNo
		,om.OrderNo
		,od.Rate 
		,ot.Address
		--,od.OrderDetailsID
	UNION
	
	SELECT cm.Name AS ItemName
		,ROI_ItemID AS ItemId
		,sum(OD.Quantity) as Quantity
		,OD.SeatNo
		,OD.OrderMasterId
		,om.TableId
		,iss.ItemStatus
		,om.GuestNo
		,om.UserName as Waiter
		,  (SELECT  t1.Note +CASE WHEN t1.Note IS NOT NULL AND t1.Note<>'' THEN '('+ CAST(t1.Quantity as VARCHAR(3))+');' END
    FROM RO_Order_Detail t1
    WHERE (t1.OrderMasterId=od.OrderMasterId and t1.ROI_ItemID = od.ROI_ItemID and t1.iscancelled=0 and t1.IsCombo=1) 
    FOR XML PATH('')) AS  Note
		,od.BillPaid
		,om.IsSplit
		,1 isCombo
			,ot.CustomerID
		,ot.CustomerName
		,ot.Phone
		,isnull(ot.TokenNo,0) TokenNo 
		,isnull(om.OrderNo,0) OrderNo
		,od.Rate as SRate
		,ot.Address
		--,od.OrderDetailsID
	FROM RO_Order_Detail od
	INNER JOIN RO_OrderMasters om ON od.OrderMasterId = om.OrderMasterId
	INNER JOIN RO_Combo cm ON cm.ComboID = od.ROI_ItemId
	LEFT JOIN dbo.RO_OrderItemStatus os ON os.OrderDetailID = od.OrderDetailsID
	LEFT JOIN dbo.RO_ItemStatus iss ON iss.StatusID = os.StatusID
		LEFT JOIN RO_OrderToken ot on ot.OrderMasterId = om.OrderMasterId
	WHERE  om.BillPaid = 0
		AND om.IsCancelled = 0
		AND od.IsCancelled = 0
		AND om.OrderMasterID = @OID
		AND ISCombo = 1
		and isnull(od.BillPaid,0) != 1
		Group by cm.Name 
		,ROI_ItemID 
		,OD.SeatNo
		,OD.OrderMasterId
		,om.TableId
		,iss.ItemStatus
		,om.GuestNo
		,om.UserName
		,od.BillPaid
		,om.IsSplit
		,ot.CustomerID
		,ot.CustomerName
		,ot.Phone
		,ot.TokenNo
		,om.OrderNo
		,od.Rate 
		,ot.Address
		--,od.OrderDetailsID
END



GO
