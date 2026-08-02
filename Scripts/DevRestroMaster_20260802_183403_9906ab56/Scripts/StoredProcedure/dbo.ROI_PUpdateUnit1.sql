SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ROI_PUpdateUnit1]   
(   
 @UnitId int output,   
 @UnitDesc varchar(100)=null,   
 @Symbol varchar(5)=null  
)  
as   
begin  
 Declare @ErrorMsg varchar(1000)  
 if isnull(@UnitId,0) < 0  
 begin  
  Delete From ROI_Unit1 where Unit1Id = @UnitId * -1   
 end  
 else if ISNULL(@UnitId,0)= 0 
 begin  
 --select * from ROI_Unit1 where UnitDescription = 'test1' and IsArchived=0
  if exists(select * from ROI_Unit1 where UnitDescription = @UnitDesc and IsArchived=0)  
  begin  
   set @ErrorMsg = 'ERROR!!! Duplicate UnitName [' + @UnitDesc + '] Not Valid.'  
   raiserror (@ErrorMsg,16,1)  
   goto lblExit  
  end  
    
  if exists(select * from ROI_Unit1 where Symbol = @Symbol and IsArchived=0)   
  begin  
   set @ErrorMsg = 'ERROR!!! Duplicate Symbol [' + @Symbol + '] Not Valid.'  
   raiserror( @ErrorMsg,16,1)  
   goto lblExit  
  end  

  insert into ROI_Unit1 (UnitDescription, Symbol) values ( @UnitDesc, @Symbol)  
  
 end  
 else if isnull(@UnitId,0) > 0  
 begin  
  if exists(select * from ROI_Unit1 where UnitDescription = @UnitDesc and Unit1Id <> @UnitId and isarchived=0)  
  begin  
   set @ErrorMsg =  'ERROR!!! Duplicate UnitName [' + @UnitDesc + '] Not Valid.'  
   raiserror (@ErrorMsg,16,1)  
   goto lblExit  
  end  
  if exists(select * from ROI_Unit1 where Symbol = @Symbol and Unit1Id <> @UnitId and isarchived=0)   
  begin  
   set @ErrorMsg = 'ERROR!!! Duplicate Symbol [' + @Symbol + '] Not Valid.'  
   raiserror (@ErrorMsg,16,1)  
   goto lblExit  
  end  
  update ROI_Unit1 set UnitDescription = @UnitDesc, Symbol = @Symbol where Unit1Id = @UnitId  
 end  
lblExit:  
  
end  




GO
