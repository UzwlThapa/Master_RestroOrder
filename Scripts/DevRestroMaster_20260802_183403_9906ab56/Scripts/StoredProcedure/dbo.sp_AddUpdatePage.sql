SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_AddUpdatePage] @PageID INT
 ,@PageOrder INT
 ,@PageName NVARCHAR(1000)
 ,@IsVisible BIT
 ,@ParentID INT
 ,@IconFile NVARCHAR(500)
 ,@DisableLink BIT
 ,@Title NVARCHAR(200)
 ,@Description NVARCHAR(500)
 ,@KeyWords NVARCHAR(500)
 ,@Url NVARCHAR(255)
 ,@StartDate NVARCHAR(50)
 ,@EndDate NVARCHAR(50)
 ,@RefreshInterval DECIMAL(16, 2)
 ,@PageHeadText NVARCHAR(500)
 ,@IsSecure BIT
 ,@IsActive BIT
 ,@IsShowInFooter BIT
 ,@IsRequiredPage BIT
 ,@BeforeID INT
 ,@AfterID INT
 ,@PortalID INT
 ,@AddedBy NVARCHAR(256)
 ,@IsAdmin BIT
 ,@InsertedPageID INT OUTPUT
AS
BEGIN
 DECLARE @ParentLevel INT
  ,@ParentTabPath NVARCHAR(4000)
  ,@PageSEOName NVARCHAR(1000)
SELECT @StartDate = CONVERT(DATETIME, @StartDate ,103) ,@EndDate= CONVERT(DATETIME, @EndDate ,103)
 IF @Title = ''
  SET @Title = CONVERT(NVARCHAR(200), [dbo].[Fn_getsettingvaluebysettingkey]('SiteAdmin', @PortalID, 'PageTitle'))

 IF @Description = ''
  SET @Description = CONVERT(NVARCHAR(500), [dbo].[Fn_getsettingvaluebysettingkey]('SiteAdmin', @PortalID, 'MetaDescription'))

 DECLARE @newPortalID INT

 SET @newPortalID = @portalID

 IF @IsAdmin = 1
 BEGIN
  SET @newPortalID = - 1
 END

 IF @KeyWords = ''
  SET @KeyWords = CONVERT(NVARCHAR(500), [dbo].[Fn_getsettingvaluebysettingkey]('SiteAdmin', @PortalID, 'MetaKeywords'))

 SELECT @ParentLevel = [level]
  ,@ParentTabPath = ISNULL(tabpath, '')
 FROM pages
 WHERE pageid = @ParentID

 SELECT @PageOrder = Max(pageorder) + 1
 FROM pages p
 INNER JOIN pagemenu pm ON p.pageid = pm.pageid
 WHERE pm.isadmin = @isadmin

 SET @PageSEOName = Replace(@PageName, ' ', '-')

 IF @PageID = 0
 BEGIN
  INSERT INTO [dbo].[pages] (
   [pageorder]
   ,[pagename]
   ,[isvisible]
   ,[parentid]
   ,[level]
   ,[iconfile]
   ,[disablelink]
   ,[title]
   ,[description]
   ,[keywords]
   ,[url]
   ,[tabpath]
   ,[startdate]
   ,[enddate]
   ,[refreshinterval]
   ,[pageheadtext]
   ,[issecure]
   ,[isactive]
   ,[addedon]
   ,[portalid]
   ,[addedby]
   ,[seoname]
   ,[isshowinfooter]
   ,[isrequiredpage]
   )
  VALUES (
   ISNULL(@PageOrder, 1)
   ,@PageName
   ,@IsVisible
   ,@ParentID
   ,ISNULL(@ParentLevel, - 1) + 1
   ,@IconFile
   ,@DisableLink
   ,@Title
   ,@Description
   ,@KeyWords
   ,@Url
   ,ISNULL(@ParentTabPath, '') + '/' + @PageSEOName
   ,@StartDate
   ,@EndDate
   ,@RefreshInterval
   ,@PageHeadText
   ,@IsSecure
   ,@IsActive
   ,GETDATE()
   ,@newPortalID
   ,@AddedBy
   ,@PageSEOName
   ,@IsShowInFooter
   ,@IsRequiredPage
   )

  SET @InsertedPageID = @@IDENTITY

  EXECUTE [dbo].[Usp_addupdatepagemenu] @InsertedPageID
   ,@PortalID
   ,@IsAdmin
   ,@IsShowInFooter

  SET @PageID = Scope_identity()

  DECLARE @Date DATETIME

  SET @Date = GETDATE()

  INSERT INTO PagePreview (
   PageID
   ,PreviewCode
   )
  VALUES (
   @PageID
   ,convert(NVARCHAR(256), NEWID())
   )
 END
 ELSE
 BEGIN
  IF (
    EXISTS (
     SELECT *
     FROM [dbo].[pages]
     WHERE pageid = @PageID
     )
    )
  BEGIN
   EXECUTE [dbo].[Usp_addupdatepagemenu] @PageID
    ,@PortalID
    ,@IsAdmin
    ,@IsShowInFooter

   DECLARE @oldParentID INT
    ,@oldPageOrder INT

   SELECT @oldParentID = parentid
    ,@oldPageOrder = pageorder
   FROM [dbo].[pages]
   WHERE pageid = @PageID

   IF @oldParentID <> @ParentID
   BEGIN
    DECLARE @NewTabPath NVARCHAR(4000)
     ,@NewParentLevel INT

    SET @NewParentLevel = ISNULL(@ParentLevel, - 1) + 1
    SET @NewTabPath = ISNULL(@ParentTabPath, '') + '/' + @PageSEOName

    EXECUTE [dbo].[Sp_updatechildleveltabpath] @PageID
     ,@NewParentLevel
     ,@NewTabPath
     ,@AddedBy
     ,@PortalID

    UPDATE pages
    SET pageorder = pageorder - 1
    WHERE pageorder > @oldPageOrder
     AND portalid = @PortalID
     AND parentid = @oldParentID
     AND (
      isdeleted = 0
      OR isdeleted IS NULL
      )
   END

   DECLARE @CurrentSortValue INT

   SELECT @CurrentSortValue = [pageorder]
   FROM dbo.pages
   WHERE [pageid] = @PageID
    AND parentid = @ParentID
    AND portalid = @PortalID
    AND (
     isdeleted = 0
     OR isdeleted IS NULL
     )

   IF (@BeforeID > 0)
   BEGIN
    UPDATE pages
    SET pageorder = pageorder - 1
    WHERE pageorder > @CurrentSortValue
     AND portalid = @PortalID
     AND parentid = @ParentID
     AND (
      isdeleted = 0
      OR isdeleted IS NULL
      )

    SELECT @PageOrder = [pageorder]
    FROM pages
    WHERE pageid = @BeforeID
     AND parentid = @ParentID
     AND portalid = @PortalID
     AND (
      isdeleted = 0
      OR isdeleted IS NULL
      )

    UPDATE pages
    SET pageorder = pageorder + 1
    WHERE pageorder >= @PageOrder
     AND portalid = @PortalID
     AND parentid = @ParentID
     AND (
      isdeleted = 0
      OR isdeleted IS NULL
      )
   END
   ELSE
    IF (@AfterID > 0)
    BEGIN
     UPDATE pages
     SET pageorder = pageorder - 1
     WHERE pageorder > @CurrentSortValue
      AND portalid = @PortalID
      AND parentid = @ParentID
      AND (
       isdeleted = 0
       OR isdeleted IS NULL
       )

     SELECT @PageOrder = [pageorder]
     FROM pages
     WHERE pageid = @AfterID
      AND parentid = @ParentID
      AND portalid = @PortalID
      AND (
       isdeleted = 0
       OR isdeleted IS NULL
       )

     UPDATE pages
     SET pageorder = pageorder + 1
     WHERE pageorder > @PageOrder
      AND portalid = @PortalID
      AND parentid = @ParentID
      AND (
       isdeleted = 0
       OR isdeleted IS NULL
       )

     SET @PageOrder = @PageOrder + 1
    END
    ELSE
    BEGIN
     SET @PageOrder = @CurrentSortValue
    END

   BEGIN
    DECLARE @OldPortalID INT

    SELECT @OldPortalID = portalid
    FROM [dbo].[pages]
    WHERE (
      portalid = @PortalID
      OR portalid = - 1
      )
     AND pageid = @PageID

    IF (@OldPortalID = - 1)
    BEGIN
     SET @PortalID = @OldPortalID
    END
    ELSE
    BEGIN
     SET @PortalID = @PortalID
    END

    UPDATE [dbo].[pages]
    SET [pageorder] = ISNULL(@PageOrder, 1)
     ,[pagename] = @PageName
     ,[isvisible] = @IsVisible
     ,[parentid] = @ParentID
     ,[level] = ISNULL(@ParentLevel, - 1) + 1
     ,[iconfile] = @IconFile
     ,[disablelink] = @DisableLink
     ,[title] = @Title
     ,[description] = @Description
     ,[keywords] = @KeyWords
     ,[url] = @Url
     ,[tabpath] = ISNULL(@ParentTabPath, '') + '/' + @PageSEOName
     ,[startdate] = @StartDate
     ,[enddate] = @EndDate
     ,[refreshinterval] = @RefreshInterval
     ,[pageheadtext] = @PageHeadText
     ,[issecure] = @IsSecure
     ,[isactive] = @IsActive
     ,[ismodified] = 1
     ,[updatedon] = GETDATE()
     ,[portalid] = @PortalID
     ,[updatedby] = @AddedBy
     ,[seoname] = @PageSEOName
     ,[isshowinfooter] = @IsShowInFooter
    WHERE (
      portalid = @PortalID
      OR portalid = - 1
      )
     AND pageid = @PageID

    SET @InsertedPageID = @PageID

    UPDATE [dbo].[localpage]
    SET localpagename = @PageName
    WHERE pageid = @PageID
     AND culturecode = 'en-US'

    DECLARE @UpdatedOn DATETIME

    SET @UpdatedOn = GETDATE()
   END
  END
 END
END





GO
