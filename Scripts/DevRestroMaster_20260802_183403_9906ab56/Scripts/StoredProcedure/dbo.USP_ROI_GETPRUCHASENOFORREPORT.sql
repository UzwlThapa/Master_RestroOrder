SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_GETPRUCHASENOFORREPORT]
AS
SELECT DISTINCT pm.PurchaseMainID, pm.PuNo
FROM ROI_PurchaseMain pm

	--left join RO_GoodsReceivedDetls gd on gd.PDId = pd.PurchaseDetailsID


GO
