SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP procedure USP_RO_getCreditReport
CREATE PROCEDURE [dbo].[USP_RO_getCreditReport]
@sdate date,
@edate date,
@Customer nvarchar(250) = null,
@IsCustomer bit=null
as
IF (@IsCustomer = 1)
		BEGIN

	DECLARE @code VARCHAR(10)

	SET @code = (
			SELECT TOP (1) Code
			FROM RO_CompanyInfo
			)

	SELECT sm.[salesMasterId] as MemberPayId 
		,spm.[CusID] as MemberID
		,isnull(spm.PayAmount, 0) PayAmount
		,sm.[AddedOn]
		,sm.[AddedBy]
		,1 AS [status]
		,@code + fy.fyName + '-' + cast((SM.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR(20)) AS billNo
		,1 AS iscustomer
		,sm.salesMasterId
		,lm.Fname + ' ' + lm.Lname as CustName
		 , CASE WHEN lm.IsCustomer < 1 THEN 'Vendor' ELSE 'Customer' END AS CustType
	FROM [dbo].[RO_SalesMaster] sm
	LEFT JOIN RO_SalesPaymentMode spm ON spm.salesMasterId = sm.salesMasterId
	JOIN dbo.RO_fiscalYear fy ON sm.FiscalYearID = fy.fyId
	  inner join RO_LoyaltyMembership lm
  on lm.MembershipID=spm.[CusID] 
	WHERE 
	--spm.[CusID] = @membershipID
	(cast(dateadd(hour,-4,sm.AddedOn) as date) between @sdate and @edate)
    AND (lm.Fname + ' ' + lm.Lname = @Customer or @Customer IS NULL)
	AND spm.PaymentModeID = 4
	ORDER BY AddedOn DESC
		END
ELSE
	
	SELECT sm.GMId as MemberPayId 
		,sm.vendorId as MemberID
		,isnull(pm.PayAmount,CASE 
				WHEN lm.IsVat = 0
					THEN sum(Total)
				ELSE sum(Total * 1.13)
				END)  PayAmount
		,sm.PostedOn AS AddedOn
		,sm.PostedBy as AddedBy
		,1 AS [status]
		,GMNo AS billNo
		,0 AS iscustomer
		,sm.GMId AS salesMasterId
		,lm.Fname + ' ' + lm.Lname as CustName
		 , CASE WHEN lm.IsCustomer < 1 THEN 'Vendor' ELSE 'Customer' END AS CustType
	FROM RO_GoodsReceivedMain sm
	JOIN RO_GoodsReceivedDetls rd ON rd.GMId = sm.GMId
	JOIN RO_LoyaltyMembership lm ON lm.MembershipID = sm.vendorId
	left join RO_PurchasePaymentMode pm ON pm.GMId = sm.GMId
	WHERE 
	--spm.[CusID] = @membershipID
	(cast(dateadd(hour,-4,sm.PostedOn) as date) between @sdate and @edate)
    AND (lm.Fname + ' ' + lm.Lname = @Customer or @Customer IS NULL)
		AND rd.Total IS NOT NULL
		--AND isnull(sm.paymentMode, 0) = 4
		AND isnull(pm.PaymentModeID,sm.paymentMode) = 4
	GROUP BY sm.vendorId
		,sm.GMId
		,sm.PostedOn
		,sm.PostedBy
		,GMNo
		,lm.IsVat
		,lm.Fname
		,lm.Lname
		,lm.IsCustomer 
		,pm.PaymentModeID
		 ,pm.PayAmount
	ORDER BY AddedOn DESC


GO
