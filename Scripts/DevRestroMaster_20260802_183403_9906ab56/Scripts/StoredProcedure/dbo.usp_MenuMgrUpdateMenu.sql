SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrUpdateMenu] 
 @MenuName VARCHAR(100),
 @MenuType VARCHAR(50),
 @IsDefault BIT,
 @PortalID INT,
 @MenuID INT 
AS
BEGIN
 IF(@IsDefault = 1)
   BEGIN
    UPDATE  
     [dbo].[MENU] 
    SET 
     IsDefault = 0 
    WHERE 
      IsDefault= 1 
     AND PortalID=@PortalID     
 
    UPDATE  
     [dbo].[MENU] 
    SET 
     MenuName =@MenuName,
     IsDefault=@IsDefault,
     MenuType = @MenuType 
    WHERE 
     MenuID=@MenuID    
   END
 ELSE
   BEGIN
    UPDATE  
     [dbo].[MENU] 
    SET 
     MenuName =@MenuName,
     MenuType = @MenuType 
    WHERE MenuID=@MenuID
   END
END





GO
