SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[usp_GetDaySalesProvidersReport]
CREATE PROCEDURE [dbo].[usp_GetDaySalesProvidersReport] @startDate DATETIME
	,@endDate DATETIME
	,@paymentMode INT
	,@provider INT
AS
BEGIN
SELECT CAST(BillDate AS DATE) AS BillDate,ProviderName , SUM(payAmount) PayAmount
FROM (
 SELECT CAST(sm.BillDate AS DATE) AS BillDate,
  cp.ProviderName AS ProviderName      
  ,SUM(spm.PayAmount) AS PayAmount      
 FROM dbo.RO_SalesMaster sm      
 Inner join CBMS_BillPostLog bp on bp.SalesMasterId = sm.salesMasterId      
 LEFT JOIN RO_SalesPaymentMode spm ON spm.salesMasterId = sm.salesMasterId      
 LEFT JOIN RO_BillingAmount b1 ON B1.SalesMasterID = sm.salesMasterId      
  AND b1.BilingID = 62      
 LEFT JOIN RO_BillingAmount b2 ON B2.SalesMasterID = sm.salesMasterId      
  AND b2.BilingID = 54      
 INNER JOIN RO_CardProvider cp ON cp.ProviderID = spm.ProviderID      
WHERE (
			sm.BillDate BETWEEN @startDate
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
 GROUP BY ProviderName ,CAST(sm.BillDate AS DATE)  
 UNION ALL
 SELECT   CAST(om.Date AS DATE) AS BillDate,
 cp.ProviderName AS ProviderName,sum(apm.PayAmount)   PayAmount
 
       FROM Ro_RoomBookings rb  
       INNER JOIN RO_OrderMasters om on rb.OrderMasterId=om.OrderMasterID  
       INNER join RO_AdvancePaymentMode apm on apm.RoomBookDetailsId = rb.RoomBookDetailsId  
		INNER JOIN RO_CardProvider cp ON cp.ProviderID = apm.ProviderID  
	   	   WHERE apm.PaymentModeID<>1 and  apm.PaymentModeID<>4
	   AND (@paymentMode=0 or apm.PaymentModeID=@paymentMode)
		AND (CAST(DATEADD(hour,-4,om.Date) AS DATE) BETWEEN CAST(@startDate as DATE)  AND CAST(@endDate as DATE)) 
  AND (   apm.ProviderID = @provider  OR @provider = 0     )    
 GROUP BY ProviderName ,  CAST(om.Date AS DATE)
 UNION ALL 
 SELECT CAST(mp.AddedOn AS DATE)  AS BillDate, cp.ProviderName AS ProviderName, sum(mp.PayAmount)   PayAmount
    FROM RO_MemberPay mp  
    left join RO_MemberPaymentMode mpm on mpm.MemberPayId = mp.MemberPayID  
		INNER JOIN RO_CardProvider cp ON cp.ProviderID = mpm.ProviderID  
 WHERE mpm.PaymentModeID<>1 and  mpm.PaymentModeID<>4
	   AND (@paymentMode=0 or mpm.PaymentModeID=@paymentMode)
		AND (CAST(DATEADD(hour,-4,mp.AddedOn) AS DATE) BETWEEN CAST(@startDate as DATE)  AND CAST(@endDate as DATE)) 
  AND (   mpm.ProviderID = @provider  OR @provider = 0     )    
 GROUP BY ProviderName , CAST(mp.AddedOn AS DATE) 
 ) x
 GROUP BY x.ProviderName, x.BillDate
 ORDER BY x.ProviderName, x.BillDate
	--SELECT CAST(sm.BillDate AS DATE) AS BillDate
	--	,cp.ProviderName AS ProviderName
	--	,SUM(sm.BasicAmount + isnull(sm.RoomCharge, 0) + sm.totaldiscount) AS total
	--	,SUM(sm.totaldiscount) AS discount
	--	,SUM(isnull(b1.Amount, 0)) AS serviceCharge
	--	,SUM(isnull(b2.Amount, 0)) AS vat
	--	,SUM(sm.NetAmount) AS netAmount
	--	,SUM(spm.PayAmount) as payAmount
	--FROM dbo.RO_SalesMaster sm
	--Inner join CBMS_BillPostLog bp on bp.SalesMasterId = sm.salesMasterId
	--LEFT JOIN RO_SalesPaymentMode spm ON spm.salesMasterId = sm.salesMasterId
	--LEFT JOIN RO_BillingAmount b1 ON B1.SalesMasterID = sm.salesMasterId
	--	AND b1.BilingID = 62
	--LEFT JOIN RO_BillingAmount b2 ON B2.SalesMasterID = sm.salesMasterId
	--	AND b2.BilingID = 54
	--LEFT JOIN RO_CardProvider cp ON cp.ProviderID = spm.ProviderID
	--WHERE (
	--		sm.BillDate BETWEEN @startDate
	--			AND @endDate
	--		)
	--	AND (
	--		spm.PaymentModeID = @paymentMode
	--		OR @paymentMode = 0
	--		)
	--	AND spm.PaymentModeID != 0
	--	AND spm.PaymentModeID != 1
	--	AND spm.PaymentModeID != 4
	--	AND (
	--		spm.ProviderID = @provider
	--		OR @provider = 0
	--		)
	--GROUP BY ProviderName
	--	,CAST(sm.BillDate AS DATE)
END


GO
