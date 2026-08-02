SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ROI_PUpdateUnit2] (  
  
@UnitId int output,   
  
@FUnitId int,   
  
@SUnitId int,   
  
@Conversion int )  
  
as   
  
begin  
  
  
  
 Declare @ERRMsg varchar(1000)  
  
 if isnull(@UnitId,0)<0  
  
 begin  
  
  Delete From ROI_Unit2 where Unit2Id = @UnitId * -1   
  
 end  
  
 else if ISNULL(@UnitId,0)=0  
  
 begin  
  
  if @FUnitId = @SUnitId   
  
  begin  
  
   set @ERRMsg = 'ERROR! First and Second Unit Cannot Be Same.'  
  
   raiserror (@ERRMsg, 16,1)  
  
   return @ERRMsg  
  
  end  
  
  
  
  if exists(select * from ROI_Unit2 where FirstUnit = @FUnitId and SecondUnit = @SUnitId and Conversion = @Conversion and IsArchived=0)  
  
  begin  
  
   set @ERRMsg=  'ERROR! Duplicate Compound Unit Not Valid!'  
  
   raiserror (@ERRMsg, 16,1)  
  
   return @ERRMsg  
  
  end  
  
  
  
  IF EXISTS(SELECT * FROM ROI_Unit2 WHERE SecondUnit = @FUnitId and IsArchived=0)  
  
  BEGIN  
  
   SET @ERRMsg = 'ERROR! First Unit Already Used As Small Unit!'  
  
   raiserror (@ERRMsg, 16,1)  
  
   return @ERRMsg  
  
  END  
  
     
  --declare @UnitId int
  set @UnitId = (select isnull(max(x.unitId),0) + 1  from (select Unit1Id  as UnitId from ROI_Unit1  where IsArchived=0
  union select unit2Id as UnitId from ROI_Unit2 where IsArchived=0) x)  
  --select @UnitId
  
 -- insert into ROI_Unit2 (Unit2Id, FirstUnit, Conversion, SecondUnit) values (@UnitId, @FUnitId, @Conversion, @SUnitId)  
    insert into ROI_Unit2 (FirstUnit, Conversion, SecondUnit) values (@FUnitId, @Conversion, @SUnitId)  
  declare @concated nvarchar(500);  
  set @concated = coalesce(Cast(@FUnitId as varchar(50)) +',' + Cast(@SUnitId as varchar(50)) ,' ');  
  
  
  
  declare @part nvarchar(500);  
  
    
    
  
  set @part = coalesce((select UnitDescription from ROI_Unit1 where Unit1Id = @SUnitId and IsArchived=0) + ' of ' + Cast(@Conversion as varchar(50)) + '  ' + (select UnitDescription from ROI_Unit1 where Unit1Id = @FUnitId and IsArchived=0) ,' ');  
  
  
  insert into ROI_Unit3 (FUnit, SUnit,  Conversion, UnitName, InCode, Particulars) values (@FUnitId,  @SUnitId,  @Conversion, (select UnitDescription from ROI_Unit1 where Unit1Id = @FUnitId) , @concated, @part )  
  
 end  
  
 else if ISNULL(@UnitId, 0) > 0  
  
 begin  
  
  if @FUnitId = @SUnitId   
  
  begin  
  
   set @ERRMsg = 'ERROR! First and Second Unit Cannot Be Same.'  
  
   raiserror (@ERRMsg, 16,1)  
  
   return @ERRMsg  
  
  end  
  
    
  
  if exists(select * from ROI_Unit2 where FirstUnit = @FUnitId and SecondUnit = @SUnitId and Conversion = @Conversion and Unit2Id <> @UnitId and IsArchived=0)  
  
  begin  
  
   set @ERRMsg ='ERROR! Duplicate Compound Unit Not Valid!'  
  
   raiserror (@ERRMsg, 16,1)  
  
   return @ERRMsg  
  
  end  
  
    
  
  update ROI_Unit2 set FirstUnit = @FUnitId, SecondUnit = @SUnitId, Conversion = @Conversion  where Unit2Id = @UnitId   
  --update  ROI_Unit3 set UnitId = @UnitId, FUnit = @FUnitId, SUnit = @SUnitId,  Conversion = @Conversion, UnitName = (select UnitDescription from ROI_Unit1 where Unit1Id = @FUnitId) , InCode= @concated, Particulars = @part  
    
  
 end  
  
end 



GO
