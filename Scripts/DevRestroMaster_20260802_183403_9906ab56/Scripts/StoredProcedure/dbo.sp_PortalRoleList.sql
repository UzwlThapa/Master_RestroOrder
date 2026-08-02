SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PortalRoleList]
 @PortalID INT,
 @IsAll BIT,
 @UserName NVARCHAR(256)
WITH EXECUTE AS CALLER
AS
BEGIN 
SET NOCOUNT ON ;

DECLARE @UserHasHostRole BIT, @HostRoleId UNIQUEIDENTIFIER
 
 SELECT @HostRoleId=RoleId FROM dbo.aspnet_roles WHERE RoleName='Super User'
 
 IF(EXISTS(SELECT 1 FROM dbo.Aspnet_usersinroles uir 
    INNER JOIN dbo.Aspnet_users u ON uir.UserId=u.UserId 
    INNER JOIN dbo.Aspnet_roles r ON uir.RoleId = r.RoleId 
    WHERE u.Username=@UserName AND r.RoleName='Super User'))
  BEGIN
   SET @UserHasHostRole=1
  END
 ELSE
  BEGIN
   SET @UserHasHostRole=0
  END
  
 IF(@IsAll=1 OR @UserHasHostRole=1)
 SELECT
  [dbo].[PortalRole].[PortalRoleID],
  [dbo].[PortalRole].[RoleID],
  [dbo].[aspnet_roles].RoleName
 -- [dbo].[PortalRole].[PortalID],   
  --,
  --[dbo].[PortalRole].[IsActive],
  --[dbo].[PortalRole].[IsDeleted],
  --[dbo].[PortalRole].[IsModified],
  --[dbo].[PortalRole].[AddedOn],
  --[dbo].[PortalRole].[UpdatedOn],
  --[dbo].[PortalRole].[DeletedOn],
  --[dbo].[PortalRole].[AddedBy],
  --[dbo].[PortalRole].[UpdatedBy],
  --[dbo].[PortalRole].[DeletedBy]
 FROM [dbo].[PortalRole]
  LEFT JOIN [dbo].[Aspnet_roles] ON [dbo].[Aspnet_roles].RoleId = [dbo].[PortalRole].RoleID
 WHERE ([dbo].[PortalRole].[PortalID]=@PortalID OR [dbo].[PortalRole].[PortalID]=-1) AND 
   ([dbo].[Aspnet_roles].RoleName<>'Anonymous User' OR @IsAll=1)
   order by [dbo].[aspnet_roles].RoleName 
 ELSE
  SELECT
  [dbo].[PortalRole].[PortalRoleID], 
  [dbo].[PortalRole].[RoleID],
  [dbo].[aspnet_roles].RoleName
    --[dbo].[PortalRole].[PortalID],   --,
  --[dbo].[PortalRole].[IsActive],
  --[dbo].[PortalRole].[IsDeleted],
  --[dbo].[PortalRole].[IsModified],
  --[dbo].[PortalRole].[AddedOn],
  --[dbo].[PortalRole].[UpdatedOn],
  --[dbo].[PortalRole].[DeletedOn],
  --[dbo].[PortalRole].[AddedBy],
  --[dbo].[PortalRole].[UpdatedBy],
  --[dbo].[PortalRole].[DeletedBy]
 FROM [dbo].[PortalRole]
  LEFT JOIN [dbo].[Aspnet_roles] ON [dbo].[Aspnet_roles].RoleId = [dbo].[PortalRole].RoleID
 WHERE ([dbo].[PortalRole].[PortalID]=@PortalID OR [dbo].[PortalRole].[PortalID]=-1) AND 
 [dbo].[Aspnet_roles].RoleId<>@HostRoleId  AND ([dbo].[Aspnet_roles].RoleName<>'Anonymous User' OR @IsAll=1)
 order by [dbo].[aspnet_roles].RoleName
END





GO
