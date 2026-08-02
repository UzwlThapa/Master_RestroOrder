SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE  USP_ROI_SaveReservedTable
CREATE PROCEDURE [dbo].[USP_ROI_SaveReservedTable]
  @ReservationID int
 ,@TableID int 

 AS
BEGIN
	INSERT INTO RO_ReservedTable
 (
	ReservationID 
	,TableID
		)
	VALUES (
	 @ReservationID 
	,@TableID
		)
END




GO
