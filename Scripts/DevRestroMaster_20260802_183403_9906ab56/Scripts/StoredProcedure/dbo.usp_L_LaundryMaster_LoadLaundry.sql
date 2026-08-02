SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_LaundryMaster_LoadLaundry]
AS
SELECT dbo.L_LaundryMaster.ID
	,dbo.L_LaundryMaster.RoomID
	,dbo.L_LaundryMaster.CustomerID
	,dbo.L_LaundryMaster.DATE
	,dbo.L_LaundryMaster.DeliveryDate
	,dbo.L_LaundryMaster.ChallanNo
	,dbo.L_LaundryMaster.HouseKeeperID
	,dbo.L_LaundryMaster.IsDelivered
	,dbo.L_LaundryMaster.Amount
	,dbo.L_LaundryMaster.DiscountType
	,dbo.L_LaundryMaster.Discount
	,dbo.L_LaundryMaster.Total
	,dbo.RO_restroTable.restrotableTitle AS RoomNAME
	,dbo.RO_RestroRoom.restroRoom as RoomTypeName
	,dbo.RO_LoyaltyMembership.Fname + ' ' + dbo.RO_LoyaltyMembership.Lname AS 

CustomerName
	,dbo.aspnet_Users.UserName AS HouseKeeperName
FROM dbo.L_LaundryMaster
LEFT JOIN dbo.RO_restroTable ON dbo.L_LaundryMaster.RoomID = 

dbo.RO_restroTable.restrotableId
LEFT JOIN dbo.RO_RestroRoom ON dbo.L_LaundryMaster.RoomTypeID = 

dbo.RO_RestroRoom.restroRoomId
LEFT JOIN dbo.RO_LoyaltyMembership ON dbo.L_LaundryMaster.CustomerID = 

dbo.RO_LoyaltyMembership.MembershipID
LEFT JOIN dbo.aspnet_Users ON dbo.L_LaundryMaster.HouseKeeperID = cast

(dbo.aspnet_Users.UserId AS NVARCHAR(50))
	--select * from dbo.aspnet_Users



GO
