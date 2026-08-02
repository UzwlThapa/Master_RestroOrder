SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UserModulesPermissionAdd] 
(@ModuleDefID INT,
 @UserModuleID INT,
 @AllowAccess BIT,
 @RoleID NVARCHAR (100) = NULL,
 @UserName NVARCHAR (256) = NULL,
 @IsActive BIT,
 @AddedOn DATETIME,
 @PortalID INT,
 @AddedBy NVARCHAR (256),
 @PermissionID INT) AS
BEGIN
 DECLARE
  @ModuleDefPermissionID INT SELECT
   @ModuleDefPermissionID = ModuleDefPermissionID
  FROM
   ModuleDefPermission
  WHERE
   ModuleDefID =@ModuleDefID
  AND PermissionID =@PermissionID INSERT INTO dbo.UserModulePermission (
   [UserModuleID],
   [ModuleDefPermissionID],
   [AllowAccess],
   [RoleID],
   [Username],
   [IsActive],
   [AddedOn],
   [PortalID],
   [AddedBy]
  )
  VALUES
   (
    @UserModuleID,
    @ModuleDefPermissionID,
    @AllowAccess,
    @RoleID,
    @UserName,
    @IsActive,
    @AddedOn,
    @PortalID,
    @AddedBy
   )
  END





GO
