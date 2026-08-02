SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP procedure [dbo].[ROI_GetUnit2]    
CREATE PROCEDURE [dbo].[ROI_GetUnit2]    
as    
begin    
--select Unit2ID,FirstUnit,SecondUnit, (select UnitDescription from dbo.ROI_Unit1 where  Unit1Id=FirstUnit) AS Firstunitname    
--,(select UnitDescription from dbo.ROI_Unit1 where  Unit1Id=SecondUnit) AS Secondunitname,Conversion    
--  from dbo.ROI_Unit2    
 --select * from FGetUnitTB()    
 Select UnitID, FirstUnitID, SecondUnitID, Conversion, FirstUnitCode, SecondUnitCode, FirstUnit, SecondUnit, IsFirst
 From
 (select u.Unit1Id UnitID,u.Unit1Id FirstUnitID,u.Unit1Id SecondUnitID,1 as Conversion 
 , u.Symbol FirstUnitCode,u.Symbol SecondUnitCode,u.UnitDescription FirstUnit,U.UnitDescription SecondUnit
 , 1 as IsFirst from ROI_Unit1 u where IsArchived=0 
 union  
 select u.Unit2ID UnitID,u.FirstUnit FirstUnitID,u.SecondUnit SecondUnitID, u.Conversion
 ,u1.Symbol FirstUnitCode,u2.Symbol SecondUnitCode,u1.UnitDescription FirstUnit,u2.UnitDescription SecondUnit
 ,0 as IsFirst from ROI_Unit2 u  
 inner join ROI_Unit1 u1 on u.FirstUnit = u1.Unit1Id  
 inner join ROI_Unit1 u2 on u.SecondUnit = u2.Unit1Id where u.IsArchived=0    
 ) results
  order by FirstUnit, SecondUnit

   -- select * from ROI_Unit1  
   --select * from ROI_Unit2  
  end 



GO
