SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-----------------
--[dbo].[sp_HtmlContentSearch] 'You can create','superuser',1,'en-US',1
CREATE PROCEDURE [dbo].[sp_HtmlContentSearch] @Searchword NVARCHAR(500)
 ,@SearchBy NVARCHAR(256)
 ,@IsUseFriendlyUrls BIT
 ,@CultureName NVARCHAR(256)
 ,@PortalID INT
AS
BEGIN
 
 DECLARE @MaxResultCharacter INT

 SELECT TOP (1) @MaxResultCharacter = SettingValue
 FROM [dbo].[SageFrameSearchSettingValue]
 WHERE SettingKey = 'MaxResultChracterAllowedWithSpace'
  AND CultureName = @CultureName
  AND PortalID = @PortalID

 DECLARE @length INT
 DECLARE @code NVARCHAR(20)

 IF (@CultureName = 'ne-NP')
 BEGIN
  SET @length = 3
  SET @code = N' ?'
 END
 ELSE
 BEGIN
  SET @length = 1
  SET @code = '.'
 END

 --select @code
 CREATE TABLE #TblSearchText (
  RowNum INT IDENTITY(1, 1)
  ,SearchText NVARCHAR(100)
  )
 CREATE TABLE #TblPage  (
  RowNum INT IDENTITY(1, 1)
  ,PageID INT
  )
 CREATE TABLE #TblUserModule (
  RowNum INT IDENTITY(1, 1)
  ,SearchPageID INT
  ,SearchUserModuleID INT
  ,SearchHTMLTextID INT
  ,HTMLContent NVARCHAR(max)
  ,UpdatedContentOn DATETIME
  ,UserModuleTitle NVARCHAR(500)
  )
 DECLARE @SearchKey NVARCHAR(256)
  ,@SearchCount INT
  ,@Counter INT
 DECLARE @textSQL NVARCHAR(2000)
 DECLARE @sqlStatement  NVARCHAR(4000)
 DECLARE @LikeText NVARCHAR(4000)
 DECLARE @SqlWhere NVARCHAR(4000)

 SET @LikeText = ''
 SET @SqlWhere = ''
 SET @sqlStatement = '' 
 SET @Searchword = RTRIM(LTRIM(@Searchword))


 IF (charindex(' ', @Searchword) > 0) --if more than one word in searchkey
 BEGIN
  DECLARE @rowText NVARCHAR(4000)
  CREATE TABLE #TblContent (
   RowNum INT identity(1, 1)
   ,SearchPageID INT
   ,SearchUserModuleID INT
   ,SearchHTMLTextID INT
   ,HTMLContent NVARCHAR(max)
   ,UpdatedContentOn DATETIME
   ,UserModuleTitle NVARCHAR(500)
   )

  INSERT INTO #TblSearchText (SearchText)
  SELECT RTRIM(LTRIM(items))  FROM [dbo].split(@Searchword, ' ')  
  WHERE Len(items) > 2 OR items NOT IN ( 'a','is','I','in','of','the','and','on','are','was' ,'has' ,'have','had','would','might','<','>','!','@','#')

  --filtering connector word/letter out
  --select * from @TblSearchText
  SELECT @SearchCount = COUNT(RowNum) FROM #TblSearchText

  SET @Counter = 1

  WHILE @Counter <= @SearchCount
  BEGIN
   SELECT @rowText = SearchText
   FROM #TblSearchText
   WHERE RowNum = @Counter
    
   SET @LikeText = @LikeText + ' [dbo].[HtmlText].[Content] LIKE N''%' + @rowText + '%'' or '
   ---SET @SqlWhere = @SqlWhere + ' [HTMLContent] LIKE N''%' + @rowText + '%'' or '
   SET @Counter = @Counter + 1
  END


  IF (len(@LikeText) > 2)
   SET @LikeText = SUBSTRING(@LikeText, 1, LEN(@LikeText) - 3)

  SET @textSQL = N''
  SET @textSQL = @textSQL + '   INSERT INTO #TblContent(SearchPageID,SearchUserModuleID,SearchHTMLTextID,HTMLContent,UpdatedContentOn)'
  SET @textSQL = @textSQL + '   SELECT [dbo].[Pages].PageID,[dbo].[HtmlText].[UserModuleID],[dbo].[HtmlText].HTMLTextID,   
          [dbo].[udf_StripHTML]([dbo].[HtmlText].[Content]) as HTMLContent, 
             [dbo].[HtmlText].[AddedOn] as UpdatedContentOn FROM [dbo].[HtmlText]'
  SET @textSQL = @textSQL + '  LEFT JOIN [dbo].[UserModules] WITH (NOLOCK) ON [dbo].[HtmlText].UserModuleID=[dbo].[UserModules].UserModuleID'
  SET @textSQL = @textSQL + '  LEFT JOIN [dbo].[PageModules]  WITH (NOLOCK) ON [dbo].[PageModules].UserModuleID=[dbo].[UserModules].UserModuleID'
  SET @textSQL = @textSQL + '  LEFT JOIN [dbo].[Pages]  WITH (NOLOCK) ON [dbo].[Pages].PageID= [dbo].[PageModules].PageID'
  SET @textSQL = @textSQL + '  WHERE ([dbo].[HtmlText].PortalID =' + CAST(@PortalID AS NVARCHAR) + ' and [dbo].[HtmlText].CultureName = ''' + @CultureName + ''') AND (' + @LikeText + ')'
  SET @textSQL = @textSQL + '  AND ([dbo].[Pages].IsDeleted=0 OR [dbo].[Pages].IsDeleted IS NULL) AND ([dbo].[UserModules].IsDeleted=0 OR [dbo].[UserModules].IsDeleted IS NULL) AND ([dbo].[PageModules].IsDeleted=0 OR [dbo].[PageModules].IsDeleted IS NULL)'
  SET @textSQL = @textSQL + '  AND [dbo].[Pages].IsActive=1 AND [dbo].[UserModules].IsActive=1 AND [dbo].[PageModules].IsActive=1 AND [dbo].[Pages].PortalID=' + CAST(@PortalID AS NVARCHAR) + ''
  EXEC sp_executesql @textSQL
  
  --inserting the result which consist of all words
  INSERT INTO #TblUserModule (
   SearchPageID
   ,SearchUserModuleID
   ,SearchHTMLTextID
   ,HTMLContent
   ,UpdatedContentOn
   )
  SELECT SearchPageID
   ,SearchUserModuleID
   ,SearchHTMLTextID
   ,HTMLContent
   ,UpdatedContentOn
  FROM #TblContent
  WHERE (HTMLContent LIKE N'%' + @Searchword + '%')

  --inserting the result which consist of atleast one word from group of words
  SELECT @SearchKey = SearchText
  FROM #TblSearchText
  WHERE RowNum = @Counter

  SET @Counter = @Counter + 1

  SELECT @SearchCount = COUNT(RowNum)
  FROM #TblSearchText

  SET @Counter = 1

  WHILE @Counter <= @SearchCount
  BEGIN
   SELECT @SearchKey = SearchText
   FROM #TblSearchText
   WHERE RowNum = @Counter

   INSERT INTO #TblUserModule (
    SearchPageID
    ,SearchUserModuleID
    ,SearchHTMLTextID
    ,HTMLContent
    ,UpdatedContentOn
    )
    SELECT #TblContent.SearchPageID
      ,#TblContent.SearchUserModuleID
      ,#TblContent.SearchHTMLTextID
      ,SUBSTRING(SUBSTRING(#TblContent.HTMLContent, charindex(@SearchKey, #TblContent.HTMLContent) - 150, @MaxResultCharacter), CASE 
        WHEN CHARINDEX(@SearchKey, SUBSTRING(#TblContent.HTMLContent, charindex(@SearchKey, #TblContent.HTMLContent) - 150, @MaxResultCharacter))
         - charindex(@code, SUBSTRING(#TblContent.HTMLContent, charindex(@SearchKey, #TblContent.HTMLContent) - 150, @MaxResultCharacter)) < 0
         THEN 0
        ELSE CHARINDEX(@code, SUBSTRING(#TblContent.HTMLContent, charindex(@SearchKey, #TblContent.HTMLContent) - 150, @MaxResultCharacter)) + @length
        END, @MaxResultCharacter) + '...' AS HTMLContent
      ,#TblContent.UpdatedContentOn  
    FROM #TblContent -- LEFT JOIN  @TblUserModule AS um ON #TblContent.SearchUserModuleID <> um.SearchUserModuleID
    WHERE (#TblContent.HTMLContent LIKE N'%' + @SearchKey + '%')
      AND SearchUserModuleID NOT IN ( SELECT SearchUserModuleID FROM #TblUserModule   )     
   SET @Counter = @Counter + 1
  END  
  --DROP TABLE #TblContent
  IF OBJECT_ID('tempdb..#TblContent') IS NOT NULL DROP TABLE #TblContent
  
 END
 ELSE
 BEGIN
  --if only one word
  INSERT INTO #TblUserModule (
   SearchPageID
   ,SearchUserModuleID
   ,SearchHTMLTextID
   ,HTMLContent
   ,UpdatedContentOn
   ) --DISTINCT
  SELECT [dbo].[Pages].PageID
   ,[dbo].[HtmlText].[UserModuleID]
   ,[dbo].[HtmlText].HTMLTextID
   , SUBSTRING(SUBSTRING( [dbo].[udf_StripHTML]([dbo].[HtmlText].[Content]), charindex(@Searchword,  [dbo].[udf_StripHTML]([dbo].[HtmlText].[Content])) - 150, @MaxResultCharacter),
     CASE WHEN charindex( @Searchword, SUBSTRING( [dbo].[udf_StripHTML]([dbo].[HtmlText].[Content]), charindex(@Searchword,[dbo].[udf_StripHTML]([dbo].[HtmlText].[Content])) - 150, @MaxResultCharacter)) - charindex(@code, SUBSTRING( [dbo].[udf_StripHTML]([dbo].[HtmlText].[Content]), charindex(@Searchword,  [dbo].[udf_StripHTML]([dbo].[HtmlText].[Content])) - 150, @MaxResultCharacter)) < 0
     THEN 0 ELSE Charindex(@code, SUBSTRING( [dbo].[udf_StripHTML]([dbo].[HtmlText].[Content]), charindex(@Searchword,  [dbo].[udf_StripHTML]([dbo].[HtmlText].[Content])) - 150, @MaxResultCharacter)) + @length
     END, @MaxResultCharacter) + '...' AS HTMLContent
   ,[dbo].[HtmlText].[AddedOn]
  FROM [dbo].[HtmlText]
    LEFT JOIN [dbo].[UserModules] ON [dbo].[HtmlText].UserModuleID = [dbo].[UserModules].UserModuleID
    LEFT JOIN [dbo].[PageModules] ON [dbo].[PageModules].UserModuleID = [dbo].[UserModules].UserModuleID
    LEFT JOIN [dbo].[Pages] ON [dbo].[Pages].PageID = [dbo].[PageModules].PageID
    WHERE [dbo].[Pages].PortalID = @PortalID
     AND [dbo].[Pages].PageID NOT IN (
      SELECT SearchPageID
      FROM #TblUserModule
      )
     AND (
      [dbo].[HtmlText].PortalID = @PortalID
      AND [dbo].[HtmlText].CultureName = @CultureName
      )
     AND [dbo].[HtmlText].[Content] LIKE '%' + @Searchword + '%'
     AND (
      [dbo].[Pages].IsDeleted = 0
      OR [dbo].[Pages].IsDeleted IS NULL
      )
     AND (
      [dbo].[UserModules].IsDeleted = 0
      OR [dbo].[UserModules].IsDeleted IS NULL
      )
     AND (
      [dbo].[PageModules].IsDeleted = 0
      OR [dbo].[PageModules].IsDeleted IS NULL
      )
     AND [dbo].[Pages].IsActive = 1
     AND [dbo].[UserModules].IsActive = 1
     AND [dbo].[PageModules].IsActive = 1
     AND [dbo].[Pages].PortalID = @PortalID
     
     --DROP TABLE #TblContent 
     IF OBJECT_ID('tempdb..#TblContent') IS NOT NULL DROP TABLE #TblContent
 END

 --------------------------------------------------------------------------------------------------------------------------------
 --DECLARE @IsParentPortal BIT,@PortalSEOName NVARCHAR(500),@PortalPrefix NVARCHAR(500)
 -- SELECT @IsParentPortal=IsParent,@PortalSEOName=LTRIM(RTRIM(SEOName)) FROM [dbo].[Portal] WHERE PortalID=@PortalID
 --  SET @PortalPrefix=''
 -- select * from @TblUserModule
 DECLARE @RowTotal INT
 CREATE TABLE #tblFinal  (
  PageName NVARCHAR(100)
  ,UserModuleID INT
  ,UserModuleTitle NVARCHAR(100)
  ,HTMLContent NTEXT
  ,URL NVARCHAR(100)
  ,UpdatedContentOn DATETIME
  ,RowNumber INT identity(1, 1)
  )
 DECLARE @IsParentPortal BIT
  ,@PortalSEOName NVARCHAR(500)
  ,@PortalPrefix NVARCHAR(500)
 DECLARE @pageExtension VARCHAR(10)

 SET @pageExtension = (
   SELECT SettingValue
   FROM SettingValue
   WHERE SettingKey = 'PageExtension'
   )

 SELECT @IsParentPortal = IsParent
  ,@PortalSEOName = LTRIM(RTRIM(SEOName))
 FROM [dbo].[Portal]
 WHERE PortalID = @PortalID

 --SELECT @IsParentPortal
 --select @pageExtension
 SET @PortalPrefix = ''

 IF (NOT (@IsParentPortal = 1))
 BEGIN
  SET @PortalPrefix = '/portal/' + @PortalSEOName
  SET @PortalPrefix = ''
 END

 -- SELECT @IsUseFriendlyUrls
 IF @IsUseFriendlyUrls = 1
 BEGIN
  
  ;WITH numbered
  AS (
   SELECT [dbo].[Pages].PageName
    ,[dbo].[UserModules].[UserModuleID]
    ,[dbo].[UserModules].UserModuleTitle
    ,HTMLContent
    ,( CASE 
      WHEN ([dbo].[Pages].Url IS NULL)
       OR (LEN(LTRIM(RTRIM([dbo].[Pages].Url))) < 1)
       THEN replace('./' + @PortalPrefix + LTRIM(RTRIM([dbo].[Pages].PageName)) + @pageExtension, ' ', '-')
      ELSE LTRIM(RTRIM([dbo].[Pages].Url))
      END
     ) AS Url
    ,UpdatedContentOn
    ,rownum = ROW_NUMBER() OVER (
     PARTITION BY PageName ORDER BY HTMLContent
     )
   FROM [dbo].[Pages]
    INNER JOIN #TblUserModule ON [dbo].[Pages].PageID = SearchPageID
    INNER JOIN [dbo].[UserModules] ON [dbo].[UserModules].UserModuleID = SearchUserModuleID
    WHERE [dbo].[Pages].PortalID = @PortalID
    )
  INSERT INTO #tblFinal
  SELECT PageName
   ,UserModuleID
   ,UserModuleTitle
   ,HTMLContent
   ,URL
   ,UpdatedContentOn
  FROM numbered
  WHERE rownum = 1
  
 END
 ELSE
 BEGIN
  
  ;WITH numbered
  AS (
   SELECT PageName
    ,[dbo].[UserModules].UserModuleID
    ,[dbo].[UserModules].UserModuleTitle
    ,HTMLContent
    ,(
     CASE 
      WHEN ([dbo].[Pages].Url IS NULL)
       OR (LEN(LTRIM(RTRIM([dbo].[Pages].Url))) < 1)
       THEN replace('./Default' + @pageExtension + '?ptlid=' + CONVERT(NVARCHAR(18), @PortalID) + '&ptSEO=' + @PortalSEOName + '&pgnm=' + LTRIM(RTRIM([dbo].[Pages].[SEOName])), ' ', '-')
      ELSE LTRIM(RTRIM([dbo].[Pages].Url))
      END
     ) AS Url
    ,UpdatedContentOn
    ,rownum = ROW_NUMBER() OVER (
     PARTITION BY PageName ORDER BY HTMLContent
     )
   FROM [dbo].[Pages]
   INNER JOIN #TblUserModule ON [dbo].[Pages].PageID = SearchPageID
   INNER JOIN [dbo].[UserModules] ON [dbo].[UserModules].UserModuleID = SearchUserModuleID
   WHERE [dbo].[Pages].PortalID = @PortalID
   )

  INSERT INTO #tblFinal
  SELECT PageName
   ,UserModuleID
   ,UserModuleTitle
   ,HTMLContent
   ,URL
   ,UpdatedContentOn
  FROM numbered
  WHERE rownum = 1
 END


 SELECT @CultureName AS CultureName
  ,t.PageName
  ,t.UserModuleID
  ,t.UserModuleTitle
  ,t.HTMLContent
  ,t.URL
  ,t.UpdatedContentOn
 FROM #tblFinal AS t

DROP TABLE #TblSearchText
DROP TABLE #TblPage
DROP TABLE #TblUserModule

DROP TABLE #tblFinal

END





GO
