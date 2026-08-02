SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_ChangeOrderStatus] @OrderDetailID INT
	,@StatusID INT
AS
UPDATE dbo.RO_OrderItemStatus
SET StatusID = @StatusID
WHERE OrderDetailID = @OrderDetailID


GO
