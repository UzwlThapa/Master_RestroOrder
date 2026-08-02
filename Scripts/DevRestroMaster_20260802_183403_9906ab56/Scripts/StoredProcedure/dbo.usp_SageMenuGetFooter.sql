SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageMenuGetFooter]
 @PortalID [INT],
 @UserName [NVARCHAR](256),
 @CultureCode [NVARCHAR](20)  
AS
BEGIN

    DECLARE @prefix [NVARCHAR](10)
 DECLARE @IsActive [BIT]
 DECLARE @IsDeleted [BIT] 
 DECLARE @IsVisible [BIT]
 DECLARE @IsRequiredPage BIT
 SET @prefix='---'
 SET @IsActive=NULL
 SET @IsDeleted=0 
 SET @IsVisible=NULL
 SET @IsRequiredPage=NULL
CREATE TABLE #tblPages
(
PageID INT
)
create table #TEMP
(
 [PageID] [INT],
 [PageOrder] [INT] NULL,
 [PageName] [NVARCHAR](100),
 [LevelPageName] [NVARCHAR](100),
 [IsVisible] [BIT] NULL,
 [ParentID] [INT] NULL,
 [Level] [INT] NULL,
 [IconFile] [NVARCHAR](100),
 [DisableLink] [BIT] NULL,
 [Title] [NVARCHAR](200) NULL,
 [Description] [NVARCHAR](500) NULL,
 [KeyWords] [NVARCHAR](500)  NULL,
 [Url] [NVARCHAR](255) ,
 [TabPath] [NVARCHAR](255) NULL,
 [StartDate] [DATETIME] NULL,
 [EndDate] [DATETIME] NULL,
 [RefreshINTerval] [decimal](16, 2) NULL,
 [PageHeadText] [NVARCHAR](500) NULL,
 [IsSecure] [BIT] NOT NULL,
 [IsActive] [BIT] NULL,
 [IsDeleted] [BIT] NULL,
 [IsModified] [BIT] NULL,
 [AddedOn] [DATETIME] NULL,
 [UpdatedOn] [DATETIME] NULL,
 [DeletedOn] [DATETIME] NULL,
 [PortalID] [INT] NULL,
 [AddedBy] [NVARCHAR](256) NULL,
 [UpdatedBy] [NVARCHAR](256) NULL,
 [DeletedBy] [NVARCHAR](256) NULL,
 [SEOName] [NVARCHAR](100) NULL,
 [newOrder] DECIMAL(38,10),
 [ShowInMenu] [BIT] NULL
)
INSERT INTO #tblPages
SELECT DISTINCT dbo.pagepermission.PageID FROM dbo.pagepermission 
WHERE RoleID IN (SELECT RoleId FROM dbo.ASpnet_usersinroles INNER JOIN dbo.ASpnet_users ON dbo.ASpnet_usersinroles.UserId=dbo.ASpnet_users.UserId 
     WHERE dbo.ASpnet_users.Username=@UserName) ;
WITH PageOrders([PageID]
      ,[PageOrder]
   ,[PageName]
      ,[LevelPageName]
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
      ,[StartDate]
      ,[EndDate]
      ,[RefreshINTerval]
      ,[PageHeadText]
      ,[IsSecure]
      ,[IsActive]
      ,[IsDeleted]
      ,[IsModified]
      ,[AddedOn]
      ,[UpdatedOn]
      ,[DeletedOn]
      ,[PortalID]
      ,[AddedBy]
      ,[UpdatedBy]
      ,[DeletedBy]
      ,[SEOName]
   ,[newOrder]
   ,[ShowInMenu]) 
AS
(
 SELECT P1.[PageID]
      ,P1.[PageOrder]
   ,P1.[PageName]
      ,(dbo.fn_LevelPrefix(CONVERT(INT,ISNULL(P1.[Level],0)),@prefix) + P1.[PageName]) AS [LevelPageName]
      ,P1.[IsVisible]
      ,P1.[ParentID]
      ,P1.[Level]
      ,P1.[IconFile]
      ,P1.[DisableLink]
      ,P1.[Title]
      ,P1.[Description]
      ,P1.[KeyWords]
      ,P1.[Url]
      ,P1.[TabPath]
      ,P1.[StartDate]
      ,P1.[EndDate]
      ,P1.[RefreshINTerval]
      ,P1.[PageHeadText]
      ,P1.[IsSecure]
      ,P1.[IsActive]
      ,P1.[IsDeleted]
      ,P1.[IsModified]
      ,P1.[AddedOn]
      ,P1.[UpdatedOn]
      ,P1.[DeletedOn]
      ,P1.[PortalID]
      ,P1.[AddedBy]
      ,P1.[UpdatedBy]
      ,P1.[DeletedBy]
      ,P1.[SEOName]
   ,CAST(P1.[PageOrder] AS VARCHAR(100)) AS [newOrder]
   ,pm.[ShowInMenu]
 FROM [dbo].[Pages] AS P1 
 INNER JOIN #tblPages ON #tblPages.pageid=P1.PageID
 INNER JOIN [dbo].[PageMenu] pm on P1.PageID=pm.PageID 
 WHERE (P1.IsDeleted=@IsDeleted OR @IsDeleted IS NULL) AND P1.PortalID=@PortalID AND (P1.IsRequiredPage=@IsRequiredPage OR @IsRequiredPage IS NULL) 
  AND P1.ParentID=0 AND (P1.IsActive=@IsActive OR @IsActive IS NULL) AND (P1.IsVisible=@IsVisible OR @IsVisible IS NULL) AND P1.DisableLink=0 
  AND pm.IsFooter=1
 UNION ALL
 SELECT P1.[PageID]
      ,P1.[PageOrder]
   ,P1.[PageName]
      ,(dbo.fn_LevelPrefix(CONVERT(INT,ISNULL(P1.[Level],0)),@prefix) + P1.[PageName]) AS [LevelPageName]
      ,P1.[IsVisible]
      ,P1.[ParentID]
      ,P1.[Level]
      ,P1.[IconFile]
      ,P1.[DisableLink]
      ,P1.[Title]
      ,P1.[Description]
      ,P1.[KeyWords]
      ,P1.[Url]
      ,P1.[TabPath]
      ,P1.[StartDate]
      ,P1.[EndDate]
      ,P1.[RefreshINTerval]
      ,P1.[PageHeadText]
      ,P1.[IsSecure]
      ,P1.[IsActive]
      ,P1.[IsDeleted]
      ,P1.[IsModified]
      ,P1.[AddedOn]
      ,P1.[UpdatedOn]
      ,P1.[DeletedOn]
      ,P1.[PortalID]
      ,P1.[AddedBy]
      ,P1.[UpdatedBy]
      ,P1.[DeletedBy]
      ,P1.[SEOName]
   ,CAST([newOrder] AS VARCHAR(10))+'.'+ CAST(Right('00'+CAST(P1.[PageOrder] AS VARCHAR(2)),2) AS VARCHAR(89))  AS [newOrder]
 ,PM.[ShowInMenu]
 FROM [dbo].[Pages] AS P1
 INNER JOIN #tblPages ON #tblPages.pageid=P1.PageID
 INNER JOIN [dbo].[PageMenu] pm ON P1.PageID=pm.PageID
  INNER JOIN PageOrders AS po
        ON po.[PageID] = p1.[ParentID] 
 WHERE (P1.IsDeleted=@IsDeleted OR @IsDeleted IS NULL) AND P1.PortalID=@PortalID AND (P1.IsRequiredPage=@IsRequiredPage OR @IsRequiredPage IS NULL) 
  AND P1.[Level]=1 AND (P1.IsActive=@IsActive OR @IsActive IS NULL) AND (P1.IsVisible=@IsVisible OR @IsVisible IS NULL) AND P1.DisableLink=0 and pm.IsFooter=1
 UNION ALL
 SELECT P1.[PageID]
      ,P1.[PageOrder]
   ,P1.[PageName]
      ,(dbo.fn_LevelPrefix(CONVERT(INT,ISNULL(P1.[Level],0)),@prefix) + P1.[PageName]) AS [LevelPageName]
      ,P1.[IsVisible]
      ,P1.[ParentID]
      ,P1.[Level]
      ,P1.[IconFile]
      ,P1.[DisableLink]
      ,P1.[Title]
      ,P1.[Description]
      ,P1.[KeyWords]
      ,P1.[Url]
      ,P1.[TabPath]
      ,P1.[StartDate]
      ,P1.[EndDate]
      ,P1.[RefreshINTerval]
      ,P1.[PageHeadText]
      ,P1.[IsSecure]
      ,P1.[IsActive]
      ,P1.[IsDeleted]
      ,P1.[IsModified]
      ,P1.[AddedOn]
      ,P1.[UpdatedOn]
      ,P1.[DeletedOn]
      ,P1.[PortalID]
      ,P1.[AddedBy]
      ,P1.[UpdatedBy]
      ,P1.[DeletedBy]
      ,P1.[SEOName]
   ,CAST([newOrder] AS VARCHAR(10))+CAST(Right('00'+CAST(P1.[PageOrder] AS VARCHAR(2)),2) AS VARCHAR(90))  AS [newOrder]
 ,pm.[ShowInMenu]
 FROM [dbo].[Pages] AS P1
 INNER JOIN #tblPages ON #tblPages.pageid=P1.PageID
 INNER JOIN [dbo].[PageMenu] pm on P1.PageID=pm.PageID
  INNER JOIN PageOrders AS po
        ON po.[PageID] = p1.[ParentID] 
 WHERE (P1.IsDeleted=@IsDeleted OR @IsDeleted IS NULL) AND P1.PortalID=@PortalID AND (P1.IsRequiredPage=@IsRequiredPage OR @IsRequiredPage IS NULL) 
  AND P1.[Level]>1 AND (P1.IsActive=@IsActive OR @IsActive IS NULL) AND (P1.IsVisible=@IsVisible OR @IsVisible IS NULL)  AND P1.DisableLink=0 and pm.IsFooter=1
)
INSERT INTO #TEMP
SELECT [PageID]
      ,[PageOrder]
   ,[PageName]
      ,[LevelPageName]
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
      ,[StartDate]
      ,[EndDate]
      ,[RefreshINTerval]
      ,[PageHeadText]
      ,[IsSecure]
      ,[IsActive]
      ,[IsDeleted]
      ,[IsModified]
      ,[AddedOn]
      ,[UpdatedOn]
      ,[DeletedOn]
      ,[PortalID]
      ,[AddedBy]
      ,[UpdatedBy]
      ,[DeletedBy]
      ,[SEOName]
   ,CASt([newOrder] AS DECIMAL(38,10)) AS [newOrder],[ShowInMenu] FROM PageOrders
ORDER BY [newOrder]

SELECT P1.[PageID]
      ,[PageOrder]
   ,[PageName]
      ,[LevelPageName]
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
      ,[StartDate]
      ,[EndDate]
      ,[RefreshINTerval]
      ,[PageHeadText]
      ,[IsSecure]
      ,[IsActive]
      ,[IsDeleted]
      ,[IsModified]
      ,[AddedOn]
      ,[UpdatedOn]
      ,[DeletedOn]
      ,[PortalID]
      ,[AddedBy]
      ,[UpdatedBy]
      ,[DeletedBy]
      ,( CASE 
                 WHEN (SELECT COUNT(pageid) 
                       FROM   localpage 
                       WHERE  pageid = p1.pageid 
                              AND culturecode = @Culturecode) > 0 THEN (SELECT 
                 localpagename 
                                                                        FROM 
                 localpage 
                                                                        WHERE 
                 pageid = p1.pageid 
                 AND culturecode = @CultureCode) 
                 ELSE (SELECT pagename 
                       FROM   pages 
                       WHERE  pageid = p1.pageid) 
               END )                               AS seoname 
   ,(SELECT MAX([PageOrder]) FROM [dbo].[Pages] AS m WHERE m.PageOrder<5000 AND (m.IsActive=@IsActive OR @IsActive IS NULL) AND m.IsDeleted=@IsDeleted 
  AND m.PortalID=@PortalID AND ((@IsVisible=0 OR @IsVisible IS NULL) OR (m.[DisableLink]=0 AND m.IsVisible=@IsVisible)) 
  AND m.[Level]=P1.[Level] and  m.ParentID=P1.ParentID) AS [MaxPageOrder]
      ,(SELECT MIN([PageOrder]) FROM [dbo].[Pages] AS m WHERE m.PageOrder<5000 AND (m.IsActive=@IsActive OR @IsActive IS NULL) AND m.IsDeleted=@IsDeleted 
  AND m.PortalID=@PortalID AND ((@IsVisible=0 OR @IsVisible IS NULL) OR (m.[DisableLink]=0 AND m.IsVisible=@IsVisible)) 
  AND m.[Level]=P1.[Level] and  m.ParentID=P1.ParentID) AS [MinPageOrder] 
 ,[ShowInMenu]
FROM #TEMP AS P1
WHERE [ShowInMenu]=1
ORDER BY [newOrder]
DROP TABLE #TEMP
DROP TABLE #tblPages
END





GO
