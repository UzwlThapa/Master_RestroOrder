SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_GETITEMFORGOODS]
AS
BEGIN

select DISTINCT ITName
--, PD.PurchaseMainID, PurchaseDetailsID
,im.ITId
  from 
  --dbo.RO_GoodsReceivedDetls gr INNER JOIN DBO.ROI_PurchaseDetails PD ON PD.PurchaseDetailsID = GR.PDId INNER JOIN 
DBO.ROI_ITEMMain IM
join dbo.ROI_ItemDetails id on im.itid=id.ITId  where id.IsProdMaterial=1 and im.IsActive=1 and im.IsArchived=0 and im.IsCategory=0
--ON IM.ITId = PD.ItemID
END



GO
