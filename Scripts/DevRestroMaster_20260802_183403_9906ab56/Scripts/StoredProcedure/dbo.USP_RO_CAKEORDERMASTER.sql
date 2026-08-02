SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_CAKEORDERMASTER] (
	 @CakeOrderMasterID INT
	,@BillNo NVARCHAR(256)
	,@Remarks NVARCHAR(1024)
	,@CustomerId INT
	,@CustomerName NVARCHAR(100)
	,@Phone NVARCHAR(100)
	,@Address NVARCHAR(300)
	,@PAN NVARCHAR(18)
	,@AdvanceAmount DECIMAL(18, 2)
	,@DeliveryTime DATETIME = NULL
	,@DeliveryService VARCHAR(20)
	,@CancelReason NVARCHAR(MAX)
	,@AddedBy NVARCHAR(512)
	,@UpdatedBy NVARCHAR(512)
	,@SalesType VARCHAR(30)
	,@OrderTypeID INT  
	)
AS
BEGIN

DECLARE @OrderNo INT =  0  
if (@OrderTypeID = 0) set @OrderTypeID=1  
 IF(@CakeOrderMasterID = 0)
 BEGIN

	SET @OrderNo=isnull((SELECT TOP 1 OrderNo FROM RO_CakeOrderMaster WHERE cast([Date] as date) = cast(getdate() as date) ORDER BY OrderNo DESC),0) + 1  
	INSERT INTO RO_CakeOrderMaster (
		BillNo
		,DATE
		,Remarks
		,CustomerId
		,CustomerName
		,Phone
		,Address
		,PAN
		,StatusId
		,AdvanceAmount
		,DeliveryTime
		,DeliveryService
		,CancelReason
		,AddedBy
		,AddedOn
		,SalesType
		,OrderNo   
		,OrderTypeID   
		)
	VALUES (
		@BillNo
		,GETDATE()
		,@Remarks
		,@CustomerId
		,@CustomerName
		,@Phone
		,@Address
		,@PAN
		,case when @SalesType = 'wholesale' then (select id from RO_StatusMaster where LookUpName = 'confirmed' and UseFor = 'wholesale') 
			  when @SalesType = 'cake' then (select id from RO_StatusMaster where LookUpName = 'confirmed' and UseFor = 'cake') 
			  else 1
		 end
		,@AdvanceAmount
		,@DeliveryTime
		,@DeliveryService
		,@CancelReason
		,@AddedBy
		,GETDATE()
		,@SalesType
		,@OrderNo
		,@OrderTypeID
		)

	SELECT CAST(@@IDENTITY AS INT)

END
ELSE
BEGIN
	UPDATE dbo.RO_CakeOrderMaster
	SET BillNo = @BillNo
		,Remarks = @Remarks
		,AdvanceAmount = @AdvanceAmount
		,CancelReason = @CancelReason
		,SalesType = @SalesType
		,UpdatedBy = @UpdatedBy
		,UpdatedOn = GETDATE()
		,DeliveryTime=@DeliveryTime
		,Address=@Address
		,CustomerName=@CustomerName
		,Phone=@Phone
		,DeliveryService=@DeliveryService
		,OrderNo= @OrderNo

	WHERE OrderMasterID = @CakeOrderMasterID
	select @CakeOrderMasterID
END 
END


GO
