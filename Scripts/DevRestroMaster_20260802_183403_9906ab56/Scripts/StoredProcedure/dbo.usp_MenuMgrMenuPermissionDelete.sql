SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrMenuPermissionDelete]
 @MenuID INT,                                                  
 @PortalID INT
                                                  
AS
  BEGIN 
    DELETE FROM 
   [MenuPermission] 
  WHERE  
    PortalID=@PortalID 
   AND MenuID=@MenuID
  END





GO
