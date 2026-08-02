SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GETDATABYYEARLYByReportNumber] @year VARCHAR(10)
	,@ReportNum INT
AS
--BEGIN
--select 
--om.BillDate,
--om.NetAmount,
--om.Waiter,
--rt.restrotableTitle,
--rr.restroRoom
--,om.billNo
--,om.TableId
--,salesMasterId
--,om.OrderMasterId
-- from dbo.RO_SalesMaster om
-- left join dbo.RO_restroTable rt on rt.restrotableId = om.TableId
-- left join RO_RestroRoom rr on rr.restroRoomId=om.RoomId
-- --where EXTRACT(Year FROM om.Date), EXTRACT(Month FROM om.Date)  = '2015-11'
-- where Year(om.BillDate)=@year
--END
BEGIN
	IF @ReportNum = 1 --Void Bill
	BEGIN
		SELECT cast(CONVERT(VARCHAR(16), rom.DATE, 20) AS VARCHAR(120)) AS BillDate
			,rom.NetAmount
			,rom.UserName AS Waiter
			,rt.restrotableTitle
			,rr.restroRoom
			--,rom.billNo
			--,'RO' + fy.fyName + '-' + cast((om.salesMasterId - fy.FirstSalesMasterID) AS VARCHAR(20)) AS billNo
			,rom.TableId
			--,rom.salesMasterId
			,rom.OrderMasterId
		--,RBA.BilingID
		--,rbt.Name
		--,RBA.Amount
		FROM dbo.RO_OrderMasters rom
		LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = rom.TableId
		LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = rom.RoomId
		--INNER JOIN RO_fiscalYear fy ON fy.fyId = om.FiscalYearID
		--LEFT JOIN RO_BillingAmount RBA ON RBA.SalesMasterID = rom.salesMasterId
		--LEFT JOIN dbo.RO_BillTerm rbt ON rbt.BilingID = RBA.BilingID
		WHERE Year(rom.DATE) = @year
			AND rom.IsCancelled = 1
		ORDER BY BillDate DESC
			-- where CONVERT(date,om.BillDate)=CONVERT(DATE,getdate())
	END
	--select * from dbo.RO_SalesMaster
	--select * from dbo.RO_OrderMasters
	--select * from dbo.RO_Order_Detail
			--select *  from dbo.RO_SalesMaster om left join dbo.RO_restroTable rt on rt.restrotableId = om.TableId left join RO_RestroRoom rr on rr.restroRoomId=om.RoomId
			--SELECT * FROM dbo.RO_OrderMasters
	ELSE IF @ReportNum = 2 --Vat Bill
	BEGIN
		SELECT cast(CONVERT(VARCHAR(16), om.BillDate, 20) AS VARCHAR(120)) AS BillDate
			,om.NetAmount
			,om.Waiter
			,rt.restrotableTitle
			,rr.restroRoom
			--,om.billNo
			,om.TableId
			,om.salesMasterId
			,om.OrderMasterId
			,RBA.BilingID
			,rbt.NAME AS BillTerm
			,RBA.Amount
		FROM dbo.RO_SalesMaster om
		LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
		LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = om.RoomId
		LEFT JOIN RO_BillingAmount RBA ON RBA.SalesMasterID = om.salesMasterId
		LEFT JOIN dbo.RO_BillTerm rbt ON rbt.BilingID = RBA.BilingID
		WHERE Year(om.BillDate) = @year
		ORDER BY BillDate DESC
	END
	ELSE IF @ReportNum = 3 --Service Bill
	BEGIN
		SELECT cast(CONVERT(VARCHAR(16), om.BillDate, 20) AS VARCHAR(120)) AS BillDate
			,om.NetAmount
			,om.Waiter
			,rt.restrotableTitle
			,rr.restroRoom
			--,om.billNo
			,om.TableId
			,om.salesMasterId
			,om.OrderMasterId
			,RBA.BilingID
			,rbt.NAME AS BillTerm
			,RBA.Amount
		FROM dbo.RO_SalesMaster om
		LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
		LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = om.RoomId
		LEFT JOIN RO_BillingAmount RBA ON RBA.SalesMasterID = om.salesMasterId
		LEFT JOIN dbo.RO_BillTerm rbt ON rbt.BilingID = RBA.BilingID
		WHERE Year(om.BillDate) = @year
		ORDER BY BillDate DESC
	END
	ELSE IF @ReportNum = 4 --Purchase Report
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
		WHERE Year(pm.PostedOn) = @year
		ORDER BY pm.PurchaseMainID DESC
	END
	ELSE IF @ReportNum = 5 --Adjustment Report
	BEGIN
		SELECT distinct am.AMId
		,am.AMNo
			,fy.fyName
			,st.StName
			,am.PostedOn
			,am.PostedBy
			,im.ITName
			,ad.Qnty
			,u1.UnitDescription AS UnitName
			,at.AdjustmentTypeName
		 FROM ROI_AdjustmentMain am
		JOIN ROI_AdjustmentDetls ad ON ad.AMId = am.AMId
		LEFT JOIN Ro_AdjustmentType at ON at.AdjustmentTypeID = ad.AdType
		LEFT JOIN RO_fiscalYear fy ON fy.fyId = am.FYId
		LEFT JOIN ROI_Store st ON st.STId = am.STId
		LEFT JOIN ROI_ITEMMain im ON im.ITId = ad.ITId
		LEFT JOIN ROI_Unit1 u1 ON u1.Unit1Id = ad.UsedUnitId
		WHERE Year(am.PostedOn) = @year
		ORDER BY am.AMId DESC
	END
END



GO
