SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getUserByPin]  
@pin varchar(max)
as
		SELECT pu.Username as UserName,us.UserID,Roles = STUFF((SELECT DISTINCT ', ' + aspr.RoleName
           FROM aspnet_Roles aspr 
           WHERE aspr.RoleId in (select RoleId from dbo.aspnet_UsersInRoles uir where uir.UserId=pu.UserID)
          FOR XML PATH('')), 1, 2, '')
		FROM dbo.PortalUser pu
		inner join dbo.Users us
		on us.Username = pu.Username
		WHERE 
		pu.PINcode=@pin



GO
