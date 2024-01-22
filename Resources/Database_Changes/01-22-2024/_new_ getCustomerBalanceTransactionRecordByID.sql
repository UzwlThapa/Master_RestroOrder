USE [RO-CHICKENSTATION]
GO
/****** Object:  StoredProcedure [dbo].[getCustomerBalanceTransactionRecordByID]    Script Date: 1/22/2024 11:10:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [getCustomerBalanceTransactionRecordByID] 1
ALTER PROCEDURE [dbo].[getCustomerBalanceTransactionRecordByID] @membershipID INT
AS
IF (
  @membershipID IN (
   SELECT MembershipID
   FROM RO_LoyaltyMembership
   WHERE IsCustomer = 1
   )
  )
BEGIN
 DECLARE @code VARCHAR(10)

 SET @code = (
   SELECT TOP (1) Code
   FROM RO_CompanyInfo
   )

 SELECT mp.[MemberPayID]
  ,mp.[MemberID]
  ,0 as CreditAmount
  ,isnull(mp.[PayAmount], 0) PayAmount
  ,[AddedOn]
  ,[AddedBy]
  ,0 AS [status]
  ,'' AS billNo
  ,1 AS iscustomer
  ,0 AS salesMasterId
    ,0 as RoomBookDetailsID
  ,'' as Remarks
  ,isnull(mp.SettlementAmount,0) SettlementAmount
  ,0 as IsCancelled
 FROM [dbo].[RO_MemberPay] mp  inner join RO_MemberPaymentMode mpm on mpm.MemberPayId = mp.MemberPayID
 WHERE mp.MemberID = @membershipID
  AND mp.[PayAmount] != 0.00


 
 UNION

 SELECT spm.salesPaymentID
  ,sm.[CusID]
  --,case  
		--when sm.AdvancePayment >= sm.NetAmount then sm.NetAmount 
		--when sm.AdvancePayment < sm.NetAmount  then sm.AdvancePayment + sum(spm.PayAmount)
		----when sm.AdvancePayment < sm.NetAmount and sm.AdvancePayment != 4  then sm.AdvancePayment 
		--else isnull(sum(spm.PayAmount), 0) end  CreditAmount
		,isnull(MAX(CASE 
					WHEN sm.AdvancePayment < sm.NetAmount
					THEN 
						CASE WHEN spm.PaymentModeID = 4
							THEN sm.AdvancePayment + spm.PayAmount
							ELSE sm.AdvancePayment 
						END 
					
					WHEN sm.AdvancePayment >= sm.NetAmount 
						THEN  sm.NetAmount
					END), 0) AS CreditAmount
 , 0 as NetAmount
  ,sm.[AddedOn]
  ,sm.[AddedBy]
  ,1 AS [status]
  ,@code + fy.fyName + '-' + cast((SM.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR(20)) AS billNo
  ,1 AS iscustomer
  ,sm.salesMasterId
    ,0 as RoomBookDetailsID
  ,spm.Remarks
  ,0 as SettlementAmount
  ,isnull(spm.IsCancelled,0) as IsCancelled
 FROM [dbo].[RO_SalesMaster] sm
 LEFT JOIN RO_SalesPaymentMode spm ON spm.salesMasterId = sm.salesMasterId
 JOIN dbo.RO_fiscalYear fy ON sm.FiscalYearID = fy.fyId
 WHERE spm.[CusID] = @membershipID
  AND(spm.PaymentModeID = 4 OR sm.AdvancePayment>0)
  --and spm.PayAmount <> 0 
    group by sm.[salesMasterId]
  ,sm.[CusID]
  ,sm.AdvancePayment,
   sm.NetAmount  ,sm.[AddedOn]
  ,sm.[AddedBy]
  , fy.fyName,SM.InvoiceNo ,fy.FirstSalesMasterID
   ,spm.Remarks,
   spm.IsCancelled
   ,spm.salesPaymentID


 UNION

SELECT rb.RoomBookDetailsID
  ,rb.CustomerId
  ,0 as CreditAmount
  ,isnull(sum(spm.PayAmount), 0) NetAmount
  ,om.Date as AddedOn
  ,om.UserName as AddedBy
  ,0 AS [status]
  ,'' AS billNo
  ,1 AS iscustomer
  ,0 as salesMasterId
  ,rb.RoomBookDetailsID
  ,rb.Remarks
  ,isnull(spm.SettlementAmount,0) SettlementAmount
    ,0 as IsCancelled

 FROM [dbo].Ro_RoomBookings rb
  JOIN RO_AdvancePaymentMode spm ON spm.RoomBookDetailsId = rb.RoomBookDetailsID
 JOIN RO_OrderMasters om ON rb.OrderMasterId= om.OrderMasterID
 WHERE rb.CustomerId = @membershipID
  group by rb.RoomBookDetailsID
  ,rb.CustomerId
  ,om.Date 
  ,rb.RoomBookDetailsID
  ,rb.Remarks
  ,om.UserName 
   ,spm.SettlementAmount

   UNION

 SELECT sm.[salesMasterId]
  ,sm.CustomerId
  --,case  
		--when sm.AdvancePayment >= sm.NetAmount then sm.NetAmount 
		--when sm.AdvancePayment < sm.NetAmount  then sm.AdvancePayment + sum(spm.PayAmount)
		----when sm.AdvancePayment < sm.NetAmount and sm.AdvancePayment != 4  then sm.AdvancePayment 
		--else isnull(sum(spm.PayAmount), 0) end  CreditAmount
		,isnull(MAX(CASE 
					WHEN sm.AdvancePayment < sm.NetAmount
					THEN 
						CASE WHEN spm.PaymentModeID = 4
							THEN sm.AdvancePayment + spm.PayAmount
							ELSE sm.AdvancePayment 
						END 
					
					WHEN sm.AdvancePayment >= sm.NetAmount 
						THEN  sm.NetAmount
					END), 0) AS CreditAmount
 , 0 as NetAmount
  ,sm.[AddedOn]
  ,sm.[AddedBy]
  ,1 AS [status]
  ,@code + fy.fyName + '-' + cast((SM.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR(20)) AS billNo
  ,1 AS iscustomer
  ,sm.salesMasterId
    ,0 as RoomBookDetailsID
  ,spm.Remarks
  ,0 as SettlementAmount
    ,0 as IsCancelled

 FROM dbo.RO_CakeSalesMaster sm
 LEFT JOIN RO_CAKE_SalesPaymentMode spm ON spm.salesMasterId = sm.salesMasterId
 JOIN dbo.RO_fiscalYear fy ON sm.FiscalYearID = fy.fyId
 WHERE spm.[CusID] = @membershipID
  AND(spm.PaymentModeID = 4 OR sm.AdvancePayment>0)
  --and spm.PayAmount <> 0 
    group by sm.[salesMasterId]
  ,sm.CustomerId
  ,sm.AdvancePayment,
   sm.NetAmount  ,sm.[AddedOn]
  ,sm.[AddedBy]
  , fy.fyName,SM.InvoiceNo ,fy.FirstSalesMasterID
   ,spm.Remarks




 ORDER BY AddedOn ASC
END
ELSE
BEGIN
 SELECT mp.[MemberPayID]
  ,mp.[MemberID]
  ,0 as CreditAmount
  ,isnull(mp.[PayAmount], 0) PayAmount
  ,[AddedOn]
  ,[AddedBy]
  ,0 AS [status]
  ,'' AS billNo
  ,0 AS iscustomer
  ,0 AS salesMasterId
  ,isnull(mp.SettlementAmount,0) SettlementAmount
    ,0 as IsCancelled

 FROM [dbo].[RO_MemberPay] mp  inner join RO_MemberPaymentMode mpm on mpm.MemberPayId = mp.MemberPayID
 WHERE mp.MemberID = @membershipID
  AND mp.[PayAmount] != 0.00

 UNION

 SELECT sm.GMId
  ,sm.vendorId
   ,isnull(ppm.PayAmount,CASE 
				WHEN lm.IsVat = 0
					THEN sum(Total)
				ELSE sum(Total * 1.13)
				END) as  CreditAmount
	,0 as  PayAmount
  ,sm.PostedOn AS AddedOn
  ,sm.PostedBy
  ,1 AS [status]
  ,GMNo AS billNo
  ,0 AS iscustomer
  ,sm.GMId AS salesMasterId
  ,0 as SettlementAmount
    ,0 as IsCancelled

 FROM RO_GoodsReceivedMain sm
 JOIN RO_GoodsReceivedDetls rd ON rd.GMId = sm.GMId
 JOIN RO_LoyaltyMembership lm ON lm.MembershipID = sm.vendorId
 left join RO_PurchasePaymentMode ppm on ppm.GMId = sm.GMId
 WHERE sm.vendorId = @membershipID
  AND rd.Total IS NOT NULL
	AND isnull(ppm.PaymentModeID,sm.paymentMode) = 4
 GROUP BY sm.vendorId
  ,sm.GMId
  ,sm.PostedOn
  ,sm.PostedBy
  ,GMNo
   ,lm.IsVat
,ppm.PayAmount

 UNION 

  SELECT PR.PurchaseReturnId
  ,PR.vendorId
  ,isnull(-ppm.PayAmount,0) as  CreditAmount
  ,0 as  PayAmount
  ,PR.PostedOn AS AddedOn
  ,PR.PostedBy
  ,1 AS [status]
  ,PR.PRNo AS billNo
  ,0 AS iscustomer
  ,PR.PurchaseReturnId AS salesMasterId
  ,0 as SettlementAmount
    ,0 as IsCancelled

 FROM  RO_PurchaseReturnMain PR
 JOIN RO_PurchaseReturnDetails PD ON PR.PurchaseReturnId = PD.PurchaseReturnId
 JOIN RO_LoyaltyMembership lm ON lm.MembershipID = PR.vendorId
 left join RO_PurchaseReturnPaymentMode ppm on ppm.PurchaseReturnId = PR.PurchaseReturnId
 WHERE PR.vendorId = @membershipID
  AND PD.Total IS NOT NULL
	AND isnull(ppm.PaymentModeID,1) = 4
 ORDER BY AddedOn ASC

 


 END