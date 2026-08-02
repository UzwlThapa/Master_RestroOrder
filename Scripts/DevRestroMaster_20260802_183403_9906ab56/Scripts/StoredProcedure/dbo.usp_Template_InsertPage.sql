SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Template_InsertPage] (
 @pageName VARCHAR(50)
 ,@pageOrder INT
 ,@isVisible BIT
 ,@LEVEL INT
 ,@portalID INT
 ,@disableLink BIT
 ,@isSecure BIT
 ,@isActive BIT
 ,@isShowInFooter BIT
 ,@isRequiredPage BIT
 ,@iconfile VARCHAR(100)
 ,@pageHeadText VARCHAR(100)
 ,@description VARCHAR(100)
 ,@keyWords VARCHAR(100)
 ,@url VARCHAR(100)
 ,@tabPath VARCHAR(100)
 ,@seoName VARCHAR(100)
 ,@refreshInterval DECIMAL(6, 2)
 ,@title VARCHAR(100)
 ,@allowAcess NVARCHAR(MAX)
 ,@roleName NVARCHAR(MAX)
 ,@permissionID NVARCHAR(MAX)
 ,@isPermisssionActive NVARCHAR(MAX)
 )
AS
BEGIN
 DECLARE @PageID AS INT

 IF (
   EXISTS (
    SELECT PageID
    FROM Pages
    WHERE PageName = @pageName
     AND IsDeleted = 0
    )
   )
 BEGIN
  SET @PageID = (
    SELECT PageID
    FROM Pages
    WHERE PageName = @pageName
     AND IsDeleted = 0
    )
 END
 ELSE
 BEGIN
  INSERT INTO Pages (
   [PageOrder]
   ,[PageName]
   ,[IsVisible]
   ,[ParentID]
   ,[Level]
   ,[IconFile]
   ,[DisableLink]
   ,[Title]
   ,[Description]
   ,[KeyWords]
   ,[Url]
   ,[TabPath]
   ,[RefreshInterval]
   ,[PageHeadText]
   ,[IsSecure]
   ,[IsActive]
   ,[PortalID]
   ,[SEOName]
   ,[IsShowInFooter]
   ,[IsRequiredPage]
   )
  VALUES (
   @pageOrder
   ,@pageName
   ,@isVisible
   ,0
   ,@LEVEL
   ,@iconfile
   ,@disableLink
   ,@title
   ,@description
   ,@keyWords
   ,@url
   ,@tabPath
   ,@refreshInterval
   ,@pageHeadText
   ,@isSecure
   ,@isActive
   ,@portalID
   ,@seoName
   ,@isShowInFooter
   ,@isRequiredPage
   )

  SET @PageID = Scope_Identity()

  INSERT INTO PageMenu (
   PageID
   ,IsAdmin
   ,ShowInMenu
   ,PortalID
   )
  VALUES (
   @PageID
   ,0
   ,1
   ,@portalID
   )
 END

 CREATE TABLE #TableAllowAcess (
  ROWNO INT IDENTITY(1, 1)
  ,AllowAcess NVARCHAR(50)
  )

 INSERT INTO #TableAllowAcess
 SELECT *
 FROM dbo.Split(@allowAcess, ',')

 CREATE TABLE #TableRoleName (
  ROWNO INT IDENTITY(1, 1)
  ,RoleName NVARCHAR(50)
  )

 INSERT INTO #TableRoleName
 SELECT *
 FROM dbo.Split(@roleName, ',')

 CREATE TABLE #TablePermissionID (
  ROWNO INT IDENTITY(1, 1)
  ,PermissionID NVARCHAR(50)
  )

 INSERT INTO #TablePermissionID
 SELECT *
 FROM dbo.Split(@permissionID, ',')

 CREATE TABLE #TablePermissionIsActive (
  ROWNO INT IDENTITY(1, 1)
  ,IsPermissionActive NVARCHAR(50)
  )

 INSERT INTO #TablePermissionIsActive
 SELECT *
 FROM dbo.Split(@isPermisssionActive, ',')

 DECLARE @Counter INT
 DECLARE @COUNT INT

 SET @Counter = (
   SELECT MAX(ROWNO)
   FROM #TableAllowAcess
   )
 SET @COUNT = 1

 WHILE (@COUNT <= @Counter)
 BEGIN
  DECLARE @RoleName_ NVARCHAR(256)
  DECLARE @AllowAcess_ BIT
  DECLARE @PermissionID_ INT
  DECLARE @IsPermisssionActive_ BIT

  SET @RoleName_ = (
    SELECT roleName
    FROM #TableRoleName
    WHERE ROWNO = @COUNT
    )
  SET @AllowAcess_ = (
    SELECT AllowAcess
    FROM #TableAllowAcess
    WHERE ROWNO = @COUNT
    )
  SET @PermissionID_ = (
    SELECT PermissionID
    FROM #TablePermissionID
    WHERE ROWNO = @COUNT
    )
  SET @IsPermisssionActive_ = (
    SELECT IsPermissionActive
    FROM #TablePermissionIsActive
    WHERE ROWNO = @COUNT
    )

  DECLARE @RoleId VARCHAR(64)

  SET @RoleId = (
    SELECT a.RoleId
    FROM aspnet_Roles AS a
    WHERE a.RoleName = @RoleName_
    )

  INSERT INTO PagePermission (
   PageID
   ,PermissionID
   ,AllowAccess
   ,IsActive
   ,RoleID
   )
  VALUES (
   @PageID
   ,@PermissionID_
   ,@AllowAcess_
   ,@IsPermisssionActive_
   ,@RoleId
   )

  SET @COUNT = @COUNT + 1
 END

 SELECT @PageID AS PageID

 DROP TABLE #TableAllowAcess

 DROP TABLE #TableRoleName

 DROP TABLE #TablePermissionIsActive

 DROP TABLE #TablePermissionID
END





GO
