SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[usp_GetAllSalesProvidersReport] 
CREATE PROCEDURE [dbo].[usp_GetAllSalesProvidersReport] @startDate DATETIME
	,@endDate DATETIME
	,@paymentMode INT
	,@provider INT
AS
BEGIN
	SELECT CAST(BillDate AS DATE) AS BillDate
     ,paymentID
		,payAmount
		,ProviderName
		,TransactionNo
		,billNo
FROM (

	SELECT CAST(CONVERT(VARCHAR(16), sm.BillDate, 20) AS VARCHAR(120)) AS BillDate
		,spm.PaymentModeID AS paymentID
		,cp.ProviderName AS ProviderName
		,sum(spm.PayAmount) AS payAmount
		,'Sales' as billNo
		,case when LTRIM(RTRIM( Max(spm.ChequeNO))) = '' then max(spm.TransactionNo) else max(spm.ChequeNo) end as TransactionNo
	FROM dbo.RO_SalesMaster sm
	Inner join CBMS_BillPostLog bp on bp.SalesMasterId = sm.salesMasterId
	INNER JOIN RO_fiscalYear fy ON fy.fyId = sm.FiscalYearID
	LEFT JOIN RO_SalesPaymentMode spm ON spm.salesMasterId = sm.salesMasterId
	LEFT JOIN RO_BillingAmount b1 ON B1.SalesMasterID = sm.salesMasterId
		AND b1.BilingID = 62
	LEFT JOIN RO_BillingAmount b2 ON B2.SalesMasterID = sm.salesMasterId
		AND b2.BilingID = 54
	LEFT JOIN RO_CardProvider cp ON cp.ProviderID = spm.ProviderID
WHERE (
			cast(sm.BillDate as Date) BETWEEN @startDate
				AND @endDate
			)
		AND (
			spm.PaymentModeID = @paymentMode
			OR @paymentMode = 0
			)
		AND spm.PaymentModeID != 0
		AND spm.PaymentModeID != 1
		AND spm.PaymentModeID != 4
		AND (
			spm.ProviderID = @provider
			OR @provider = 0
			)   
 GROUP BY ProviderName ,sm.BillDate,spm.PaymentModeID
 UNION ALL
 SELECT CAST(om.Date AS DATE) AS BillDate,
  apm.PaymentModeID AS paymentID,
 cp.ProviderName AS ProviderName, sum(apm.PayAmount)   PayAmount, 
apm.TransactionNo
		,'Advance' as billNo
       FROM Ro_RoomBookings rb  
       INNER JOIN RO_OrderMasters om on rb.OrderMasterId=om.OrderMasterID  
       INNER join RO_AdvancePaymentMode apm on apm.RoomBookDetailsId = rb.RoomBookDetailsId  
		INNER JOIN RO_CardProvider cp ON cp.ProviderID = apm.ProviderID  
	   	   WHERE apm.PaymentModeID<>1 and  apm.PaymentModeID<>4
	   AND (@paymentMode=0 or apm.PaymentModeID=@paymentMode)
		AND (CAST(DATEADD(hour,-4,om.Date) AS DATE) BETWEEN CAST(@startDate as DATE)  AND CAST(@endDate as DATE)) 
  AND (   apm.ProviderID = @provider  OR @provider = 0     )    
  GROUP BY  CAST(om.Date AS DATE), cp.ProviderName, apm.PaymentModeID, apm.TransactionNo
 UNION ALL 

 SELECT CAST(mp.AddedOn AS DATE)  AS BillDate  ,mpm.PaymentModeID  AS paymentID, cp.ProviderName AS ProviderName
  ,sum(mp.PayAmount)   PayAmount
  ,mpm.TransactionNo
		,'Credit Collection' as billNo
    FROM RO_MemberPay mp  
    left join RO_MemberPaymentMode mpm on mpm.MemberPayId = mp.MemberPayID  
		INNER JOIN RO_CardProvider cp ON cp.ProviderID = mpm.ProviderID  
		LEFT JOIN RO_LoyaltyMembership lm on lm.MembershipID = mp.MemberID
 WHERE mpm.PaymentModeID<>1 and  mpm.PaymentModeID<>4
	   AND (@paymentMode=0 or mpm.PaymentModeID=@paymentMode)
		AND (CAST(DATEADD(hour,-4,mp.AddedOn) AS DATE) BETWEEN CAST(@startDate as DATE)  AND CAST(@endDate as DATE)) 
  AND (   mpm.ProviderID = @provider  OR @provider = 0     )    
 GROUP BY ProviderName , CAST(mp.AddedOn AS DATE), lm.Fname,mpm.PaymentModeID
,mpm.TransactionNo
 ) x
 ORDER BY x.ProviderName, x.BillDate
		,x.paymentID
		,x.TransactionNo


END



GO
