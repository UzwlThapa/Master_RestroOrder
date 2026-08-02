SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Split](@String [nvarchar](4000), @Delimiter [char](1))
RETURNS @temptable TABLE (
 [items] [nvarchar](4000) NULL
) WITH EXECUTE AS CALLER
AS 
begin       
     declare @idx int       
     declare @slice nvarchar(4000)       
       
     select @idx = 1       
     if len(@String)<1 or @String is null  
  return       
       
     while @idx!= 0       
     begin       
         set @idx = charindex(@Delimiter,@String)       
         if @idx!=0       
             set @slice = left(@String,@idx - 1)       
         else       
             set @slice = @String       
           
         if(len(@slice)>0)  
             insert into @temptable(Items) values(@slice)       
  else
   Insert Into @temptable(Items) values(null)
         set @String = right(@String,len(@String) - @idx)       
         if len(@String) = 0 
         break       
     end   
 return       
 end





GO
