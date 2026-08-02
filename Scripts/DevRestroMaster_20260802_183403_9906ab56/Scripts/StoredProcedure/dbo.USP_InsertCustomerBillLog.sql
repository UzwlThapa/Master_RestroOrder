SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_InsertCustomerBillLog]
	@CustomerID INT
	,@CashPaid DECIMAL(18, 2)
	,@salesMasterId INT
	
AS
Declare @PayAmount decimal(18,2),
@LogId int,
@Balance decimal(18,2),
@TotalBalance decimal(18,2),
@Coupon int,
@Point int,
@DisountThresholdValue decimal(18,2)
--,@Amount DECIMAL(18, 2)


SET @DisountThresholdValue = (Select CAST(MIN(CAST(Point as INT)) AS decimal(18,2)) from RO_PointScheme)
if(@DisountThresholdValue != 0)
BEGIN
select @LogId=isnull(max(BillLogId),0) from RO_CustomerBillLog where CustomerID=@CustomerID
if (@LogId = 0)
BEGIN
set @TotalBalance = @CashPaid 
if (@CashPaid > @DisountThresholdValue)
set @Coupon = 1
else
set @Coupon = 0
END
ELSE
BEGIN
select @PayAmount = Balance from RO_CustomerBillLog where BillLogId=@LogId and CustomerID=@CustomerID
set @Balance= @PayAmount + @CashPaid
if(@Balance > @DisountThresholdValue)
BEGIN
set @TotalBalance = 0 
set @Coupon = 1
END
else
BEGIN
set @TotalBalance = @Balance
set @Coupon = 0

END
END
BEGIN
DECLARE @BillDate DATETIME
DECLARE @BillAmount DECIMAL(18, 2)
DECLARE @billNo nvarchar(max)

Select @BillDate = BillDate, @billNo = billNo, @BillAmount =NetAmount from RO_SalesMaster where salesMasterId=@salesMasterId
--select @Amount=sum(PayAmount) from RO_SalesPaymentMode where salesMasterId=@salesMasterId

	INSERT INTO RO_CustomerBillLog (
	BillDate,
	CustomerID,
	billNo,
	BillAmount,
	CashPaid,
	DiscountCoupon,
	Balance
		)
	VALUES (
	 @BillDate 
	,@CustomerID 
	,@billNo 
	,@BillAmount 
	,@CashPaid
	,@Coupon
	,@TotalBalance 
		)


		
select @Coupon
END
END
ELSE
select @Coupon =  0

GO
