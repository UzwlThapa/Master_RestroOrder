SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROC USP_Req_GetRecquistionDetails
CREATE PROCEDURE [dbo].[USP_Req_GetRecquistionDetails] @IsMainStore BIT
AS
IF (@IsMainStore = 0)
	SELECT rqd.RecqDetailId
		,rqd.RecqId
		,rqd.ItemId
		,im.ITName AS ItemName
		,rqd.Quantity
		,rqd.Unit
		,ISNULL(sum(il.IssuedQuantity), 0) AS IssueQuantity
		,u.Symbol AS Symbol
		,iss.ItemStatus AS [Status]
	FROM Req_RecquistionDetails rqd
	INNER JOIN Req_Recquistion rq ON rq.RecqId = rqd.RecqId
	LEFT JOIN ROI_ITEMMain im ON im.ITId = rqd.ItemId
	LEFT JOIN ROI_Unit1 u ON u.Unit1Id = rqd.Unit
	LEFT JOIN RO_ItemStatus iss ON iss.StatusID = rqd.StatusId
	LEFT JOIN Req_IssueLog il ON il.RecqDetailId = rqd.RecqDetailId
	WHERE ISNULL(rq.IsDeleted, 0) = 0
		AND rq.ParentStore > 0
		and rqd.ItemId != 0
	GROUP BY rqd.RecqDetailId
		,rqd.RecqId
		,rqd.ItemId
		,im.ITName
		,rqd.Quantity
		,rqd.Unit
		,u.Symbol
		,iss.ItemStatus
ELSE
	SELECT rqd.RecqDetailId
		,rqd.RecqId
		,rqd.ItemId
		,im.ITName AS ItemName
		,rqd.Quantity
		,rqd.Unit
		,ISNULL(sum(rqd.IssuedQuantity), 0) AS IssueQuantity
		,u.Symbol AS Symbol
		,iss.ItemStatus AS [Status]
		,rv.VendorId
		,rl.Fname as vendorName
	FROM Req_RecquistionDetails rqd
	INNER JOIN Req_Recquistion rq ON rq.RecqId = rqd.RecqId
	LEFT JOIN ROI_ITEMMain im ON im.ITId = rqd.ItemId
	LEFT JOIN ROI_Unit1 u ON u.Unit1Id = rqd.Unit
	LEFT JOIN RO_ItemStatus iss ON iss.StatusID = rqd.StatusId
	LEFT JOIN Req_IssueLog il ON il.RecqDetailId = rqd.RecqDetailId
	LEFT JOIN RO_VendorPurchase rv on rv.RecqDetailId = rqd.RecqDetailId
	left join RO_LoyaltyMembership rl on rv.VendorId = rl.MembershipID
	WHERE ISNULL(rq.IsDeleted, 0) = 0
		AND rq.ParentStore = 0
		
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

GO
