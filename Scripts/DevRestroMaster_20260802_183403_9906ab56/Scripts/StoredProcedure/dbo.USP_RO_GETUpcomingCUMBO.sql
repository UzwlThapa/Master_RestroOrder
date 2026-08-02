SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_GETUpcomingCUMBO]  
AS  
BEGIN  
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
   and  StartDate > getdate()
END  

GO
