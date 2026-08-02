SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_UpdateTermAmount]
(
    @OrderMasterID INT
)
AS
BEGIN
    UPDATE RO_OrderMasters 
    SET TermAmount = ISNULL((SELECT SUM(Amount) FROM RO_Order_Detail WHERE OrderMasterId = @OrderMasterID), 0)
    WHERE OrderMasterID = @OrderMasterID
END
GO
