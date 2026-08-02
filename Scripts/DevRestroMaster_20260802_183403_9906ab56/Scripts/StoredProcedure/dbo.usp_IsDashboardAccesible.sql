SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_IsDashboardAccesible] 
	@UserName NVARCHAR(256)
	,@PortalID INT
AS
BEGIN
	DECLARE @IsAccessible BIT =0
	IF(LOWER(@UserName)='superuser')	
	BEGIN 
		IF (
				EXISTS (
					SELECT TOP 1 1
					FROM PortalUser AS PU
					LEFT JOIN aspnet_UsersInRoles AS AUR ON AUR.UserID = PU.UserID
					LEFT JOIN PagePermission AS PP ON PP.RoleID = AUR.RoleID
					WHERE PU.IsActive = 1
						AND (
							PU.Isdeleted = 0
							OR PU.IsDeleted = NULL
							)
						AND PU.userName = @UserName
						AND pp.PageID = 2
					)
				)
				BEGIN
			SET @IsAccessible = 1
		END
	END
	ELSE IF (
			EXISTS (
				SELECT TOP 1 1
				FROM PortalUser AS PU
				LEFT JOIN aspnet_UsersInRoles AS AUR ON AUR.UserID = PU.UserID
				LEFT JOIN PagePermission AS PP ON PP.RoleID = AUR.RoleID
				WHERE PU.IsActive = 1
					AND (
						PU.Isdeleted = 0
						OR PU.IsDeleted = NULL
						)
					AND PU.userName = @UserName
					AND PU.PortalID = @PortalID
					AND pp.PageID = 2
				)
			)
	BEGIN
		SET @IsAccessible = 1
	END
	SELECT @IsAccessible AS Accessible
END




GO
