SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GETITEMDetail]    
@itemID int,  
@isCombo bit  
AS    
BEGIN    
if @isCombo = 1  
select Name ITName,CostCenterID ItemCostCentreID from RO_Combo  where ComboID = @itemID  
else  
select ITName,ItemCostCentreID,IR.SRate from ROI_ITEMMain IM  
inner join ROI_ItemDetails ID on IM.ITId = ID.ITId
INNER JOIN dbo.ROI_ItemRate IR ON IR.ItemID=IM.ITId
where IM.ITId= @itemID
end 




GO
