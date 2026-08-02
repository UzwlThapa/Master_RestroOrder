SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP  PROCEDURE [dbo].[USP_GetPurchaseReturnMain]
CREATE PROCEDURE [dbo].[USP_GetPurchaseReturnMain]
as
select distinct pm.PurchaseReturnId, pm.PRNo, gm.GMNo, rpm.PuNo, pm.PostedOn from RO_PurchaseReturnMain pm inner join RO_PurchaseReturnDetails pd on pm.PurchaseReturnId=pd.PurchaseReturnId
left join RO_GoodsReceivedDetls gd on gd.GDId = pd.GDId
left join RO_GoodsReceivedMain gm on gm.GMId = gd.GMId
left join ROI_PurchaseDetails rpd on rpd.PurchaseDetailsID = gd.PDId
left join ROI_PurchaseMain rpm on rpm.PurchaseMainID = rpd.PurchaseMainID
order by pm.PurchaseReturnId desc

GO
