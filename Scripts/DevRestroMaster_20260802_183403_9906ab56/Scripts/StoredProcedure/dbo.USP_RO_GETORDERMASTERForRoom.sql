SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[USP_RO_GETORDERMASTER] 1
CREATE PROCEDURE [dbo].[USP_RO_GETORDERMASTERForRoom] (@TableId NVARCHAR(50), @orderMasterId INT)
AS
BEGIN
	SELECT *
	FROM dbo.RO_OrderMasters
	LEFT JOIN dbo.RO_Order_Detail ON RO_Order_Detail.OrderMasterId = dbo.RO_OrderMasters.OrderMasterID
	LEFT JOIN ROI_ITEMMain ON ROI_ITEMMain.ITId = RO_Order_Detail.ROI_ItemId
	FULL JOIN RO_CompanyInfo ON RO_CompanyInfo.ID = 1
	WHERE dbo.RO_OrderMasters.TableId = @TableId
		AND dbo.RO_OrderMasters.OrderMasterID = @orderMasterId
		AND RO_OrderMasters.IsCancelled = 0
		AND RO_OrderMasters.BillPaid = 0
END



GO
