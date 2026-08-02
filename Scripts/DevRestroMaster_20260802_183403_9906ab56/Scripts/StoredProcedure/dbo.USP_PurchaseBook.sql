SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--USP_PurchaseBook  '2023/09/01','2023/09/01'
CREATE PROCEDURE [dbo].[USP_PurchaseBook] 
@StartDate datetime
,@EndDate datetime
as
BEGIN

----=================TEMP TABLE TO STORE VATABLE DATA======================
IF (OBJECT_ID('tempdb..#TempTable') is not null)
drop table #TempTable

select GM.GMID, GM.InvoiceNo, GM.vendorId, isnull(sum(GD.Discount), 0) as Discount
,isnull(SUM(GD.Total),0) as VatTotal, 1 as IsVat, GM.InvoiceDate into  #TempTable
from RO_GoodsReceivedMain  GM 
	Inner JOIN RO_GoodsReceivedDetls  GD ON GM.GMId = GD.GMId
	LEFT JOIN ROI_PurchaseDetails PD ON PD.PurchaseDetailsID = GD.PDId
	INNER JOIN DBO.ROI_PurchaseMain PM ON PM.PurchaseMainID = PD.PurchaseMainID
	LEFT JOIN RO_LoyaltyMembership lm ON lm.MembershipId = GM.vendorId
	where 
	(cast(GM.InvoiceDate AS DATE) >= CAST(@StartDate as date) OR @StartDate=0 OR @StartDate IS NULL OR @StartDate='')
		AND (cast(GM.InvoiceDate  AS DATE)<= CAST(@EndDate as date) OR @EndDate=0 OR @EndDate IS NULL OR @EndDate='')
	--( DATEPART(YEAR,GM.InvoiceDate) = cast(@year as int) AND DATEPART(MONTH,GM.InvoiceDate) = cast(@month as int))
		AND GD.IsVat = 1 
GROUP BY GM.GMID, GM.InvoiceNo, GM.vendorId,GD.Discount, GM.ExtraDiscount, GM.InvoiceDate


----=================TEMP TABLE TO STORE NON VATABLE DATA======================
IF (OBJECT_ID('tempdb..#TempTable1') is not null)
drop table #TempTable1

select GM.GMID, GM.InvoiceNo, GM.vendorId, isnull(sum(GD.Discount), 0) as Discount
,isnull(SUM(GD.Total),0) as Total, 0 as IsVat, GM.InvoiceDate into  #TempTable1
from RO_GoodsReceivedMain  GM 
	Inner JOIN RO_GoodsReceivedDetls  GD ON GM.GMId = GD.GMId
	LEFT JOIN ROI_PurchaseDetails PD ON PD.PurchaseDetailsID = GD.PDId
	INNER JOIN DBO.ROI_PurchaseMain PM ON PM.PurchaseMainID = PD.PurchaseMainID
	LEFT JOIN RO_LoyaltyMembership lm ON lm.MembershipId = GM.vendorId
	where 
	(cast(GM.InvoiceDate AS DATE) >= CAST(@StartDate as date) OR @StartDate=0 OR @StartDate IS NULL OR @StartDate='')
		AND (cast(GM.InvoiceDate  AS DATE)<= CAST(@EndDate as date) OR @EndDate=0 OR @EndDate IS NULL OR @EndDate='')
	--( DATEPART(YEAR,GM.InvoiceDate) = cast(@year as int) AND DATEPART(MONTH,GM.InvoiceDate) = cast(@month as int))
		AND ISNULL(GD.IsVat,0) = 0
GROUP BY GM.GMID, GM.InvoiceNo, GM.vendorId,GD.Discount, GM.ExtraDiscount, GM.InvoiceDate


----=================RESULT TO DISPLAY VATABLE AND NON-VATABLE DATA======================

 select distinct GM.GMID, GM.GMNo,PM.PuNo, GM.InvoiceNo, GM.PostedOn, GM.InvoiceDate
,isnull((select isnull(tmp1.Discount, 0) from #TempTable1 tmp1 where tmp1.GMId = GD.GMId),0)  as Discount
,isnull((select isnull(tmp1.Total, 0) from #TempTable1 tmp1 where tmp1.GMId = GD.GMId),0) as Total 
, lm.Fname, lm.PAN, isnull(GM.ExtraDiscount,0) as ExtraDiscount
,isnull((select isnull(tmp.VatTotal, 0) from #TempTable tmp where tmp.GMId = GD.GMId),0) as VatTotal
,isnull((select isnull(tmp.IsVat, 0) from #TempTable tmp where tmp.GMId = GD.GMId),0) as vat
,isnull((select isnull(tmp.Discount, 0) from #TempTable tmp where tmp.GMId = GD.GMId),0) as vatdiscount
from RO_GoodsReceivedMain  GM 
	Inner JOIN RO_GoodsReceivedDetls  GD ON GM.GMId = GD.GMId 
		inner JOIN ROI_PurchaseDetails PD ON PD.PurchaseDetailsID = GD.PDId
	inner JOIN DBO.ROI_PurchaseMain PM ON PM.PurchaseMainID = PD.PurchaseMainID
	inner JOIN RO_LoyaltyMembership lm ON lm.MembershipId = GM.vendorId	
	where 
	(cast(GM.InvoiceDate AS DATE) >= cast(@StartDate as date) OR @StartDate=0 OR @StartDate IS NULL OR @StartDate='')
		AND (cast(GM.InvoiceDate  AS DATE)<= cast(@EndDate as date) OR @EndDate=0 OR @EndDate IS NULL OR @EndDate='')



END

GO
