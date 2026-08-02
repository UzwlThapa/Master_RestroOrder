SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED DATE: 2010-03-24
CREATE PROCEDURE [dbo].[sp_RoleGetByUsername]
 @UserName NVARCHAR(256),
 @PortalID INT
AS

BEGIN
 IF(EXISTS(
    SELECT * FROM dbo.vw_SageFrameUser sfu 
    INNER JOIN  
     aspnet_UsersInRoles AS uir ON uir.UserId=sfu.UserId
    INNER JOIN 
     aspnet_Roles AS r ON r.RoleId = uir.RoleId 
    WHERE 
     (r.RoleName='Super User' OR PortalID=@PortalID) 
     AND Username = @UserName 
     AND IsActive=1 
     AND (IsDeleted=0 OR IsDeleted IS NULL)
   ))
  BEGIN
   SELECT DISTINCT r.RoleId FROM dbo.aspnet_Roles r
   INNER JOIN
    dbo.aspnet_UsersInRoles ur on r.roleid=ur.roleid
   INNER JOIN
    dbo.aspnet_Users u ON u.UserId=ur.UserId
   WHERE 
    u.Username = @UserName
  END
 ELSE
  BEGIN
   SELECT DISTINCT r.RoleId FROM dbo.aspnet_Roles r  
   WHERE 
    1=2
  END
END





GO
