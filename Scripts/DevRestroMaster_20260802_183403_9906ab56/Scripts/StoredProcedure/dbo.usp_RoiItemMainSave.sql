SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE PROCEDURE [dbo].[usp_RoiItemMainSave] @ITId INT  
 ,@ITName VARCHAR(250)  
 ,@PITId INT  
 ,@isMenu bit  
 ,@isActive bit  
 ,@isCake bit  
 ,@IsWholeSale bit  
 ,@IsRetail bit  
 ,@AddedBy nvarchar(256)  
 --,@IsCategory BIT  
AS  
BEGIN  
 IF (@ITId = 0)  
 BEGIN  
  INSERT INTO ROI_ITEMMain (  
   ITName  
   ,PITId  
   ,IsArchived  
   ,AddedOn  
   ,IsCategory  
   ,IsMenu  
   ,IsActive  
   ,LookupName  
   ,AddedBy  
   )  
  VALUES (  
   @ITName  
   ,@PITId  
   ,0  
   ,GETDATE()  
   ,1  
   ,@isMenu  
   ,@isActive  
   ,case when @isCake = 1 then 'cake'     
      when @IsWholeSale = 1 then 'wholesale'
	  when @IsRetail = 1 then 'retail'
      else null end  
   ,@AddedBy  
   )  
  
  SELECT @@IDENTITY  
 END  
 ELSE  
 BEGIN  
  UPDATE ROI_ITEMMain  
  SET ITName = @ITName  
   ,PITId = @PITId  
   ,IsUpdated = 1  
   ,IsActive=@isActive  
   ,LookupName = (case when @isCake = 1 then 'cake'  
        when @IsWholeSale = 1 then 'wholesale'
	    when @IsRetail = 1 then 'retail'
        else null end)  
   ,UpdatedOn = GETDATE()  
  WHERE ITId = @ITId  
 END  
END  
  
  

GO
