SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_UserExportList] 
 
AS
BEGIN
SELECT PU.[UserID],
	PU.[Username],
	PU.[FirstName],
	PU.[LastName],
	PU.[Email],
	am.[Password],
	am.[PasswordFormat],
	RoleName = 
        STUFF((SELECT ', ' + RoleName
           FROM aspnet_UsersInRoles  aum1
	INNER JOIN aspnet_Roles  as ar1
	ON aum1.RoleId = ar1.RoleId 
	where 
          aum1.UserId=am.UserId
          FOR XML PATH('')), 1, 2, ''),
	PU.[PortalID],
	am.[IsApproved],
	am.[PasswordSalt]
	FROM
	dbo.aspnet_Membership as am 
	INNER JOIN PortalUser as PU
	ON pu.UserID = am.UserId
	
	WHERE (PU.[IsDeleted]=0 OR PU.[IsDeleted] IS NULL) 
	 AND PU.[Username] NOT IN ('superuser','admin')
	ORDER BY PU.AddedOn DESC 
END





GO
