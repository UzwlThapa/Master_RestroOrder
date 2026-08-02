SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GetCustomerNameFromRoomBooking]
as
select DISTINCT CustomerName from Ro_RoomBookings

GO
