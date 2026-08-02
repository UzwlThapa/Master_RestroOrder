SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--USP_H_LostNFoundReport '2017-04-17','2017-04-17'


CREATE PROCEDURE [dbo].[USP_H_LostNFoundReport]  
@StartDate datetime,
@EndDate datetime

AS  
 BEGIN  
  
  select * from H_LostAndFound
  where Date BETWEEN @StartDate and @EndDate
  order by Date desc
 
END  



GO
