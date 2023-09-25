CREATE PROCEDURE [dbo].[usp_L_LaundryMaster_SaveLaundry] @id INT
	,@roomtypeid INT
	,@roomid INT
	,@customerid INT
	,@date DATE
	,@deliverydate DATE
	,@challanno INT
	,@housekeeperid NVARCHAR(50)
	,@isdelivered bit
	,@amount decimal
	,@disctype nvarchar(max)
	,@discount decimal
	,@total decimal
AS
IF (@id = 0)
BEGIN
	INSERT INTO dbo.L_LaundryMaster (
		roomtypeid
		,RoomID
		,CustomerID
		,[DATE]
		,DeliveryDate
		,ChallanNo
		,HouseKeeperID
		,IsDelivered
		,Amount
		,DiscountType
		,Discount
		,Total
		)
	VALUES (
		@roomtypeid
		,@roomid
		,@customerid
		,@date
		,@deliverydate
		,@challanno
		,@housekeeperid
		,@isdelivered
		,@amount
		,@disctype
		,@discount
		,@total
		)

	SELECT cast(@@IDENTITY AS INT)
END
ELSE
BEGIN
	UPDATE dbo.L_LaundryMaster
	SET RoomTypeID = @roomtypeid
		,[RoomID] = @roomid
		,[CustomerID] = @customerid
		,[DATE] = @date
		,[DeliveryDate] = @deliverydate
		,[ChallanNo] = @challanno
		,[HouseKeeperID] = @housekeeperid
		,[IsDelivered] = @isdelivered
		,[Amount] = @amount
		,[DiscountType] = @disctype
		,[Discount] = @discount
		,[Total] = @total
	WHERE ID = @id

	SELECT cast(@id AS INT)
END