SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_sf_UserInRolesDelete] (
 @ApplicationName NVARCHAR (120),
 @UserID UNIQUEIDENTIFIER,
 @RoleNames NVARCHAR (4000),
 @PortalID INT,
 @ErrorCode INT OUTPUT
) AS
BEGIN
 DELETE
FROM
 dbo.aspnet_UsersInRoles
WHERE
 UserID =@UserID ;
SET @ErrorCode = 0 ; RETURN @ErrorCode
END





GO
