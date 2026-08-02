SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Dashboard_GetAssignedRoles]
	@PortalID INT
AS
BEGIN
	SELECT pr.RoleID as RoleId
		,ar.RoleName
		,CASE 
			WHEN pr.RoleID = dr.RoleID
				THEN 1
			ELSE 0
			END AS IsActive
	FROM Dashboard_Roles AS dr
	RIGHT JOIN PortalRole AS pr ON pr.RoleID = dr.RoleID
	JOIN Aspnet_roles AS ar ON ar.RoleID = pr.RoleID
	WHERE (pr.PortalID = @PortalID OR pr.PortalID = - 1
			)
END 




GO
