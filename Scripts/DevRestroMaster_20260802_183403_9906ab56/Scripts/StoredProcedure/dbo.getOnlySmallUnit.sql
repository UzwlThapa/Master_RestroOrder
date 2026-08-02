SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[getOnlySmallUnit]  
CREATE PROCEDURE [dbo].[getOnlySmallUnit]  
AS  

SELECT --u2.*,   
 u.SecondUnit UnitId  
 ,u1.Symbol Symbol  
 ,u1.UnitDescription AS Particulars  
FROM ROI_Unit2 u  
INNER JOIN ROI_Unit1 u1 ON u.secondunit = u1.Unit1Id  
where u1.IsArchived<>1 and u.IsArchived<>1  
  
UNION
  
SELECT unit1id UnitId  
 ,Symbol Symbol  
 ,UnitDescription AS Particulars  
FROM ROI_Unit1 u1  
WHERE IsArchived = 0  
 AND u1.Unit1Id NOT IN (  
  SELECT FirstUnit  
  FROM ROI_Unit2  
  WHERE IsArchived = 0 
  )  
  order by UnitDescription
  
  


GO
