SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--drop proc [USP_UserRolebyUsername] 
CREATE PROCEDURE [dbo].[USP_UserRolebyUsername] 
@Username varchar(max)
as
		SELECT pu.Username as UserName,us.UserID,Roles = STUFF((SELECT DISTINCT ',' + aspr.RoleName
           FROM aspnet_Roles aspr 
           WHERE aspr.RoleId in (select RoleId from dbo.aspnet_UsersInRoles uir where uir.UserId=pu.UserID)
          FOR XML PATH('')), 1, 1, '')
		FROM dbo.PortalUser pu
		inner join dbo.Users us
		on us.Username = pu.Username
		where pu.Username = @Username

		

GO
