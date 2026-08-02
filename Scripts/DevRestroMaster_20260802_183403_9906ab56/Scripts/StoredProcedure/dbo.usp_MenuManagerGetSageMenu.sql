SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuManagerGetSageMenu]  
(  
 @UserName NVARCHAR(50),  
 @UserModuleID INT,  
 @PortalID INT  
)  
AS  
 BEGIN    
 DECLARE @MenuID NVARCHAR(50)   
    IF EXISTS  
      (  
      SELECT   1
      FROM      SageMenuSettingValue   
      WHERE     UserModuleID=@UserModuleID  
      )  
       BEGIN  
          SELECT     @MenuID=SettingValue   
          FROM       SageMenuSettingValue  
          WHERE       UserModuleID=@UserModuleID  
       END  
    ELSE  
       BEGIN  
        SET @MenuID=0  
       END   
        
      SELECT  DISTINCT MenuID,    MenuName,  
        MenuType,   IsDefault,  
        PortalID,   @MenuID AS SelectedMenu   
      FROM    Menu   
      WHERE   PortalID=@PortalID    
  END





GO
