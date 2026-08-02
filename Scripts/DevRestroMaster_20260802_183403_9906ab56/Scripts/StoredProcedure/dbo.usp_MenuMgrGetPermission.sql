SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrGetPermission] 
 @MenuID INT,
 @PortalID INT

AS
BEGIN
 SELECT 
  PermissionID,
  CAST(RoleID AS NVARCHAR(250)) AS RoleID,
  Username 
 FROM 
  MenuPermission 
 WHERE 
   MenuID=@MenuID 
  AND PortalID=@PortalID
END





GO
