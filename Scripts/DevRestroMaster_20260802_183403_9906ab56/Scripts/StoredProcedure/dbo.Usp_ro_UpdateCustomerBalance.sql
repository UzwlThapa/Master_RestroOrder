SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Usp_ro_UpdateCustomerBalance]
@SalesMasterID int
,@SalesType varchar(30) = null
AS
begin
   DECLARE @AdvanceAmt decimal(18,2) = 0
    ,@NetAmt decimal(18,2) = 0
	,@CreditAmt decimal(18,2) = 0
	,@Payamount decimal(18,2) = 0
	,@CusID int = 0
	,@ReturnPayment decimal(18,2) = 0
	,@Username nvarchar(250)
	,@RemainingBalance decimal(18,2) = 0

	if(ISNULL(@SalesType,'')='')
	begin
	select top 1  @CusID = CusID from RO_SalesPaymentMode where salesMasterId=@salesmasterId
	end
	else
	begin
	select top 1  @CusID = CusID from RO_Cake_SalesPaymentMode where SalesMasterId=@salesmasterId and LOWER(SalesType)=LOWER(ISNULL(@SalesType,''))
	end
	
	
	--select @Payamount = isnull(sum(PayAmount),0)  from RO_SalesPaymentMode spm 
	--inner join RO_SalesMaster sm  on spm.salesMasterId=sm.salesMasterId 
	--where sm.salesMasterId = @salesmasterId and PaymentModeID<>4

	if(ISNULL(@SalesType,'')='')
	begin

	select @AdvanceAmt = AdvancePayment,  @NetAmt = NetAmount, @Username=Waiter from RO_SalesMaster
	where salesMasterId=@SalesMasterID

	select @CreditAmt=isnull(PayAmount,0) from RO_SalesPaymentMode 
	where salesMasterId = @salesmasterId and PaymentModeID=4

	select @ReturnPayment=isnull(ReturnPayment,0) from RO_SalesPaymentMode 
	where salesMasterId = @salesmasterId 
	end
	else
	begin
	select @AdvanceAmt = AdvancePayment,  @NetAmt = NetAmount, @Username='Waiter' from RO_CakeSalesMaster
	where salesMasterId=@SalesMasterID and LOWER(SalesType)=LOWER(ISNULL(@SalesType,''))

	select @CreditAmt=isnull(PayAmount,0) from RO_Cake_SalesPaymentMode 
	where salesMasterId = @salesmasterId and PaymentModeID=4 and LOWER(SalesType)=LOWER(ISNULL(@SalesType,''))

	select @ReturnPayment=isnull(ReturnPayment,0) from RO_Cake_SalesPaymentMode 
	where salesMasterId = @salesmasterId and LOWER(SalesType)=LOWER(ISNULL(@SalesType,''))
	end
	



	if(@CusID > 0)
	BEGIN 
		
		if  (@AdvanceAmt < @NetAmt)
		BEGIN
					UPDATE RO_LoyaltyMembership
					SET RemainingBalance += (@AdvanceAmt + @CreditAmt) 
					WHERE MembershipID = @CusID
					
		END
		ELSE --(@AdvanceAmt > @NetAmt)
		BEGIN		
					UPDATE RO_LoyaltyMembership
					SET RemainingBalance += @NetAmt --+ @ReturnPayment
					WHERE MembershipID = @CusID
		END

		--select @RemainingBalance=RemainingBalance from RO_LoyaltyMembership where MembershipID=@CusID
		--DECLARE @MemberPayId int = 0

		--if(@ReturnPayment > 0)
		--INSERT INTO [dbo].[RO_MemberPay] VALUES
		--(@CusID,@RemainingBalance,-@ReturnPayment,GETDATE(),@Username,1,0,0,@ReturnPayment)
		--	SELECT @MemberPayId = @@IDENTITY 

	END

end

GO
