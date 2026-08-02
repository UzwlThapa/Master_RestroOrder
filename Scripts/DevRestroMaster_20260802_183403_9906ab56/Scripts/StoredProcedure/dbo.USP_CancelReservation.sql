SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_CancelReservation]
@CancelledBy nvarchar(250),
@ReservationID int
as
update RO_TableReservation  set IsCancelled = 1, CancelledBy = @CancelledBy, CancelledOn=getdate() where ReservationID=@ReservationID

GO
