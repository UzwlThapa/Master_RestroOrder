SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Template_MenuUpdate] (
 @caption NVARCHAR(MAX)
 ,@htmlContent NVARCHAR(MAX)
 ,@imageIcon NVARCHAR(MAX)
 ,@ismenuActive NVARCHAR(MAX)
 ,@isVisible NVARCHAR(MAX)
 ,@linkType NVARCHAR(MAX)
 ,@linkUrl NVARCHAR(MAX)
 ,@menuLevel NVARCHAR(MAX)
 ,@menuOrder NVARCHAR(MAX)
 ,@pageID NVARCHAR(MAX)
 ,@title NVARCHAR(MAX)
 ,@menuName NVARCHAR(MAX)
 ,@SettingKey NVARCHAR(MAX)
 ,@SettingValue NVARCHAR(MAX)
 ,@portalID INT
 ,@userModuleID INT
 )
AS
BEGIN
 DECLARE @MenuID INT

 INSERT INTO Menu (
  MenuName
  ,MenuType
  ,IsDefault
  ,PortalID
  )
 VALUES (
  @menuName
  ,'1'
  ,0
  ,@portalID
  )

 SET @MenuID = SCOPE_IDENTITY()

 CREATE TABLE #TblMenuItemID (
  RowNum INT IDENTITY(1, 1)
  ,MenuItemID NVARCHAR(100)
  )

 CREATE TABLE #TblCaption (
  RowNum INT IDENTITY(1, 1)
  ,Caption NVARCHAR(100)
  )

 INSERT INTO #TblCaption
 SELECT *
 FROM dbo.Split(@caption, ',')

 CREATE TABLE #TblHtmlContent (
  RowNum INT IDENTITY(1, 1)
  ,HtmlContent NVARCHAR(100)
  )

 INSERT INTO #TblHtmlContent
 SELECT *
 FROM dbo.Split(@htmlContent, ',')

 CREATE TABLE #TblImageIcon (
  RowNum INT IDENTITY(1, 1)
  ,ImageIcon NVARCHAR(100)
  )

 INSERT INTO #TblImageIcon
 SELECT *
 FROM dbo.Split(@imageIcon, ',')

 CREATE TABLE #TblisActive (
  RowNum INT IDENTITY(1, 1)
  ,Active BIT
  )

 INSERT INTO #TblisActive
 SELECT *
 FROM dbo.Split(@ismenuActive, ',')

 CREATE TABLE #TblIsVisible (
  RowNum INT IDENTITY(1, 1)
  ,Visible BIT
  )

 INSERT INTO #TblIsVisible
 SELECT *
 FROM dbo.Split(@isVisible, ',')

 CREATE TABLE #TblLinkType (
  RowNum INT IDENTITY(1, 1)
  ,LinkType NVARCHAR(50)
  )

 INSERT INTO #TblLinkType
 SELECT *
 FROM dbo.Split(@linkType, ',')

 CREATE TABLE #TblLinkUrl (
  RowNum INT IDENTITY(1, 1)
  ,LinkUrl NVARCHAR(200)
  )

 INSERT INTO #TblLinkUrl
 SELECT *
 FROM dbo.Split(@linkUrl, ',')

 CREATE TABLE #TblMenuLevel (
  RowNum INT IDENTITY(1, 1)
  ,MenuLevel NVARCHAR(50)
  )

 INSERT INTO #TblMenuLevel
 SELECT *
 FROM dbo.Split(@menuLevel, ',')

 CREATE TABLE #TblMenuOrder (
  RowNum INT IDENTITY(1, 1)
  ,MenuOrder INT
  )

 INSERT INTO #TblMenuOrder
 SELECT *
 FROM dbo.Split(@menuOrder, ',')

 CREATE TABLE #TblPageID (
  RowNum INT IDENTITY(1, 1)
  ,PageID NVARCHAR(100)
  )

 INSERT INTO #TblPageID
 SELECT *
 FROM dbo.Split(@pageID, ',')

 CREATE TABLE #TblTitle (
  RowNum INT IDENTITY(1, 1)
  ,Title NVARCHAR(100)
  )

 INSERT INTO #TblTitle
 SELECT *
 FROM dbo.Split(@title, ',')

 DECLARE @COUNT INT
  ,@Counter INT

 SET @Counter = (
   SELECT COUNT(*)
   FROM #TblCaption
   )
 SET @COUNT = 1

 WHILE (@COUNT <= @Counter)
 BEGIN
  DECLARE @Caption_ NVARCHAR(200)
  DECLARE @HtmlContent_ NVARCHAR(2000)
  DECLARE @ImageIcon_ NVARCHAR(100)
  DECLARE @IsMenuActive_ BIT
  DECLARE @IsVisible_ BIT
  DECLARE @LinkType_ NVARCHAR(50)
  DECLARE @LinkUrl_ NVARCHAR(200)
  DECLARE @MenuLevel_ NVARCHAR(50)
  DECLARE @MenuOrder_ INT
  DECLARE @PageID_ NVARCHAR(50)
  DECLARE @Title_ NVARCHAR(100)
  DECLARE @MenuITemID_ INT

  SET @Caption_ = (
    SELECT Caption
    FROM #TblCaption
    WHERE RowNum = @COUNT
    )
  SET @HtmlContent_ = (
    SELECT HtmlContent
    FROM #TblHtmlContent
    WHERE RowNum = @COUNT
    )
  SET @ImageIcon_ = (
    SELECT ImageIcon
    FROM #TblImageIcon
    WHERE RowNum = @COUNT
    )
  SET @IsMenuActive_ = (
    SELECT Active
    FROM #TblisActive
    WHERE RowNum = @COUNT
    )
  SET @IsVisible_ = (
    SELECT Visible
    FROM #TblIsVisible
    WHERE RowNum = @COUNT
    )
  SET @LinkType_ = (
    SELECT LinkType
    FROM #TblLinkType
    WHERE RowNum = @COUNT
    )
  SET @LinkUrl_ = (
    SELECT LinkUrl
    FROM #TblLinkUrl
    WHERE RowNum = @COUNT
    )
  SET @MenuLevel_ = (
    SELECT MenuLevel
    FROM #TblMenuLevel
    WHERE RowNum = @COUNT
    )
  SET @MenuOrder_ = (
    SELECT MenuOrder
    FROM #TblMenuOrder
    WHERE RowNum = @COUNT
    )
  SET @PageID_ = (
    SELECT PageID
    FROM #TblPageID
    WHERE RowNum = @COUNT
    )
  SET @Title_ = (
    SELECT Title
    FROM #TblTitle
    WHERE RowNum = @COUNT
    )

  INSERT INTO MenuItem (
   MenuID
   ,Caption
   ,HtmlContent
   ,ImageIcon
   ,IsActive
   ,IsVisible
   ,LinkType
   ,LinkURL
   ,MenuLevel
   ,MenuOrder
   ,PageID
   ,Title
   ,PortalID
   )
  VALUES (
   @MenuID
   ,@Caption_
   ,@HtmlContent_
   ,@ImageIcon_
   ,@IsMenuActive_
   ,@IsVisible_
   ,@LinkType_
   ,@LinkUrl_
   ,@MenuLevel_
   ,@MenuOrder_
   ,@PageID_
   ,@Title_
   ,@portalID
   )

  SET @MenuITemID_ = SCOPE_IDENTITY()

  INSERT INTO #TblMenuItemID
  VALUES (@MenuITemID_)

  SET @COUNT = @COUNT + 1
 END

 CREATE TABLE #TblSettingKey (
  RowNum INT IDENTITY(1, 1)
  ,SettingKey NVARCHAR(256)
  )

 INSERT INTO #TblSettingKey
 SELECT *
 FROM dbo.Split(@SettingKey, ',')

 CREATE TABLE #TblSettingValue (
  RowNum INT IDENTITY(1, 1)
  ,SettingValue NVARCHAR(256)
  )

 INSERT INTO #TblSettingValue
 SELECT *
 FROM dbo.Split(@SettingValue, ',')

 DECLARE @Count2 INT
  ,@Counter2 INT

 SET @Counter2 = (
   SELECT COUNT(*)
   FROM #TblSettingKey
   )
 SET @Count2 = 1

 WHILE (@Count2 <= @Counter2)
 BEGIN
  DECLARE @SettingKey_ NVARCHAR(256)
  DECLARE @SettingValue_ NVARCHAR(256)

  SET @SettingKey_ = (
    SELECT SettingKey
    FROM #TblSettingKey
    WHERE RowNum = @Count2
    )
  SET @SettingValue_ = (
    SELECT SettingValue
    FROM #TblSettingValue
    WHERE RowNum = @Count2
    )

  INSERT INTO MenuMgrSettingValue (
   MenuID
   ,SettingKey
   ,SettingValue
   ,PortalID
   )
  VALUES (
   @MenuID
   ,@SettingKey_
   ,@SettingValue_
   ,@portalID
   )

  SET @Count2 = @Count2 + 1
 END

 INSERT INTO SageMenuSettingValue (
  UserModuleID
  ,SettingKey
  ,SettingValue
  ,PortalID
  )
 VALUES (
  @userModuleID
  ,'MenuID'
  ,@MenuID
  ,@portalID
  )

 SELECT MenuItemID
 FROM #TblMenuItemID

 DROP TABLE #TblMenuItemID

 DROP TABLE #TblCaption

 DROP TABLE #TblHtmlContent

 DROP TABLE #TblImageIcon

 DROP TABLE #TblisActive

 DROP TABLE #TblIsVisible

 DROP TABLE #TblLinkType

 DROP TABLE #TblLinkUrl

 DROP TABLE #TblMenuLevel

 DROP TABLE #TblMenuOrder

 DROP TABLE #TblTitle

 DROP TABLE #TblPageID

 DROP TABLE #TblSettingKey

 DROP TABLE #TblSettingValue
END





GO
