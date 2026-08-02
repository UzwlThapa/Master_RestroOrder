SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[sp_NewsSearch] N'Acharya','anonymoususer',1,'en-US',1
-- =============================================
CREATE PROCEDURE [dbo].[sp_NewsSearch] 
 @Searchword nvarchar(500),
 @SearchBy nvarchar(256),
 @IsUseFriendlyUrls bit,
 @CultureName nvarchar(256),
 @PortalID INT
 
AS
BEGIN
 Declare @MaxResultCharacter int
set @MaxResultCharacter = (select top(1) SettingValue from [dbo].[SageFrameSearchSettingValue] where SettingKey ='MaxResultChracterAllowedWithSpace' and PortalID=@PortalID and CultureName=@CultureName)

declare @length int

Declare @code nvarchar(20)
if(@CultureName='ne-NP') 
 begin
set @length=3
set @code=N' ?'
 end
 
else
begin
set @length=1
set @code='.'
end
--select @code
 DECLARE @TblSearchText AS TABLE
 (
  RowNum INT IDENTITY(1,1),
  SearchText NVARCHAR(100)
 )

 DECLARE @TblPage AS TABLE
 (
  RowNum INT IDENTITY(1,1),
  PageID INT
 )

 DECLARE @TblUserModule AS TABLE
 (
  RowNum INT IDENTITY(1,1),
  SearchPageID INT,
  SearchUserModuleID INT,
  SearchHTMLTextID INT,
  HTMLContent nvarchar(max) ,
  UpdatedContentOn datetime,
  UserModuleTitle nvarchar(500)
 )

  DECLARE @SearchKey NVARCHAR(256),@SearchCount INT, @Counter INT
  declare @textSQL nvarchar(2000)
  declare @LikeText nvarchar(4000)

set @LikeText=''
set @Searchword=RTRIM(LTRIM(@Searchword))


IF(charindex(' ',@Searchword)>0) --if more than one word in searchkey
 BEGIN
        DECLARE  @rowText nvarchar(4000)
        CREATE TABLE #TblContent 
    (
     RowNum int identity(1,1),
     SearchPageID INT,
     SearchUserModuleID INT,
     SearchHTMLTextID INT,
     HTMLContent nvarchar(max),
              UpdatedContentOn datetime,
     UserModuleTitle nvarchar(500)   
    )

  INSERT INTO @TblSearchText(SearchText)
   SELECT RTRIM(LTRIM(items)) FROM [dbo].split( @Searchword,' ')
     WHERE Len(items)>2 or items not in ('a','is','I','in','of','the','and','on','are','was','has','have','had','would','might','<','>','!','@','#')
    --filtering connector word/letter out

     --select * from @TblSearchText
   SELECT @SearchCount=COUNT(RowNum) FROM @TblSearchText

   SET @Counter=1
    WHILE @Counter<=@SearchCount
     BEGIN
       SELECT @rowText=SearchText from @TblSearchText where RowNum=@Counter
       --dbo.ufn_RegExpLike(Content)
       SET @LikeText=@LikeText +' dbo.ufn_RegExpLike([dbo].[News].[News])  LIKE N''%'+@rowText +'%'' or '

  
      SET @Counter=@Counter+1
      END 

 IF(len(@LikeText)>2)
  SET @LikeText=substring(@LikeText,1,len(@LikeText)-3)


 --print  @LikeText

   set @textSQL=N''
   set @textSQL=@textSQL+'INSERT INTO #TblContent(SearchPageID,SearchUserModuleID,SearchHTMLTextID,HTMLContent,UpdatedContentOn)'
   set @textSQL=@textSQL+'  SELECT [dbo].[Pages].PageID,[dbo].[News].[UserModuleID],[dbo].[News].[NewsID] as HTMLTextID,
   
 dbo.ufn_RegExpLike([dbo].[News].[News])
 as HTMLContent,[dbo].[News].[AddedOn] as UpdatedContentOn FROM [dbo].[News]' 
   set @textSQL=@textSQL+'  INNER JOIN [dbo].[UserModules] ON [dbo].[News].UserModuleID=[dbo].[UserModules].UserModuleID'
   set @textSQL=@textSQL+'  INNER JOIN [dbo].[PageModules] ON [dbo].[PageModules].UserModuleID=[dbo].[UserModules].UserModuleID'
   set @textSQL=@textSQL+'  INNER JOIN [dbo].[Pages] ON [dbo].[Pages].PageID= [dbo].[PageModules].PageID'
   set @textSQL=@textSQL+'  WHERE ([dbo].[News].PortalID ='+CAST (@PortalID as nVarChar)+' and [dbo].[News].CultureCode = '''+@CultureName+''') AND ('+@LikeText+')'
   set @textSQL=@textSQL+'  AND ([dbo].[Pages].IsDeleted=0 OR [dbo].[Pages].IsDeleted IS NULL) AND ([dbo].[UserModules].IsDeleted=0 OR [dbo].[UserModules].IsDeleted IS NULL) AND ([dbo].[PageModules].IsDeleted=0 OR [dbo].[PageModules].IsDeleted IS NULL)'
   set @textSQL=@textSQL+'  AND [dbo].[Pages].IsActive=1 AND [dbo].[UserModules].IsActive=1 AND [dbo].[PageModules].IsActive=1 AND [dbo].[Pages].PortalID='+CAST (@PortalID as nVarChar)+''


 EXEC sp_executesql @textSQL


--inserting the result which consist of all words
 INSERT INTO @TblUserModule(SearchPageID,SearchUserModuleID,SearchHTMLTextID,HTMLContent,UpdatedContentOn)
   SELECT SearchPageID,SearchUserModuleID,SearchHTMLTextID,HTMLContent,UpdatedContentOn FROM #TblContent
    WHERE (HTMLContent  LIKE N'%' + @Searchword+ '%')



--inserting the result which consist of atleast one word from group of words

    SELECT @SearchKey=SearchText FROM @TblSearchText WHERE RowNum=@Counter

     SET @Counter=@Counter+1

    SELECT @SearchCount=COUNT(RowNum) FROM @TblSearchText
     SET @Counter=1
      WHILE @Counter<=@SearchCount
       BEGIN
         SELECT @SearchKey=SearchText FROM @TblSearchText WHERE RowNum=@Counter
         
          INSERT INTO @TblUserModule(SearchPageID,SearchUserModuleID,SearchHTMLTextID,HTMLContent,UpdatedContentOn)
         SELECT SearchPageID,SearchUserModuleID,SearchHTMLTextID,
          SUBSTRING
       (
       
       SUBSTRING
         (
         dbo.ufn_RegExpLike(#TblContent.HTMLContent),
        charindex(@SearchKey,dbo.ufn_RegExpLike(#TblContent.HTMLContent))-150,
         @MaxResultCharacter
         )
         ,
       case 
       when charindex(@SearchKey,
        SUBSTRING
         (
         dbo.ufn_RegExpLike(#TblContent.HTMLContent),
        charindex(@SearchKey,dbo.ufn_RegExpLike(#TblContent.HTMLContent))-150,
         @MaxResultCharacter
         )
        )
        -

    charindex(@code,
        SUBSTRING
         (
         dbo.ufn_RegExpLike(#TblContent.HTMLContent),
        charindex(@SearchKey,dbo.ufn_RegExpLike(#TblContent.HTMLContent))-150,
         @MaxResultCharacter
         )
        )
        <0 then 0
      else 


       Charindex(@code,
         SUBSTRING
         (
         dbo.ufn_RegExpLike(#TblContent.HTMLContent),
        charindex(@SearchKey,dbo.ufn_RegExpLike(#TblContent.HTMLContent))-150,
         @MaxResultCharacter
         )
           )+@length
        END
       ,@MaxResultCharacter
      ) +'...'
     
      as HTMLContent,
         UpdatedContentOn FROM #TblContent
         WHERE (HTMLContent  LIKE N'%' + @SearchKey + '%')and SearchUserModuleID not in( select SearchUserModuleID from @TblUserModule)
         SET @Counter=@Counter+1
        END
        
    DROP TABLE #TblContent
    
  END 
ELSE
  BEGIN
  

     --if only one word
   INSERT INTO @TblUserModule(SearchPageID,SearchUserModuleID,SearchHTMLTextID,HTMLContent,UpdatedContentOn)--DISTINCT
     SELECT  [dbo].[Pages].PageID,[dbo].[News].[UserModuleID],[dbo].[News].[NewsID] as HTMLTextID,
 --dbo.ufn_StripHTML([dbo].[HtmlText].[Content])
    -- SUBSTRING
    -- (
    -- dbo.ufn_StripHTML([dbo].[HtmlText].[Content]),
    --charindex(@Searchword,dbo.ufn_StripHTML([dbo].[HtmlText].[Content]))-150,
    -- 300
    -- )
     
      SUBSTRING
       (
       
       SUBSTRING
         (
         dbo.ufn_RegExpLike([dbo].[News].[News]),
        charindex(@Searchword,dbo.ufn_RegExpLike([dbo].[News].[News]))-150,
         @MaxResultCharacter
         )
         ,
       case 
       when charindex(@Searchword,
        SUBSTRING
         (
         dbo.ufn_RegExpLike([dbo].[News].[News]),
        charindex(@Searchword,dbo.ufn_RegExpLike([dbo].[News].[News]))-150,
         @MaxResultCharacter
         )
        )
        -

    charindex(@code,
        SUBSTRING
         (
         dbo.ufn_RegExpLike([dbo].[News].[News]),
        charindex(@Searchword,dbo.ufn_RegExpLike([dbo].[News].[News]))-150,
         @MaxResultCharacter
         )
        )
        <0 then 0
      else 


       Charindex(@code,
         SUBSTRING
         (
         dbo.ufn_RegExpLike([dbo].[News].[News]),
        charindex(@Searchword,dbo.ufn_RegExpLike([dbo].[News].[News]))-150,
         @MaxResultCharacter
         )
           )+@length
        END
       ,@MaxResultCharacter
      ) +'...'
     
      as HTMLContent,[dbo].[News].[AddedOn] FROM [dbo].[News] 
           INNER JOIN [dbo].[UserModules] ON [dbo].[News].UserModuleID=[dbo].[UserModules].UserModuleID
           INNER JOIN [dbo].[PageModules] ON [dbo].[PageModules].UserModuleID=[dbo].[UserModules].UserModuleID
           INNER JOIN [dbo].[Pages] ON [dbo].[Pages].PageID= [dbo].[PageModules].PageID
      WHERE 
      [dbo].[Pages].PortalID=@PortalID and
       [dbo].[Pages].PageID not in( select SearchPageID from @TblUserModule)  and([dbo].[News].PortalID = @PortalID AND [dbo].[News].CultureCode = @CultureName) AND
      
       dbo.ufn_RegExpLike([dbo].[News].[News])  LIKE '%' + @Searchword + '%'
      
      
      
       AND ([dbo].[Pages].IsDeleted=0 OR [dbo].[Pages].IsDeleted IS NULL) AND ([dbo].[UserModules].IsDeleted=0 OR [dbo].[UserModules].IsDeleted IS NULL) AND ([dbo].[PageModules].IsDeleted=0 OR [dbo].[PageModules].IsDeleted IS NULL)
        AND [dbo].[Pages].IsActive=1 AND [dbo].[UserModules].IsActive=1 AND [dbo].[PageModules].IsActive=1
       AND [dbo].[Pages].PortalID=@PortalID 
  END
--------------------------------------------------------------------------------------------------------------------------------
declare @RowTotal INT
DECLARE @tblFinal Table(PageName nvarchar(100),UserModuleID INT,UserModuleTitle nvarchar(100),HTMLContent ntext,URL nvarchar(100),UpdatedContentOn Datetime,RowNumber int identity(1,1))


DECLARE @IsParentPortal BIT,@PortalSEOName NVARCHAR(500),@PortalPrefix NVARCHAR(500)
 SELECT @IsParentPortal=IsParent,@PortalSEOName=LTRIM(RTRIM(SEOName)) FROM [dbo].[Portal] WHERE PortalID=@PortalID
 SET @PortalPrefix=''
 IF(NOT(@IsParentPortal=1))
 BEGIN
  SET @PortalPrefix='/portal/'+@PortalSEOName
 END
  
   IF @IsUseFriendlyUrls=1
    BEGIN
    ;WITH numbered AS 
     (
     SELECT  [dbo].[Pages].PageName,[dbo].[UserModules].[UserModuleID],[dbo].[UserModules].UserModuleTitle,HTMLContent,
      (CASE WHEN ([dbo].[Pages].Url IS NULL) OR (LEN(LTRIM(RTRIM([dbo].[Pages].Url)))<1)
       THEN '.'+ @PortalPrefix+LTRIM(RTRIM([dbo].[Pages].TabPath))+'.aspx'
        ELSE LTRIM(RTRIM([dbo].[Pages].Url)) END) AS Url,
      UpdatedContentOn,
      rownum=ROW_NUMBER() OVER (PARTITION BY PageName ORDER BY HTMLContent)
     from [dbo].[Pages] 
       inner join  @TblUserModule on [dbo].[Pages].PageID=SearchPageID 
       inner join [dbo].[UserModules] on [dbo].[UserModules].UserModuleID=SearchUserModuleID
     WHERE [dbo].[Pages].PortalID=@PortalID 
     )
     INSERT INTO @tblFinal
     SELECT PageName,UserModuleID,UserModuleTitle,HTMLContent,URL,UpdatedContentOn
      FROM numbered
      WHERE rownum=1
      --and dbo.
    END
   ELSE
    BEGIN
     ;WITH numbered AS 
     (
      SELECT PageName,[dbo].[UserModules].UserModuleID,[dbo].[UserModules].UserModuleTitle,HTMLContent,
      (CASE WHEN ([dbo].[Pages].Url IS NULL) OR (LEN(LTRIM(RTRIM([dbo].[Pages].Url)))<1)
       THEN './Default.aspx?ptlid='+CONVERT(NVARCHAR(18),@PortalID)+'&ptSEO='+@PortalSEOName+'&pgnm='+LTRIM(RTRIM([dbo].[Pages].[SEOName])) 
       ELSE LTRIM(RTRIM([dbo].[Pages].Url)) END) AS Url,
       UpdatedContentOn,
        rownum=ROW_NUMBER() OVER (PARTITION BY PageName ORDER BY HTMLContent)
       from [dbo].[Pages] 
       inner join  @TblUserModule on [dbo].[Pages].PageID=SearchPageID 
       inner join [dbo].[UserModules] on [dbo].[UserModules].UserModuleID=SearchUserModuleID
       WHERE [dbo].[Pages].PortalID=@PortalID 
     )
     INSERT INTO @tblFinal
     SELECT PageName,UserModuleID,UserModuleTitle,HTMLContent,URL,UpdatedContentOn
      FROM numbered
      WHERE rownum=1
    END 
    
    --SELECT @RowTotal=COUNT(*) FROM @tblFinal
    
    SELECT @CultureName as CultureName, t.PageName,t.UserModuleID,t.UserModuleTitle,t.HTMLContent,t.URL,t.UpdatedContentOn from @tblFinal as t
    
   

END





GO
