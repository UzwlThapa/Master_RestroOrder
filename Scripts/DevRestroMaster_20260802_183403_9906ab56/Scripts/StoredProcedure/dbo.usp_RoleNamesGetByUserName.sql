SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_RoleNamesGetByUserName]
(
 @UserName NVARCHAR(256), 
 @PortalID INT
) 
AS 
  BEGIN 
   DECLARE @RoleName NVARCHAR(4000)
      SELECT @RoleName = COALESCE(@RoleName + ',', '') + rolename 
      FROM  dbo.vw_PortalUsers sfu 
           INNER JOIN aspnet_UsersInRoles AS uir 
           ON uir.UserId = sfu.UserId 
           INNER JOIN aspnet_Roles AS r 
           ON r.RoleId = uir.RoleId 
      WHERE  ( r.RoleName = 'Super User' 
                OR PortalID = @PortalID ) 
             AND UserName = @UserName 
		Order By CreditLimit 
   SELECT @RoleName AS RoleName
  END







GO
