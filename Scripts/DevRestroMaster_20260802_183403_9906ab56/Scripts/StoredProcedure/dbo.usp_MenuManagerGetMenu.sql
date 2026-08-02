SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuManagerGetMenu]
(
 @UserName NVARCHAR(50),
 @PortalID INT
)
AS
 BEGIN 
    SELECT  
  DISTINCT MenuID,
     MenuName,
     MenuType,
     IsDefault,
     PortalID
    FROM 
  Menu  
 WHERE 
  PortalID=@PortalID
  END





GO
