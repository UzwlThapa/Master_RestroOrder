SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_GetDiscountCouponReport]
 @FromDate Date, @ToDate Date, @Customer varchar(200) 
 AS
DECLARE @CustomerLike VARCHAR(200)
DECLARE @code VARCHAR(10)

	SET @code = (
			SELECT TOP (1) Code
			FROM RO_CompanyInfo
			)
--SELECT @FromDate='' , @ToDate='', @Customer=''
SET @CustomerLike='%'+@Customer+'%';
SELECT [BillLogId]
      ,cbl.[BillDate]
      ,[CustomerID] as CusID
      ,[BillAmount]
      ,[CashPaid] as PayAmount
      ,[DiscountCoupon]
      ,[Balance]
      ,@code + fy.fyName + '-' + CAST((sm.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR(20)) AS BillNo
	  ,lm.Fname+' '+Lname as Customer
  FROM [dbo].[RO_CustomerBillLog] cbl
  inner join dbo.RO_LoyaltyMembership lm on cbl.CustomerID=lm.MembershipID 
  inner join RO_SalesMaster sm on sm.billNo = cbl.BillNo
  INNER JOIN RO_fiscalYear fy ON fy.fyId = sm.FiscalYearID
  and cbl.DiscountCoupon=1
  WHERE (CAST(cbl.BillDate as DATE)>=@FromDate OR @FromDate IS NULL OR @FromDate='')
  AND  (CAST(cbl.BillDate as DATE)<=@ToDate OR @ToDate IS NULL OR @ToDate='')
  AND (lm.Fname+' '+Lname like @CustomerLike OR @CustomerLike IS NULL OR @CustomerLike='')

GO
