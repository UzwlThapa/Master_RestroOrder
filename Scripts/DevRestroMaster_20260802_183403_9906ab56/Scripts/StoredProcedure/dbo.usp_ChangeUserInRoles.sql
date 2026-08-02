SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ChangeUserInRoles]
(
 @ApplicationName NVARCHAR(120),
 @UserID UNIQUEIDENTIFIER, 
 @RoleNamesUnselected NVARCHAR(4000),
 @RoleNamesSelected NVARCHAR(4000),
 @PortalID INT
)
AS
 BEGIN
 DECLARE @ErrorCode INT
 SET @ErrorCode=0
  EXEC [dbo].[usp_sf_UserInRolesDelete] @ApplicationName,@UserID,@RoleNamesUnselected,@PortalID,@ErrorCode output;
  EXEC [dbo].[usp_sf_UserInRolesAdd] @ApplicationName,@UserID,@RoleNamesSelected,@PortalID; 
END





GO
