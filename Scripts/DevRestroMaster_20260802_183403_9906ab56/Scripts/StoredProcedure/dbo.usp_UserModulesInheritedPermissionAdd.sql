SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UserModulesInheritedPermissionAdd] (
 @ModuleDefID INT
 ,@UserModuleID INT
 ,@AllowAccess BIT
 ,@IsActive BIT
 ,@AddedOn DATETIME
 ,@PortalID INT
 ,@AddedBy NVARCHAR(256)
 ,@PageID INT
 )
AS
BEGIN
 DELETE
 FROM UserModulePermission
 WHERE UserModuleID = @UserModuleID

 CREATE TABLE #TablePermission (
  [UserModuleID] INT
  ,[ModuleDefPermissionID] INT
  ,[AllowAccess] BIT
  ,[RoleID] NVARCHAR(250)
  ,[Username] NVARCHAR(250)
  ,[IsActive] BIT
  ,[AddedOn] DATETIME
  ,[PortalID] INT
  ,[AddedBy] NVARCHAR(250)
  ,[PermissionID] INT
  )

 INSERT INTO #TablePermission
 SELECT @UserModuleID
  ,(
   SELECT ModuleDefPermissionID
   FROM ModuleDefPermission m
   WHERE m.ModuleDefID = @ModuleDefID
    AND m.PermissionID = pp.PermissionID
   ) AS ModuleDefPermissionID
  ,@AllowAccess
  ,[RoleID]
  ,[Username]
  ,@IsActive
  ,@AddedOn
  ,@PortalID
  ,@AddedBy
  ,pp.[PermissionID]
 FROM PagePermission pp
 WHERE pp.PageID = @PageID

 INSERT INTO dbo.UserModulePermission (
  [UserModuleID]
  ,[ModuleDefPermissionID]
  ,[AllowAccess]
  ,[RoleID]
  ,[Username]
  ,[IsActive]
  ,[AddedOn]
  ,[PortalID]
  ,[AddedBy]
  )
 SELECT [UserModuleID]
  ,[ModuleDefPermissionID]
  ,[AllowAccess]
  ,[RoleID]
  ,[Username]
  ,[IsActive]
  ,[AddedOn]
  ,1
  ,[AddedBy]
 FROM #TablePermission

 DROP TABLE #TablePermission
END





GO
