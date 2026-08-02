SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_ModulesPermissionAdd]
 @ModuleDefPermissionID int=NULL output,
 @PortalModulePermissionID int output,
 @ModuleDefID int,
 @PermissionID int,
 @PortalID int, 
 @PortalModuleID int,
 @AllowAccess bit,
 @UserName nvarchar(256),
 @IsActive bit,
 @AddedOn datetime,
 @AddedBy nvarchar(256)
 
AS

SET @PortalID=1

BEGIN
 INSERT INTO dbo.ModuleDefPermission (
 [ModuleDefID],
 [PermissionID],
 [IsActive],
 [AddedOn],
 [PortalID],
 [AddedBy]
) VALUES (
 @ModuleDefID,
 @PermissionID,
 @IsActive,
 @AddedOn,
 @PortalID,
 @AddedBy
)
SET @ModuleDefPermissionID = SCOPE_IDENTITY()

DECLARE @tblRoleIDs table (tRoleID uniqueidentifier)
INSERT INTO @tblRoleIDs (tRoleID)
SELECT RoleId
FROM dbo.aspnet_Roles 
WHERE RoleName='site admin' or RoleName = 'super user' 


INSERT INTO dbo.PortalModulePermission(
 [PortalModuleID],
 [ModuleDefPermissionID],
 [AllowAccess],
 [RoleID],
 [Username],
 [IsActive],
 [AddedOn],
 [AddedBy]) 
SELECT 
 @PortalModuleID,
 @ModuleDefPermissionID,
 @AllowAccess,
 tRoleID,
 @UserName,
 @IsActive,
 @AddedOn,
 @AddedBy
FROM @tblRoleIDs
END





GO
