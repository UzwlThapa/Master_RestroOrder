SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- [USP_RO_GETCUMBO] 1
-- DROP PROCEDURE [dbo].[USP_RO_GETCUMBO]  
CREATE PROCEDURE [dbo].[USP_RO_GETCUMBO]  
@activeOnly bit=NULL
AS  
BEGIN  
exec USP_InactiveCombo;
 SELECT [ComboID]  
      ,[Name]  
      ,[ImagePath]
	  ,CostCenterID  as CostCenter
   ,ComboCode,
   Description,  
   CONVERT(VARCHAR(10),[StartDate],102) as StartDatee  
      ,CONVERT(VARCHAR(10),[EndDate],102) as EndDatee   
      ,[SalesPrice]  
      ,[ItemsSalesCost]  
      ,[IsActive]  
      ,[AddedBy]  
      ,[IsDeleted]  
                
 FROM [dbo].[RO_Combo] where IsDeleted = 0   
 and (IsActive = @activeOnly or @activeOnly IS NULL)
  and getdate() > StartDate
END  

GO
