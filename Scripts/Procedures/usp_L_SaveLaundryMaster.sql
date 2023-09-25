

CREATE PROCEDURE [dbo].[usp_L_SaveLaundryMaster] @roomid INT
	,@customerid INT
	,@date DATE
	,@deliverydate DATE
	,@challanno INT
	,@housekeeperid INT
AS
INSERT INTO dbo.L_LaundryMaster (
	RoomID
	,CustomerID
	,[DATE]
	,DeliveryDate
	,ChallanNo
	,HouseKeeperID
	)
VALUES (
	@roomid
	,@customerid
	,@date
	,@deliverydate
	,@challanno
	,@housekeeperid
	)
	select cast(@@IDENTITY as int)
