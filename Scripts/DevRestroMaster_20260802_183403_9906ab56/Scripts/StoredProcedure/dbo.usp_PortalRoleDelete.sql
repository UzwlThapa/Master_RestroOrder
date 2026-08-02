SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PortalRoleDelete]
(
 @RoleID UNIQUEIDENTIFIER,
 @PortalID INT 
)
WITH EXECUTE AS CALLER
AS
 BEGIN     
  DECLARE @MultipleRole INT
  DECLARE @UserTable TABLE(UserId NVARCHAR(MAX),RoleId NVARCHAR(MAX))
   
  
  INSERT INTO @UserTable SELECT UserId,RoleId FROM dbo.aspnet_UsersInRoles WHERE RoleId=@RoleID
  
    SELECT @MultipleRole = count(roleID) from  aspnet_usersinroles where UserID in (select UserId from @UserTable)  
      IF(@MultipleRole > 1 )
   BEGIN
     DELETE FROM dbo.PortalRole WHERE @RoleId = RoleId AND PortalID=@PortalID   
     DELETE FROM dbo.aspnet_UsersInRoles  WHERE @RoleId = RoleId
     DELETE FROM dbo.aspnet_Roles WHERE @RoleId = RoleId
   END
  ELSE
   BEGIN
     DELETE FROM dbo.aspnet_UsersInRoles WHERE UserId IN(select UserId from @UserTable )
     DELETE FROM dbo.aspnet_membership WHERE UserId IN(select UserId from @UserTable )
     DELETE FROM dbo.aspnet_users WHERE UserId IN(select UserId from @UserTable )
     DELETE FROM dbo.PortalUser WHERE UserId IN(select UserId from @UserTable )  
     
     
     DELETE FROM dbo.PortalRole WHERE @RoleId = RoleId AND PortalID=@PortalID 
     DELETE FROM dbo.aspnet_Roles WHERE @RoleId = RoleId
     
   END
   
  
  
END





GO
