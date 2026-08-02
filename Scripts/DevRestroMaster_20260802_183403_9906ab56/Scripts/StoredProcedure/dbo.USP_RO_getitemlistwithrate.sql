SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_RO_getitemlistwithrate] 31  
CREATE PROCEDURE [dbo].[USP_RO_getitemlistwithrate]   
@ItemID int  
AS  
BEGIN  
select m.ITId, m.ITName, r.SRate  from ROI_ITEMMain m    
Inner Join ROI_ItemRate r on m.ITId = r.ItemID  
where m.ITId = @ItemID  
 order by m.ITName
end  



GO
