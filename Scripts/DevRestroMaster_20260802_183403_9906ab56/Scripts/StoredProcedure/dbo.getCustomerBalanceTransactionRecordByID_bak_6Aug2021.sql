SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[getCustomerBalanceTransactionRecordByID] 14
CREATE PROCEDURE [dbo].[getCustomerBalanceTransactionRecordByID_bak_6Aug2021] @membershipID INT
AS
--declare @status int
--select @status=0
IF (
		@membershipID IN (
			SELECT MembershipID
			FROM RO_LoyaltyMembership
			WHERE IsCustomer = 1
			)
		)
BEGIN
	SELECT [MemberPayID]
		,[MemberID]
		,isnull([PayAmount], 0) PayAmount
		,[AddedOn]
		,[AddedBy]
		,0 AS [status]
		,'' AS billNo
		,1 AS iscustomer
	FROM [dbo].[RO_MemberPay]
	WHERE MemberID = @membershipID
		AND [PayAmount] != 0.00
	
	UNION
	
	--select @status=1
	SELECT sm.[salesMasterId]
		,spm.[CusID]
		,isnull(spm.PayAmount, 0) NetAmount
		,sm.[AddedOn]
		,sm.[AddedBy]
		,1 AS [status]
		,'RO' + fy.fyName + '-' + cast((SM.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR(20)) AS billNo
		--( sm.InvoiceNo - (SELECT fy.firstsalesmasterid             
		--                        FROM   dbo.ro_fiscalyear fy             
		--                        WHERE  fy.fyid = sm.fiscalyearid) )  AS  billNo 
		,1 AS iscustomer
	FROM [dbo].[RO_SalesMaster] sm
	left join RO_SalesPaymentMode spm on spm.salesMasterId = sm.salesMasterId
	JOIN dbo.RO_fiscalYear fy ON sm.FiscalYearID = fy.fyId
	WHERE spm.[CusID] = @membershipID
		AND spm.PaymentModeID = 4
	ORDER BY AddedOn 
END
ELSE
BEGIN
	SELECT [MemberPayID]
		,[MemberID]
		,isnull([PayAmount], 0) PayAmount
		,[AddedOn]
		,[AddedBy]
		,0 AS [status]
		,'' AS billNo
		,0 AS iscustomer
	FROM [dbo].[RO_MemberPay]
	WHERE MemberID = @membershipID
		AND [PayAmount] != 0.00
	
	UNION
	
	SELECT sm.PurchaseMainID
		,sm.Vid
		,isnull(CASE 
				WHEN lm.IsVat = 0
					THEN sum(Total)
				ELSE sum(Total) + (sum(Total) * .13)
				END, 0)
		,sm.PostedOn AS AddedOn
		,sm.PostedBy
		,1 AS [status]
		,PuNo AS billNo
		--( sm.InvoiceNo - (SELECT fy.firstsalesmasterid             
		--                        FROM   dbo.ro_fiscalyear fy             
		--                        WHERE  fy.fyid = sm.fiscalyearid) )  AS  billNo 
		,0 AS iscustomer
	FROM ROI_PurchaseMain sm
	JOIN ROI_PurchaseDetails rd ON rd.PurchaseMainID = sm.PurchaseMainID
	JOIN RO_LoyaltyMembership lm ON lm.MembershipID = sm.vid
	--join dbo.RO_fiscalYear fy on sm.FiscalYearID=fy.fyId 
	WHERE sm.Vid = @membershipID
		AND rd.Total IS NOT NULL
		AND sm.SPMID = 4
	GROUP BY sm.PurchaseMainID
		,sm.Vid
		,sm.PostedOn
		,sm.PostedBy
		,PuNo
		,lm.IsVat
	--ORDER BY AddedOn DESC

	UNION
	
	SELECT sm.GMId
		,sm.vendorId
		,isnull(CASE 
				WHEN lm.IsVat = 0
					THEN sum(Total)
				ELSE sum(Total * 1.13)
				END, 0)
		,sm.PostedOn AS AddedOn
		,sm.PostedBy
		,1 AS [status]
		,GMNo AS billNo
		--( sm.InvoiceNo - (SELECT fy.firstsalesmasterid             
		--                        FROM   dbo.ro_fiscalyear fy             
		--                        WHERE  fy.fyid = sm.fiscalyearid) )  AS  billNo 
		,0 AS iscustomer
	FROM RO_GoodsReceivedMain sm
	JOIN RO_GoodsReceivedDetls rd ON rd.GMId = sm.GMId
	JOIN RO_LoyaltyMembership lm ON lm.MembershipID = sm.vendorId
	--join dbo.RO_fiscalYear fy on sm.FiscalYearID=fy.fyId 
	WHERE sm.vendorId = @membershipID
		AND rd.Total IS NOT NULL
		AND isnull(sm.paymentMode,0) = 4
	GROUP BY sm.vendorId
		,sm.GMId
		,sm.PostedOn
		,sm.PostedBy
		,GMNo
		,lm.IsVat
	ORDER BY AddedOn 
END
		-- delete ROI_PurchaseMain where PurchaseMainID<14


GO
