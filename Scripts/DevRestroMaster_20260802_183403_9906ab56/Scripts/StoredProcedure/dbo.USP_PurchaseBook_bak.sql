SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE USP_PurchaseBook  '2018-09-23', '2018-12-23'
CREATE PROCEDURE [dbo].[USP_PurchaseBook_bak] 

@StartDate datetime
, @EndDate datetime
	as
	BEGIN

IF (OBJECT_ID('tempdb..#TempTable') is not null)
drop table #TempTable

select GM.GMID, isnull(sum(GD.Discount), 0) as Discount
,isnull(SUM(GD.Qnty * GD.Rate),0) as VatTotal, 1 as IsVat, GM.InvoiceDate into  #TempTable
from RO_GoodsReceivedMain  GM 
	Inner JOIN RO_GoodsReceivedDetls  GD ON GM.GMId = GD.GMId
	LEFT JOIN ROI_PurchaseDetails PD ON PD.PurchaseDetailsID = GD.PDId
	INNER JOIN DBO.ROI_PurchaseMain PM ON PM.PurchaseMainID = PD.PurchaseMainID
	LEFT JOIN RO_LoyaltyMembership lm ON lm.MembershipId = GM.vendorId
	where 
	(cast(GM.InvoiceDate AS DATE) >= @StartDate OR @StartDate=0 OR @StartDate IS NULL OR @StartDate='')
		AND (cast(GM.InvoiceDate  AS DATE)<= @EndDate OR @EndDate=0 OR @EndDate IS NULL OR @EndDate='')
		AND GD.IsVat = 1 
GROUP BY GM.GMID, GD.Discount, GM.ExtraDiscount, GM.InvoiceDate


select GM.GMID, GM.GMNo,PM.PuNo, GM.InvoiceNo, GM.PostedOn, GM.InvoiceDate, isnull(sum(GD.Discount), 0) as Discount
,isnull(SUM(GD.Qnty * GD.Rate),0) as Total, lm.Fname, lm.PAN, isnull(GM.ExtraDiscount,0) as ExtraDiscount
, isnull(tmp.VatTotal,0) as VatTotal,  isnull(tmp.IsVat,0) as vat, isnull(tmp.Discount,0) as vatdiscount
from RO_GoodsReceivedMain  GM 
	Inner JOIN RO_GoodsReceivedDetls  GD ON GM.GMId = GD.GMId
		LEFT JOIN ROI_PurchaseDetails PD ON PD.PurchaseDetailsID = GD.PDId
	INNER JOIN DBO.ROI_PurchaseMain PM ON PM.PurchaseMainID = PD.PurchaseMainID
	LEFT JOIN RO_LoyaltyMembership lm ON lm.MembershipId = GM.vendorId
	left join #TempTable tmp on tmp.GMID = GM.GMId
	where (cast(GM.InvoiceDate AS DATE) >= @StartDate OR @StartDate=0 OR @StartDate IS NULL OR @StartDate='')
		AND (cast(GM.InvoiceDate  AS DATE)<= @EndDate OR @EndDate=0 OR @EndDate IS NULL OR @EndDate='')
		 AND GD.IsVat = 0 or GD.IsVat is null 

GROUP BY GM.GMID, GM.GMNo,PM.PuNo, GM.InvoiceNo, GM.PostedOn, GM.InvoiceDate, GD.Discount, lm.Fname, lm.PAN, GM.ExtraDiscount
, tmp.VatTotal, tmp.IsVat, tmp.Discount
END

GO
