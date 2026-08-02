SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  FUNCTION [dbo].[UDFsplit]  
(  
    @ListString nvarchar(max),  
    @Delimiter  char(1)  
   )   
RETURNS @ListTable TABLE (SplittedValue NVARCHAR(4000))  WITH EXECUTE AS CALLER    
AS  
BEGIN      
    DECLARE @CurrentPosition INT, @NextPosition INT, @Item NVARCHAR(MAX), @ID INT, @len INT  
     
    SELECT @len = len(replace(@Delimiter,' ','^'))  
   , @ListString = @ListString + @Delimiter  
            , @CurrentPosition = 1   
    SELECT @NextPosition = Charindex(@Delimiter, @ListString, @CurrentPosition)  
 WHILE @NextPosition > 0 Begin  
   SET  @Item = ltrim(rtrim(substring(@ListString, @CurrentPosition, @NextPosition-@CurrentPosition)))  
   INSERT Into @ListTable (SplittedValue) Values (@Item)    
    SET  @CurrentPosition = @NextPosition+@len  
    SET  @NextPosition = Charindex(@Delimiter, @ListString, @CurrentPosition)  
  END  
    RETURN  
END  

------------------------------------------------------------------------------------------------------------------------------------
--GO





GO
