SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SortPages] 
(@PageID INT,
 @ParentID INT,
 @PageName NVARCHAR (200),
 @BeforeID INT,
 @AfterID INT,
 @PortalID INT,
 @AddedBy NVARCHAR (100)) AS
BEGIN

IF (
 EXISTS (
  SELECT
   *
  FROM
   [dbo].[Pages]
  WHERE
   PageID =@PageID
 )
)
BEGIN
 DECLARE
  @ParentLevel INT,
  @ParentTabPath NVARCHAR (4000) ,@PageOrder INT ,@PageSEOName NVARCHAR (1000) ,@OldParentID INT ,@OldPageOrder INT DECLARE
   @NewTabPath NVARCHAR (4000),
   @NewParentLevel INT SELECT
    @ParentLevel = [Level] ,@ParentTabPath = ISNULL(TabPath, '')
   FROM
    Pages
   WHERE
    PageID =@ParentID SELECT
     @NewTabPath = TabPath
    FROM
     Pages
    WHERE
     PageID =@PageID
    SET @PageSEOName = REPLACE(@PageName, ' ', '-') SELECT
     @OldParentID = ParentID ,@OldPageOrder = PageOrder
    FROM
     [dbo].[Pages]
    WHERE
     PageID =@PageID
    IF @OldParentID <> @ParentID
    BEGIN

    SET @NewParentLevel = ISNULL(@ParentLevel ,- 1) + 1
    SET @NewTabPath = ISNULL(@ParentTabPath, '') + '/' +@PageSEOName EXECUTE [dbo].[sp_UpdateChildLevelTabPath] @PageID ,@NewParentLevel ,@NewTabPath ,@AddedBy ,@PortalID UPDATE Pages
    SET PageOrder = PageOrder - 1
    WHERE
     PageOrder >@OldPageOrder
    AND PortalID =@PortalID
    AND ParentID =@OldParentID
    AND (
     IsDeleted = 0
     OR IsDeleted IS NULL
    )
    END DECLARE
     @CurrentSortValue INT SELECT
      @CurrentSortValue = [PageOrder]
     FROM
      dbo.Pages
     WHERE
      [PageID] =@PageID
     AND ParentID =@ParentID
     AND (
      PortalID =@PortalID
      OR PortalID =- 1
     )
     AND (
      IsDeleted = 0
      OR IsDeleted IS NULL
     )
     IF (@BeforeID > 0)
     BEGIN
      UPDATE Pages
     SET PageOrder = PageOrder - 1
     WHERE
      PageOrder >@CurrentSortValue
     AND PortalID =@PortalID
     AND (
      PortalID =@PortalID
      OR PortalID =- 1
     )
     AND (
      IsDeleted = 0
      OR IsDeleted IS NULL
     ) SELECT
      @PageOrder = [PageOrder]
     FROM
      Pages
     WHERE
      PageID =@BeforeID
     AND ParentID =@ParentID
     AND (
      PortalID =@PortalID
      OR PortalID =- 1
     )
     AND (
      IsDeleted = 0
      OR IsDeleted IS NULL
     ) UPDATE Pages
     SET PageOrder = PageOrder + 1
     WHERE
      PageOrder >=@PageOrder
     AND PortalID =@PortalID
     AND (
      PortalID =@PortalID
      OR PortalID =- 1
     )
     AND (
      IsDeleted = 0
      OR IsDeleted IS NULL
     )
     END
     ELSE

     IF (@AfterID > 0)
     BEGIN
      UPDATE Pages
     SET PageOrder = PageOrder - 1
     WHERE
      PageOrder >@CurrentSortValue
     AND PortalID =@PortalID
     AND ParentID =@ParentID
     AND (
      IsDeleted = 0
      OR IsDeleted IS NULL
     ) SELECT
      @PageOrder = [PageOrder]
     FROM
      Pages
     WHERE
      PageID =@AfterID
     AND ParentID =@ParentID
     AND PortalID =@PortalID
     AND (
      IsDeleted = 0
      OR IsDeleted IS NULL
     ) UPDATE Pages
     SET PageOrder = PageOrder + 1
     WHERE
      PageOrder >@PageOrder
     AND PortalID =@PortalID
     AND ParentID =@ParentID
     AND (
      IsDeleted = 0
      OR IsDeleted IS NULL
     )
     SET @PageOrder =@PageOrder + 1
     END
     ELSE

     BEGIN

     SET @PageOrder =@CurrentSortValue
     END UPDATE [dbo].[Pages]
     SET [PageOrder] = ISNULL(@PageOrder, 1),
     [ParentID] = @ParentID,
     [Level] = ISNULL(@ParentLevel ,- 1) + 1,
     [TabPath] = @NewTabPath,
     [IsModified] = 1,
     [UpdatedOn] = GetDate(),
     [PortalID] = @PortalID,
     [UpdatedBy] = @AddedBy
    WHERE
     PortalID =@PortalID
    AND PageID =@PageID
    END
    END





GO
