SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_updateOrderDetails]
@orderDetailsId INT,
@qty VARCHAR(128),
@netAmount DECIMAL(18,2)
AS
BEGIN
	UPDATE dbo.RO_Order_Detail SET	
	Quantity=@qty,
	NetAmount=@netAmount
	--,BillPaid=1
	WHERE OrderDetailsID=@orderDetailsId
END



GO
