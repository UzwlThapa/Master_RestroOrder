SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[getUserbyHouseKeepingRole]
AS
SELECT au.UserId
	,au.UserName as Username
FROM vw_aspnet_Users au
JOIN aspnet_UsersInRoles aur ON au.UserId = aur.UserId
JOIN aspnet_Roles ar ON ar.RoleId = aur.RoleId
WHERE LoweredRoleName = 'housekeeping'





GO
