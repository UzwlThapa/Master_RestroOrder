SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GetGoodsReceivedDetailsByGMId] @gmid INT
AS
SELECT im.itname AS ItemName
	,ru.symbol AS Symbol
	,gd.*
FROM RO_GoodsReceivedDetls gd
JOIN ROI_PurchaseDetails pd ON pd.purchasedetailsid = gd.pdid
JOIN roi_itemmain im ON im.itid = pd.itemid
JOIN roi_unit1 ru ON pd.usedunitid = ru.unit1id
WHERE gd.gmid = @gmid

GO
