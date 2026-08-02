SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [usp_roi_goodsreceive] 'PO_129' 
-- DROP PROCEDURE [dbo].[usp_roi_goodsreceive]
CREATE PROCEDURE [dbo].[usp_roi_goodsreceive] @PONO NVARCHAR(250)
AS
BEGIN
	SELECT PM.PuNo
		,PD.ItemID
		,PD.PurchaseDetailsID
		,IM.ITName
		,PD.Quentity
		,PD.Quentity - sum(ISNULL(GD.Qnty, 0)) AS RemainingQnty
		,u1.Symbol
		,isnull(pd.conversion, 1) AS conversion
		,PD.RecqDetailId
		,rq.RecqId
		,PD.UnitRate
		,PD.Total
		,PM.IvNo AS InvoiceNo
		,PM.Vid as vendorId
		,isnull(PD.IsVat,0) as IsVat
		,isnull(PD.Discount,0) as Discount
			,u1.UnitDescription
	FROM DBO.ROI_PurchaseDetails PD
	INNER JOIN DBO.ROI_PurchaseMain PM ON PM.PurchaseMainID = PD.PurchaseMainID
	INNER JOIN DBO.ROI_ITEMMain IM ON IM.ITId = PD.ItemID
	LEFT JOIN DBO.RO_GoodsReceivedDetls GD ON GD.PDId = PD.PurchaseDetailsID
	LEFT JOIN ROI_Unit1 u1 ON u1.Unit1Id = pd.UsedUnitID
	LEFT JOIN Req_RecquistionDetails rqd ON rqd.RecqDetailId = PD.RecqDetailId
	LEFT JOIN Req_Recquistion rq ON rq.RecqId = rqd.RecqId
	LEFT JOIN RO_LoyaltyMembership lm ON lm.MembershipId = PM.Vid
	WHERE pm.PuNo = @PONO 
	GROUP BY PD.ItemID
		,PD.PurchaseDetailsID
		,IM.ITName
		,PD.Quentity
		,pd.conversion
		,u1.Symbol
		,PM.PuNo
		,PD.RecqDetailId
		,PD.Total
		,rq.RecqId
		,PD.UnitRate
		,Pm.IvNo
		,PM.Vid
		,PD.IsVat
		,PD.Discount
			,u1.UnitDescription
END

GO
