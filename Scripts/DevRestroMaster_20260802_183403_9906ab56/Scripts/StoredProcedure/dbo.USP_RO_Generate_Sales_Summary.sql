SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--USP_RO_Generate_Sales_Summary '2018-05-27','2018-06-29'
CREATE PROCEDURE [dbo].[USP_RO_Generate_Sales_Summary]
@startDate DateTime =NULL
,@endDate DateTime= NULL
AS
IF ISNULL(@startDate,0)=0 
BEGIN
select @startDate=isnull(MAX(BillDate),DATEADD(day,-7, getdate())) from [RO_Sales_View]
END
IF ISNULL(@endDate,0)=0 
BEGIN
set @endDate=GETDATE()
END
declare @code varchar(10)
set @code = (select top(1) code from RO_CompanyInfo)

INSERT INTO [dbo].[RO_Sales_View] (
[OrderMasterId]
      ,[SalesMasterId]
      ,[BillDate]
      ,[InvoiceNo]
      ,[BillNo]
      ,[BillCustomer]
      ,[LoyalCustomer]
      ,[Waiter]
      ,[Table]
      ,[TableId]
      ,[Room]
      ,[SubTotal]
      ,[TotalDiscount]
      ,[BasicAmount]
      ,[ServiceCharge]
      ,[Vat]
      ,[NetAmount]
      ,[ProviderID]
      ,[ProviderName]
      ,[PaymentModeID]
      ,[PaymentMode]
      ,[PayAmount]
	  ,SurplusDeficit
      ,[Cashier]
	  --,CompanyCode
	  )
	SELECT sm.OrderMasterId
		,sm.salesMasterId
		,CAST(CONVERT(VARCHAR(16), sm.BillDate, 20) AS VARCHAR(120)) AS BillDate
		,sm.InvoiceNo
		,@code + fy.fyName + '-' + CAST((sm.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR(20)) AS billNo
		,spm.Customer as BillCustomer
		,l.Fname+ ' ' +l.Lname as LoyalCustomer
		,sm.Waiter
		,isnull(rt.restrotableTitle, 'Take Away') AS [Table]
		,sm.TableId
		,isnull(rr.restroRoom, 'Take Away') AS Room
		,sm.BasicAmount + sm.totaldiscount AS SubTotal
		,sm.TotalDiscount
		,sm.BasicAmount AS BasicAmount
		,isnull(b1.Amount, 0) AS ServiceCharge
		,isnull(b2.Amount, 0) AS Vat
		,sm.NetAmount  
		,spm.ProviderID
		,cp.ProviderName
		,spm.PaymentModeID
		,pms.PaymentMode
		,spm.PayAmount
		,(isnull(sum(spm.PayAmount), 0) + isnull(sm.AdvancePayment, 0) - sm.netamount) SurplusDeficit
		,sm.AddedBy as Cashier
		--,@code
	FROM dbo.RO_SalesMaster sm
		inner join CBMS_BillPostLog cb on cb.SalesMasterId = sm.salesMasterId
	INNER JOIN RO_fiscalYear fy ON fy.fyId = sm.FiscalYearID
	left join RO_SalesPaymentMode spm on spm.salesMasterId = sm.salesMasterId
	INNER JOIN RO_PaymentModes pms ON spm.PaymentModeID = pms.PaymentModeID
	Left join [RO_CardProvider] cp on cp.ProviderID=spm.ProviderID
	LEFT JOIN RO_LoyaltyMembership l on spm.CusID=l.MembershipID
	LEFT JOIN RO_BillingAmount b1 ON B1.SalesMasterID = sm.salesMasterId
		AND b1.BilingID = 62
	LEFT JOIN RO_BillingAmount b2 ON B2.SalesMasterID = sm.salesMasterId
		AND b2.BilingID = 54
	LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = sm.TableId
	LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = rt.restroRoomId
	WHERE (
			sm.BillDate BETWEEN dateadd(hour,4, @startDate)	AND dateadd(hour,4,@endDate)
			)
		--AND (sm.SPMID = @PaymentMode OR @PaymentMode=0 )       
		AND (sm.IsArchived = 0)
		GRoup by sm.OrderMasterId
		,sm.salesMasterId
		, spm.Customer
		,l.Fname+ ' ' +l.Lname
		,sm.Waiter
		,rt.restrotableTitle
		,sm.TableId
		,rr.restroRoom
		,spm.ProviderID
		,cp.ProviderName
		,fy.fyName
		,sm.InvoiceNo
		,fy.FirstSalesMasterID
		,sm.totaldiscount
		,sm.BasicAmount
		,sm.BillDate
		,b1.Amount
		,b2.Amount
		,sm.AdvancePayment
		,sm.NetAmount
		,spm.PaymentModeID
		,pms.PaymentMode
		,spm.PayAmount
		,sm.AddedBy
	--ORDER BY salesMasterId DESC;
EXCEPT SELECT [OrderMasterId]
      ,[SalesMasterId]
      ,[BillDate]
      ,[InvoiceNo]
      ,[BillNo]
      ,[BillCustomer]
      ,[LoyalCustomer]
      ,[Waiter]
      ,[Table]
      ,[TableId]
      ,[Room]
      ,[SubTotal]
      ,[TotalDiscount]
      ,[BasicAmount]
      ,[ServiceCharge]
      ,[Vat]
      ,[NetAmount]
      ,[ProviderID]
      ,[ProviderName]
      ,[PaymentModeID]
      ,[PaymentMode]
      ,[PayAmount]
	  ,SurplusDeficit
      ,[Cashier]
	  --,CompanyCode
	   FROM [RO_Sales_View]

--END;


GO
