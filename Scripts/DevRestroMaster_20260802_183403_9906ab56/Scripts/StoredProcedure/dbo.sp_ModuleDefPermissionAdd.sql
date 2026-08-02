SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_ModuleDefPermissionAdd] @ModuleDefPermissionID INT = NULL OUTPUT
 ,@ModuleDefID INT
 ,@PortalModuleID INT
 ,@PermissionID INT
 ,@IsActive BIT
 ,@AddedOn DATETIME
 ,@PortalID INT
 ,@AddedBy NVARCHAR(256)
AS
BEGIN
 INSERT INTO dbo.ModuleDefPermission (
  [ModuleDefID]
  ,[PermissionID]
  ,[IsActive]
  ,[AddedOn]
  ,[PortalID]
  ,[AddedBy]
  )
 VALUES (
  @ModuleDefID
  ,@PermissionID
  ,@IsActive
  ,@AddedOn
  ,@PortalID
  ,@AddedBy
  )

 SET @ModuleDefPermissionID = SCOPE_IDENTITY()

 DECLARE @tblRoleIDs TABLE (tRoleID UNIQUEIDENTIFIER)

 INSERT INTO @tblRoleIDs (tRoleID)
 SELECT RoleId
 FROM dbo.aspnet_Roles
 WHERE RoleName = 'site admin'
  OR RoleName = 'super user'

 INSERT INTO dbo.PortalModulePermission (
  [PortalModuleID]
  ,[ModuleDefPermissionID]
  ,[AllowAccess]
  ,[RoleID]
  ,[Username]
  ,[IsActive]
  ,[AddedOn]
  ,[AddedBy]
  )
 SELECT @PortalModuleID
  ,@ModuleDefPermissionID
  ,1
  ,tRoleID
  ,@AddedBy
  ,@IsActive
  ,@AddedOn
  ,@AddedBy
 FROM @tblRoleIDs
END





GO
