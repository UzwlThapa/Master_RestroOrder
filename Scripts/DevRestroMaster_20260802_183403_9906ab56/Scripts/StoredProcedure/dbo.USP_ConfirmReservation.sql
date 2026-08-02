SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_ConfirmReservation]
@ConfirmedBy nvarchar(250),
@ReservationID int
as
update RO_TableReservation  set IsConfirmed = 1, ConfirmedBy = @ConfirmedBy where ReservationID=@ReservationID

GO
