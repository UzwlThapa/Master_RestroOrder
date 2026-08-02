SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_GETPRUCHASEDETAILS]
AS
SELECT DISTINCT pm.PurchaseMainID, pm.PuNo
FROM ROI_PurchaseMain pm
LEFT JOIN ROI_PurchaseDetails pd ON pm.PurchaseMainID = pd.PurchaseMainID
WHERE pd.Quentity > (
		SELECT isnull(sum(gd.Qnty), 0)
		FROM RO_GoodsReceivedDetls gd
		WHERE gd.PDId = pd.PurchaseDetailsID
		)
	--left join RO_GoodsReceivedDetls gd on gd.PDId = pd.PurchaseDetailsID

GO
