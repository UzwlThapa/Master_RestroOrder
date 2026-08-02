SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getPurchaseReportByPuNo] 
@puNo nvarchar(250)
as
SELECT lm.Fname AS VenderName
		,pm.PuNo
			,lm.MembershipID
			,lm.[Address]
			,pm.PurchaseMainID
			,pm.PostedOn
			,pm.PostedBy
			,im.ITName
			,pd.Quentity as Qnty
			,u1.UnitDescription AS UnitName
			,pd.UnitRate
			--,pln.BatchNo
			--,pln.ExpDate
			--,pln.LotNo
			,fy.fyName
			,lm.IsVat
		 FROM ROI_PurchaseMain pm
		INNER JOIN ROI_PurchaseDetails pd ON pm.PurchaseMainID = pd.PurchaseMainID
		--LEFT JOIN ROI_PurchaseLotNo pln ON pln.PurchaseDetailsID = pd.PurchaseDetailsID
		LEFT JOIN ROI_ITEMMain im ON im.ITId = pd.ItemID
		LEFT JOIN ROI_Unit1 u1 ON u1.Unit1Id = pd.UsedUnitID
		LEFT JOIN RO_LoyaltyMembership lm ON lm.MembershipID = pm.Vid
		LEFT JOIN RO_fiscalYear fy ON fy.fyId = pm.FyId
		WHERE pm.PuNo=@puNo
		ORDER BY pm.PurchaseMainID DESC



GO
