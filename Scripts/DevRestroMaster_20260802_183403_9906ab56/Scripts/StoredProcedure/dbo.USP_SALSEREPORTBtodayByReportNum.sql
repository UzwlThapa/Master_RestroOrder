SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[USP_SALSEREPORTBtodayByReportNum] '2018-1-1','2018-1-27',4
CREATE PROCEDURE [dbo].[USP_SALSEREPORTBtodayByReportNum] @Todaydate DATETIME
	,@enddate DATETIME
	,@ReportNum INT
AS
BEGIN
	IF @ReportNum = 1 --Void Bill
	BEGIN
		SELECT cast(CONVERT(VARCHAR(16), rom.DATE, 20) AS VARCHAR(120)) AS BillDate
			,rom.NetAmount
			,rom.UserName AS Waiter
			,rt.restrotableTitle
			,rr.restroRoom
			,rom.billNo
			,rom.TableId
			--,rom.salesMasterId
			,rom.OrderMasterId
		--,RBA.BilingID
		--,rbt.Name
		--,RBA.Amount
		FROM dbo.RO_OrderMasters rom
		LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = rom.TableId
		LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = rom.RoomId
		--LEFT JOIN RO_BillingAmount RBA ON RBA.SalesMasterID = rom.salesMasterId
		--LEFT JOIN dbo.RO_BillTerm rbt ON rbt.BilingID = RBA.BilingID
		WHERE cast(rom.DATE AS DATE) = @Todaydate
			AND rom.IsCancelled = 1
		ORDER BY BillDate DESC
			-- where CONVERT(date,om.BillDate)=CONVERT(DATE,getdate())
	END
			--select *  from dbo.RO_SalesMaster om left join dbo.RO_restroTable rt on rt.restrotableId = om.TableId left join RO_RestroRoom rr on rr.restroRoomId=om.RoomId
			--SELECT * FROM dbo.RO_OrderMasters
	ELSE IF @ReportNum = 2 --Vat Bill
	BEGIN
		SELECT cast(CONVERT(VARCHAR(16), om.BillDate, 20) AS VARCHAR(120)) AS BillDate
			,om.NetAmount
			,om.Waiter
			,rt.restrotableTitle
			,rr.restroRoom
			,om.billNo
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
		WHERE cast(om.BillDate AS DATE) = @Todaydate
		ORDER BY BillDate DESC
	END
	ELSE IF @ReportNum = 3 --Service Bill
	BEGIN
		SELECT cast(CONVERT(VARCHAR(16), om.BillDate, 20) AS VARCHAR(120)) AS BillDate
			,om.NetAmount
			,om.Waiter
			,rt.restrotableTitle
			,rr.restroRoom
			,om.billNo
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
		WHERE cast(om.BillDate AS DATE) = @Todaydate
		ORDER BY BillDate DESC
	END
	ELSE IF @ReportNum = 4 --Purchase Report
	BEGIN
		--SELECT lm.Fname AS VenderName
		--	,pm.PuNo
		--	,lm.MembershipID
		--	,lm.[Address]
		--	,pm.PurchaseMainID
		--	,pm.PostedOn
		--	,pm.PostedBy
		--	,im.ITName
		--	,pd.Quentity AS Qnty
		--	,u1.UnitDescription AS UnitName
		--	,pd.UnitRate
		--	--,pln.BatchNo
		--	--,pln.ExpDate
		--	--,pln.LotNo
		--	,fy.fyName
		--	,isnull(lm.IsVat,0) IsVat
		--FROM ROI_PurchaseMain pm
		--INNER JOIN ROI_PurchaseDetails pd ON pm.PurchaseMainID = pd.PurchaseMainID
		----LEFT JOIN ROI_PurchaseLotNo pln ON pln.PurchaseDetailsID = pd.PurchaseDetailsID
		--LEFT JOIN ROI_ITEMMain im ON im.ITId = pd.ItemID
		--LEFT JOIN ROI_Unit1 u1 ON u1.Unit1Id = pd.UsedUnitID
		--LEFT JOIN RO_LoyaltyMembership lm ON lm.MembershipID = pm.Vid
		--LEFT JOIN RO_fiscalYear fy ON fy.fyId = pm.FyId
		--WHERE cast(pm.PostedOn AS DATE) BETWEEN @Todaydate
		--		AND @enddate
		--ORDER BY pm.PurchaseMainID DESC
		SELECT
		  GM.GMNo AS PuNo,GM.InvoiceNo
		  ,Convert(varchar(10), GM.InvoiceDate,120) as PostedOn
		  ,GM.PostedBy
		  ,IM.ITName  
		  ,ISNULL(GD.Qnty,0) as Qnty
		  ,ISNULL(GD.Rate, PD.UnitRate) As UnitRate
		  ,convert(numeric(10,2), (ISNULL(GD.Total, GD.Qnty*PD.UnitRate))) AS BasicAmount
		  ,ISNULL(GD.IsVat, 0) as IsVat
		  ,case when GD.IsVat = 1 then convert(numeric(10,2), (ISNULL(GD.Total, GD.Qnty*PD.UnitRate))*0.13) else 0 end AS Vat
		  ,isnull(GD.Discount,0) as totaldiscount
		  ,u1.UnitDescription as UnitName
		  ,u1.Symbol
		  ,rl.Fname as VenderName
		  ,rl.Address
  	,(
			SELECT isnull(stuff((
							SELECT ' & ' + pms.PaymentMode
							FROM RO_PurchasePaymentMode spm
							INNER JOIN RO_PaymentModes pms ON spm.PaymentModeID = pms.PaymentModeID
							WHERE spm.GMId = GM.GMId--and spm.PaymentModeID = 4
							FOR XML PATH('')
								,TYPE
							).value('.', 'NVARCHAR(MAX)'), 1, 3, ''), '')
			) AS PayMode
	,fy.fyName
	 ,isnull(GM.ExtraDiscount, 0) as ExtraDiscount
 FROM RO_GoodsReceivedDetls GD  
 INNER JOIN RO_GoodsReceivedMain GM ON GM.GMId = GD.GMId
 left join ROI_PurchaseDetails PD ON  GD.PDId = PD.PurchaseDetailsID
 left join ROI_PurchaseMain pm on pm.PurchaseMainID = pd.PurchaseMainID
 INNER JOIN DBO.ROI_ITEMMain IM ON IM.ITId = PD.ItemID  
 left join ROI_Unit1 u1 on u1.Unit1Id=pd.UsedUnitID
 left join RO_LoyaltyMembership rl on rl.MembershipID = PD.VendorPurchaseId
  left join RO_PurchasePaymentMode ppm on ppm.GMId = GM.GMId
  LEFT JOIN RO_fiscalYear fy ON fy.fyId = pm.FyId
WHERE  1=1
		AND  (cast(GM.PostedOn AS DATE) >= @Todaydate OR @Todaydate=0 OR @Todaydate IS NULL OR @Todaydate='')
		AND (cast(GM.PostedOn AS DATE)<= @enddate OR @enddate=0 OR @enddate IS NULL OR @enddate='')

 and GD.Qnty <> 0
 GROUP BY GM.GMNo,IM.ITName,GD.Qnty,u1.Symbol,GD.Total,GD.Rate,GM.InvoiceDate,GM.InvoiceNo, rl.Fname,rl.Address
	 ,rl.IsVat,GD.Discount, GD.IsVat, GM.ExtraDiscount
	 ,u1.UnitDescription
	 ,PD.UnitRate
	 ,GM.GMId
 	,fy.fyName
	,GM.PostedBy
	END
	ELSE IF @ReportNum = 5 --Adjustment Report
	BEGIN
		SELECT am.AMId
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
		WHERE cast(am.PostedOn AS DATE) BETWEEN @Todaydate
				AND @enddate
		ORDER BY am.AMId DESC
	END
END



GO
