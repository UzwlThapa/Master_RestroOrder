SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[usp_roi_getPurchaseReport] '2017-01-03 0:0' , '2017-03-31 23:59'
CREATE PROCEDURE [dbo].[usp_roi_getPurchaseReport] @startdate DATETIME
	,@enddate DATETIME
AS
BEGIN
		SELECT lm.Fname AS VenderName
		,pm.PuNo
			,lm.MembershipID
			,fy.fyName
			,lm.[Address]
			,pm.PurchaseMainID
			,pm.PostedOn
			,pm.PostedBy
			,im.ITName
			,pd.Quentity as Qnty
			,u1.UnitDescription AS UnitName
			,pd.UnitRate
			,pln.BatchNo
			,pln.ExpDate
			,pln.LotNo
		FROM ROI_PurchaseMain pm
		INNER JOIN ROI_PurchaseDetails pd ON pm.PurchaseMainID = pd.PurchaseMainID
		LEFT JOIN ROI_PurchaseLotNo pln ON pln.PurchaseDetailsID = pd.PurchaseDetailsID
		LEFT JOIN ROI_ITEMMain im ON im.ITId = pd.ItemID
		LEFT JOIN ROI_Unit1 u1 ON u1.Unit1Id = pd.UsedUnitID
		LEFT JOIN RO_LoyaltyMembership lm ON lm.MembershipID = pm.Vid
		LEFT JOIN RO_fiscalYear fy ON fy.fyId = pm.FyId
		--WHERE cast(pm.PostedOn AS DATE) = @Todaydate
		--where Year(pm.PostedOn)=@year and Month(pm.PostedOn)=@month
		WHERE 
		pm.PostedOn BETWEEN @startDate
				AND @endDate
		--Year(pm.PostedOn) = @year
		ORDER BY pm.PurchaseMainID DESC
END



GO
