SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Template_InsertModule] (
 @pageID INT
 ,@ModuleName VARCHAR(100)
 ,@FriendlyName VARCHAR(100)
 ,@userModuleTitle VARCHAR(100)
 ,@paneName NVARCHAR(100)
 ,@allowAcess NVARCHAR(MAX)
 ,@roleName NVARCHAR(MAX)
 ,@permissionID NVARCHAR(MAX)
 ,@portalID INT
 ,@allPages BIT
 ,@inheritViewPermissions BIT
 ,@header NVARCHAR(MAX)
 ,@footer NVARCHAR(MAX)
 ,@isActive BIT
 ,@seoName NVARCHAR(100)
 ,@ShowInPages NVARCHAR(256)
 ,@IsHandheld BIT
 ,@suffixClass NVARCHAR(MAX)
 ,@headerText NVARCHAR(500)
 ,@showHeaderText BIT
 ,@isInAdmin BIT
 ,@Query NVARCHAR(MAX)
 ,@LEVEL INT
 )
AS
BEGIN
 DECLARE @Test VARCHAR(MAX)
 DECLARE @ModuleID INT
 DECLARE @ModuleDefID INT
 DECLARE @UserModuleID INT

 SET @UserModuleID = 0

 DECLARE @PageModuleID INT
 DECLARE @UmId NCHAR(10)

 CREATE TABLE #TableAccessName (
  ROWNO INT IDENTITY(1, 1)
  ,AllowAcess NVARCHAR(50)
  )

 INSERT INTO #TableAccessName
 SELECT *
 FROM dbo.Split(@allowAcess, ',')

 CREATE TABLE #TableRoleName (
  ROWNO INT IDENTITY(1, 1)
  ,RoleName NVARCHAR(50)
  )

 INSERT INTO #TableRoleName
 SELECT *
 FROM dbo.Split(@roleName, ',')

 CREATE TABLE #tblpermissionID (
  ROWNO INT IDENTITY(1, 1)
  ,PermissionID NVARCHAR(50)
  )

 INSERT INTO #tblpermissionID
 SELECT *
 FROM dbo.Split(@permissionID, ',')

 IF (
   EXISTS (
    SELECT m.ModuleID
    FROM Modules m
    INNER JOIN ModuleDefinitions md ON m.ModuleID = md.ModuleID
    INNER JOIN PortalModules pm ON md.ModuleID = pm.ModuleID
    WHERE (
      m.IsAdmin = 0
      OR m.IsAdmin IS NULL
      )
     AND (
      m.IsDeleted IS NULL
      OR m.IsDeleted = 0
      )
     AND pm.PortalID = @PortalID
     AND pm.IsActive = 1
     AND m.FriendlyName = @FriendlyName
    )
   )
 BEGIN
  SET @ModuleID = (
    SELECT m.ModuleID
    FROM Modules m
    INNER JOIN ModuleDefinitions md ON m.ModuleID = md.ModuleID
    INNER JOIN PortalModules pm ON md.ModuleID = pm.ModuleID
    WHERE (
      m.IsAdmin = 0
      OR m.IsAdmin IS NULL
      )
     AND (
      m.IsDeleted IS NULL
      OR m.IsDeleted = 0
      )
     AND pm.PortalID = @PortalID
     AND pm.IsActive = 1
     AND m.FriendlyName = @FriendlyName
    )
  SET @ModuleDefID = (
    SELECT ModuleDefID
    FROM ModuleDefinitions
    WHERE ModuleID = @ModuleID
    )

  INSERT INTO UserModules (
   [ModuleDefID]
   ,[UserModuleTitle]
   ,[AllPages]
   ,[InheritViewPermissions]
   ,[Header]
   ,[Footer]
   ,[IsActive]
   ,[PortalID]
   ,[SEOName]
   ,[ShowInPages]
   ,[IsHandheld]
   ,[SuffixClass]
   ,[HeaderText]
   ,[ShowHeaderText]
   ,[IsInAdmin]
   )
  VALUES (
   @ModuleDefID
   ,@userModuleTitle
   ,@allPages
   ,@inheritViewPermissions
   ,@header
   ,@footer
   ,@isActive
   ,@portalID
   ,@seoName
   ,@ShowInPages
   ,@IsHandheld
   ,@suffixClass
   ,@headerText
   ,@showHeaderText
   ,@isInAdmin
   )

  SET @UserModuleID = SCOPE_IDENTITY()

  INSERT INTO PageModules (
   PageID
   ,UserModuleID
   ,PaneName
   )
  VALUES (
   @pageID
   ,@UserModuleID
   ,@paneName
   )

  SET @PageModuleID = SCOPE_IDENTITY()

  DECLARE @Counter INT
  DECLARE @COUNT INT

  SET @Counter = (
    SELECT MAX(ROWNO)
    FROM #TableAccessName
    )
  SET @COUNT = 1

  WHILE (@COUNT <= @Counter)
  BEGIN
   DECLARE @AllowAcess_ INT
   DECLARE @RoleName_ VARCHAR(100)
   DECLARE @PermissionID_ INT

   SET @AllowAcess_ = (
     SELECT AllowAcess
     FROM #TableAccessName
     WHERE ROWNO = @COUNT
     )
   SET @RoleName_ = (
     SELECT RoleName
     FROM #TableRoleName
     WHERE ROWNO = @COUNT
     )
   SET @PermissionID_ = (
     SELECT PermissionID
     FROM #tblpermissionID
     WHERE ROWNO = @COUNT
     )

   DECLARE @ModuleDefPermissionID INT
   DECLARE @RoleID VARCHAR(100)

   IF (
     EXISTS (
      SELECT ModuleDefPermissionID
      FROM ModuleDefPermission
      WHERE ModuleDefID = @ModuleDefID
       AND PermissionID = @PermissionID_
      )
     )
   BEGIN
    SET @ModuleDefPermissionID = (
      SELECT ModuleDefPermissionID
      FROM ModuleDefPermission
      WHERE ModuleDefID = @ModuleDefID
       AND PermissionID = @PermissionID_
      )
   END
   ELSE
   BEGIN
    INSERT INTO ModuleDefPermission (
     ModuleDefID
     ,PermissionID
     )
    VALUES (
     @ModuleDefID
     ,@PermissionID_
     )

    SET @ModuleDefPermissionID = SCOPE_IDENTITY()
   END

   SET @RoleID = (
     SELECT RoleId
     FROM aspnet_Roles
     WHERE RoleName = @RoleName_
     )

   INSERT INTO UserModulePermission (
    UserModuleID
    ,ModuleDefPermissionID
    ,RoleID
    ,AllowAccess
    ,PortalID
    )
   VALUES (
    @UserModuleID
    ,@ModuleDefPermissionID
    ,@RoleID
    ,@AllowAcess_
    ,@portalID
    )

   SET @COUNT = @COUNT + 1
  END

  IF (@LEVEL = 1)
  BEGIN
   SET @Query = (
     SELECT Replace(@Query, '##usermoduleID', @UserModuleID)
     )

   EXEC (@Query)
  END
  ELSE
  BEGIN
   SET @Query = (
     SELECT Replace(@Query, '##UserModuleID', @UserModuleID)
     )

   CREATE TABLE #TableQuery (
    RowNum INT IDENTITY(1, 1)
    ,Query NVARCHAR(MAX)
    )

   INSERT INTO #TableQuery
   SELECT *
   FROM dbo.Split(@Query, '^')

   DECLARE @Count1 INT
    ,@Counter1 INT

   SET @Counter1 = (
     SELECT COUNT(*)
     FROM #TableQuery
     )
   SET @Count1 = 1

   DECLARE @Count2 INT
    ,@Counter2 INT

   SET @Count2 = 1

   WHILE (@Count1 <= @Counter1)
   BEGIN
    DECLARE @SingleQuery NVARCHAR(MAX)

    SET @SingleQuery = (
      SELECT Query
      FROM #TableQuery
      WHERE RowNum = @Count1
      )

    IF (@SingleQuery IS NOT NULL)
    BEGIN
     CREATE TABLE #TableSmallQuery (
      Row INT IDENTITY(1, 1)
      ,SmallQuery NVARCHAR(MAX)
      )

     INSERT INTO #TableSmallQuery
     SELECT *
     FROM dbo.Split(@SingleQuery, '!')

     DECLARE @BannerID INT

     SET @Counter2 = (
       SELECT COUNT(*)
       FROM #TableSmallQuery
       ) + @Count2 - 1

     DECLARE @FIRST INT

     SET @FIRST = 1

     WHILE (@Count2 <= @Counter2)
     BEGIN
      DECLARE @SmallQuery NVARCHAR(MAX)

      SET @SmallQuery = (
        SELECT SmallQuery
        FROM #TableSmallQuery
        WHERE Row = @Count2
        )

      IF (@FIRST = 1)
      BEGIN
       CREATE TABLE #TableTemp (i INT)

       INSERT #TableTemp
       EXEC (N' SET NOCOUNT ON ' + @SmallQuery)

       IF (
         (
          SELECT TOP (1) *
          FROM #TableTemp
          ) <> 0
         )
        SET @BannerID = (
          SELECT TOP (1) *
          FROM #TableTemp
          )

       DELETE
       FROM #TableTemp

       DROP TABLE #TableTemp
      END
      ELSE
      BEGIN
       SET @SmallQuery = (
         SELECT Replace(@SmallQuery, '@tempID', @BannerID)
         )

       EXEC (N' SET NOCOUNT ON ' + @SmallQuery)
      END

      SET @Count2 = @Count2 + 1
      SET @FIRST = @FIRST + 1
     END

     DELETE
     FROM #TableSmallQuery
    END

    DROP TABLE #TableSmallQuery

    SET @Count1 = @Count1 + 1
   END

   DROP TABLE #TableQuery
  END
 END

 DROP TABLE #TableAccessName

 DROP TABLE #TableRoleName

 DROP TABLE #tblpermissionID

 SELECT @UserModuleID AS UserModuleId
END





GO
