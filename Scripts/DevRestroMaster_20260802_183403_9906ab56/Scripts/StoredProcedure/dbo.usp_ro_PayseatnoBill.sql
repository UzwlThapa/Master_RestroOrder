SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_PayseatnoBill]
@OrderMasterId INT,
@OrderDetailsID INT,
@SeatNo INT
AS

UPDATE dbo.RO_Order_Detail SET BillPaid=1 WHERE OrderMasterId=@OrderMasterId AND OrderDetailsID=@OrderDetailsID




GO
