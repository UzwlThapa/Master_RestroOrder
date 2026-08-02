SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_GETIITEM]  
AS  
BEGIN  
select *  from ROI_ITEMMain m    
join ROI_ItemDetails d on d.ITId = m.ITId  
end  
  



GO
