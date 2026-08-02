SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Sales_Summary_Report]
@Room VARCHAR(100)='',
@Table VARCHAR(100)='',
@InvoiceNo INT=0,
@Customer VARCHAR(100)='',
@Waiter VARCHAR(100)='',
@Cashier VARCHAR(100)='',
@PaymentModeID INT=0,
@Provider VARCHAR(100)='',
@DateFrom Date=NULL,
@DateTo Date=NULL,
@TimeFrom INT=0,
@TimeTo INT=24
AS
DECLARE 
@CustomerLike VARCHAR(100)='%'+@Customer+'%',
@WaiterLike VARCHAR(100)='%'+@Waiter+'%',
@CashierLike VARCHAR(100)='%'+@Cashier+'%',
@ProviderLike VARCHAR(100)='%'+@Provider+'%'

If @PaymentModeID<>0
	SELECT       InvoiceNo, BillDate,  BillNo , BillCustomer as Customer, Waiter, [Table], Room, ProviderName, PaymentMode, Cashier, SUM(PayAmount) AS Amount
	FROM            RO_Sales_View
	WHERE 1=1 	
	AND (InvoiceNo=@InvoiceNo OR @InvoiceNo=0)
	AND (PaymentModeID = @PaymentModeID OR @PaymentModeID=0 )  
	AND  (CAST(DATEADD(HOUR,-4, BillDate) AS Date) >= @DateFrom  OR @DateFrom IS NULL) 
	AND (CAST(DATEADD(HOUR,-4, BillDate) AS Date)<= @DateTo OR @DateTo IS NULL)
	AND  (DATEPART(HOUR,BillDate) >= @TimeFrom OR @TimeFrom=0) 
	AND (DATEPART(HOUR,  BillDate) <= @TimeTo OR @TimeTo=0)
	AND (ProviderName like @ProviderLike  OR @Provider='' OR @Provider IS NULL)
	AND (BillCustomer like @CustomerLike OR @Customer='' OR @Customer IS NULL)
	AND (Waiter like @WaiterLike OR @Waiter='' OR @Waiter IS NULL)  
	AND (Cashier like @CashierLike OR @Cashier='' OR @Cashier IS NULL)  
	AND (Room like '%'+@Room+'%' OR @Room='' OR @Room IS NULL)
	AND ([Table] like '%'+@Table+'%' OR @Table='' OR @Table IS NULL)
	GROUP BY BillDate, InvoiceNo, BillNo, BillCustomer,  Waiter, [Table], Room, ProviderName, PaymentMode, Cashier
ELSE
SELECT       InvoiceNo, BillDate,  BillNo, BillCustomer as Customer,  Waiter, [Table], Room, Cashier, SUM(PayAmount) AS Amount
	FROM            RO_Sales_View
	WHERE 1=1 	
	AND (InvoiceNo=@InvoiceNo OR @InvoiceNo=0)
	AND (PaymentModeID = @PaymentModeID OR @PaymentModeID=0 )  
	AND  (CAST(DATEADD(HOUR,-4,BillDate) AS Date) >= @DateFrom  OR @DateFrom IS NULL) 
	AND (CAST(DATEADD(HOUR,-4,BillDate) AS Date)<= @DateTo OR @DateTo IS NULL)
	AND  (DATEPART(HOUR,BillDate) >= @TimeFrom OR @TimeFrom=0) 
	AND (DATEPART(HOUR, BillDate) <= @TimeTo OR @TimeTo=0)
	AND (ProviderName like '%'+@Provider+'%' OR @Provider='' OR @Provider IS NULL)
	AND (BillCustomer like '%'+@Customer+'%' OR @Customer='' OR @Customer IS NULL)
	AND (Waiter like '%'+@Waiter+'%' OR @Waiter='' OR @Waiter IS NULL)  
	AND (Cashier like '%'+@Cashier+'%' OR @Cashier='' OR @Cashier IS NULL)  
	AND (Room like '%'+@Room+'%' OR @Room='' OR @Room IS NULL)
	AND ([Table] like '%'+@Table+'%' OR @Table='' OR @Table IS NULL)
	GROUP BY BillDate, InvoiceNo, BillNo, BillCustomer, Waiter, [Table], Room,  Cashier

GO
