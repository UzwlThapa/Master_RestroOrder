SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec usp_sftemplate_activate 'default',1,1  
CREATE PROCEDURE [dbo].[usp_sftemplate_activate]  
 (  
 @TemplateName NVARCHAR (50),  
 @IsActive BIT,  
 @PortalID INT  
) AS  
BEGIN  
  
IF (EXISTS(  SELECT   1  
   FROM  sftemplate  
   WHERE  PortalID =@PortalID  
  ))  
   
   BEGIN  
      UPDATE  sftemplate  
      SET   TemplateName =@TemplateName, IsActive =@IsActive  
      WHERE  PortalID =@PortalID  
   END  
     
ELSE  
  
BEGIN  
   INSERT INTO sftemplate (  
  TemplateName,  
  IsActive,  
  PortalID  
    )  
   VALUES  
    (  
  @TemplateName ,@IsActive ,@PortalID  
    )  
   END  
  
    
END





GO
