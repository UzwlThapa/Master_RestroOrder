SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	--DROP procedure USP_getDetailsFromVendor
	CREATE PROCEDURE [dbo].[USP_getDetailsFromVendor]
	@VendorId INT
	As
--declare @VendorId INT = 26
SELECT rqd.RecqDetailId
		,rqd.RecqId
		,rqd.ItemId as ItemID
		,im.ITName 
		,(rqd.Quantity-sum(isnull(rg.Qnty,0))) as Quentity
	--,rqd.Quantity as Quentity
	,rqd.Unit as UnitId
		,u.Symbol AS UnitName
		,iss.ItemStatus AS [Status]
		,rv.VendorId as vendor
		,rl.Fname
		,isnull(ru.Conversion,1) as Conversion
	FROM Req_RecquistionDetails rqd
	INNER JOIN Req_Recquistion rq ON rq.RecqId = rqd.RecqId
	LEFT JOIN ROI_ITEMMain im ON im.ITId = rqd.ItemId
	LEFT JOIN ROI_Unit1 u ON u.Unit1Id = rqd.Unit
	LEFT JOIN RO_ItemStatus iss ON iss.StatusID = rqd.StatusId
	LEFT JOIN Req_IssueLog il ON il.RecqDetailId = rqd.RecqDetailId
	LEFT JOIN RO_VendorPurchase rv on rv.RecqDetailId = rqd.RecqDetailId
	left join RO_LoyaltyMembership rl on rv.VendorId = rl.MembershipID
	left join ROI_Unit2 ru on ru.FirstUnit = rqd.Unit
	left join ROI_PurchaseDetails rp on rp.RecqDetailId = rqd.RecqDetailId
	left join RO_GoodsReceivedDetls rg on rg.PDId = rp.PurchaseDetailsID
	WHERE ISNULL(rq.IsDeleted, 0) = 0
		AND iss.StatusID != 4
		AND (isnull(ru.IsArchived,0) != 1  or isnull(u.IsArchived,0) != 1)
		AND rv.VendorId = @VendorId
		--AND	ru.IsArchived=0
	GROUP BY rqd.RecqDetailId
		,rqd.RecqId
		,rqd.ItemId
		,im.ITName
		,rqd.Quantity
		,rqd.Unit
		,u.Symbol
		,iss.ItemStatus
		,rv.VendorId
		,rl.Fname
		,ru.Conversion

GO
