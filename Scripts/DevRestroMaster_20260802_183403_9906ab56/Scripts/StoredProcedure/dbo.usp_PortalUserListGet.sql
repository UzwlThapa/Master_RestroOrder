SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PortalUserListGet] 
(
 @PortalID INT
)
AS
SELECT
 [PortalUserID],
 [PortalID],
 [IsActive],
 [IsDeleted],
 [IsModified],
 [AddedOn], 
 [AddedBy],
 [UpdatedBy],
 [DeletedBy],
 [dbo].[aspnet_users].*
FROM [dbo].PortalUser
INNER JOIN dbo.aspnet_Users ON dbo.PortalUser.UserID =dbo.aspnet_Users.UserId
WHERE [dbo].[PortalUser].[PortalID]=@PortalID  or [dbo].[PortalUser].Username in
(select p.UserName from PortalUser p
INNER JOIN aspnet_usersinroles AU
ON P.UserID=AU.UserId INNER JOIN aspnet_roles AR ON AR.RoleId=AU.RoleId AND AR.RoleName='Super User')





GO
