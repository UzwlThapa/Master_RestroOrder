SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetCustomerFromRoomBooking]
AS
BEGIN
	select CustomerId, CustomerName, PhoneNo, EmailAddress, CtznNo 
	from Ro_RoomBookings group by 
	CustomerId,CustomerName,PhoneNo, EmailAddress, CtznNo 
END

GO
