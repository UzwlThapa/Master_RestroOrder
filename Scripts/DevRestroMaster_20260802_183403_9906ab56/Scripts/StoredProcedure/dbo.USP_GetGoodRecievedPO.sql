SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetGoodRecievedPO]
as
begin
SELECT DISTINCT PM.PuNo, gm.GMId, gm.GMNo, gm.InvoiceNo
FROM          
    RO_GoodsReceivedDetls AS rgd inner join RO_GoodsReceivedMain gm on rgd.GMId=gm.GMId
	LEFT JOIN
	ROI_PurchaseDetails as PD ON rgd.PDId = PD.PurchaseDetailsID left join
	ROI_PurchaseMain PM ON PM.PurchaseMainID = PD.PurchaseMainID where PM.PuNo IS NOT NULL  
	ORDER By gm.GMId DESC


END

GO
