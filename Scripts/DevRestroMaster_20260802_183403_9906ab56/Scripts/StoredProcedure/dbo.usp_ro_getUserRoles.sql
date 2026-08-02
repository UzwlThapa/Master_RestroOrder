SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ro_getUserRoles]
as
select distinct Username as UserName, 
            (
                SELECT r.LoweredRoleName + ',' AS [text()]
                FROM dbo.aspnet_Roles r
				join aspnet_UsersInRoles ur on ur.UserId=pu.UserID
                WHERE r.RoleId = ur.RoleId
                ORDER BY r.RoleId
                FOR XML PATH ('')
            ) AS Roles
from PortalUser pu

GO
