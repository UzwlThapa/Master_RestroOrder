SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GETITEMFORCUMBO]
AS
BEGIN
select ITName as ItemName, IM.ITId as ItemID,IR.SRate AS PRate from dbo.ROI_ITEMMain im
	INNER JOIN DBO.ROI_ItemDetails ID ON IM.ITId = ID.ITId
	INNER JOIN DBO.ROI_ItemRate IR ON IR.ItemID = IM.ITId WHERE PITId !=0 and im.IsArchived=0 and IsCategory=0 and IsActive=1 and IsProdMaterial=0
	
	ORDER BY ITName 
END



GO
