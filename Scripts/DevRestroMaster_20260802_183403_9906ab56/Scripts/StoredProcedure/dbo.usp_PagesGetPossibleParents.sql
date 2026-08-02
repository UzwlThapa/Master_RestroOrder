SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PagesGetPossibleParents]
 @prefix NVARCHAR(10),
 @IsActive BIT,
 @IsDeleted BIT,
 @PortalID INT,
 @UserName NVARCHAR(256),
 @IsVisible BIT,
 @IsRequiredPage BIT,
 @PageID INT
WITH EXECUTE AS CALLER
AS
BEGIN
--create temp table #TblPages
CREATE TABLE #TblPages
(
 PageID INT
)
CREATE TABLE #Temp
(
 [PageID] INT,
 [PageOrder] INT NULL,
 [PageName] NVARCHAR(100),
 [LevelPageName] NVARCHAR(100),
 [IsVisible] BIT NULL,
 [ParentID] INT NULL,
 [Level] INT NULL,
 [IconFile] NVARCHAR(100),
 [DisableLink] BIT NULL,
 [Title] NVARCHAR(200) NULL,
 [Description] NVARCHAR(500) NULL,
 [KeyWords] NVARCHAR(500)  NULL,
 [Url] NVARCHAR(255) ,
 [TabPath] NVARCHAR(255) NULL,
 [StartDate] DATETIME NULL,
 [EndDate] [datetime] NULL,
 [RefreshInterval] DECIMAL(16, 2) NULL,
 [PageHeadText] NVARCHAR(500) NULL,
 [IsSecure] BIT NOT NULL,
 [IsActive] BIT NULL,
 [IsDeleted] BIT NULL,
 [IsModified] BIT NULL,
 [AddedOn] DATETIME NULL,
 [UpdatedOn] DATETIME NULL,
 [DeletedOn] DATETIME NULL,
 [PortalID] INT NULL,
 [AddedBy] NVARCHAR(256) NULL,
 [UpdatedBy] NVARCHAR(256) NULL,
 [DeletedBy] NVARCHAR(256) NULL,
 [SEOName] NVARCHAR(100) NULL,
 [newOrder] DECIMAL(38,10)
)
INSERT INTO #TblPages
SELECT DISTINCT dbo.PagePermission.PageID FROM dbo.PagePermission 
WHERE RoleID IN (SELECT RoleId FROM dbo.aspnet_UsersInRoles INNER JOIN dbo.aspnet_Users 
ON dbo.aspnet_UsersInRoles.UserId=dbo.aspnet_Users.UserId 
WHERE dbo.aspnet_Users.Username=@UserName  AND dbo.PagePermission.PageID<>@PageID);

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
      ,[RefreshInterval]
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
   ,[newOrder]) 
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
      ,P1.[RefreshInterval]
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
   ,CAST(P1.[PageOrder] AS VARCHAR(100)) as [newOrder]
 FROM [dbo].[Pages] AS P1 
 INNER JOIN #TblPages ON #TblPages.pageid=P1.PageID
 where (P1.IsDeleted=@IsDeleted OR @IsDeleted IS NULL) AND P1.PortalID=@PortalID 
 AND (P1.IsRequiredPage=@IsRequiredPage OR @IsRequiredPage IS NULL) 
 AND P1.ParentID=0 AND (P1.IsActive=@IsActive OR @IsActive IS NULL) 
 AND (P1.IsVisible=@IsVisible OR @IsVisible IS NULL) AND P1.DisableLink=0
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
      ,P1.[RefreshInterval]
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
 FROM [dbo].[Pages] AS P1
 INNER JOIN #TblPages ON #TblPages.pageid=P1.PageID
  INNER JOIN PageOrders AS po
        ON po.[PageID] = p1.[ParentID]
 WHERE (P1.IsDeleted=@IsDeleted OR @IsDeleted IS NULL) AND P1.PortalID=@PortalID 
 AND (P1.IsRequiredPage=@IsRequiredPage OR @IsRequiredPage IS NULL) AND P1.[Level]=1 
 AND (P1.IsActive=@IsActive OR @IsActive IS NULL) AND (P1.IsVisible=@IsVisible OR @IsVisible IS NULL) 
 AND P1.DisableLink=0
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
      ,P1.[RefreshInterval]
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
 FROM [dbo].[Pages] AS P1
 INNER JOIN #TblPages ON #TblPages.pageid=P1.PageID
  INNER JOIN PageOrders AS po
        ON po.[PageID] = p1.[ParentID]
 WHERE (P1.IsDeleted=@IsDeleted OR @IsDeleted IS NULL) AND P1.PortalID=@PortalID
  AND (P1.IsRequiredPage=@IsRequiredPage OR @IsRequiredPage IS NULL) 
  AND P1.[Level]>1 AND (P1.IsActive=@IsActive OR @IsActive IS NULL) 
  AND (P1.IsVisible=@IsVisible OR @IsVisible IS NULL)  AND P1.DisableLink=0
)


INSERT INTO #Temp
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
      ,[RefreshInterval]
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
   ,CAST([newOrder] AS DECIMAL(38,10)) AS [newOrder] FROM PageOrders
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
      ,[RefreshInterval]
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
   ,(SELECT MAX([PageOrder]) FROM [dbo].[Pages] AS m WHERE m.PageOrder<5000 
 AND (m.IsActive=@IsActive OR @IsActive IS NULL) AND m.IsDeleted=@IsDeleted 
 AND m.PortalID=@PortalID AND ((@IsVisible=0 OR @IsVisible IS NULL) OR (m.[DisableLink]=0 AND m.IsVisible=@IsVisible)) 
 AND m.[Level]=P1.[Level] and  m.ParentID=P1.ParentID) AS [MaxPageOrder]
      ,(SELECT MIN([PageOrder]) FROM [dbo].[Pages] AS m WHERE m.PageOrder<5000 
 AND (m.IsActive=@IsActive OR @IsActive IS NULL) AND m.IsDeleted=@IsDeleted 
 AND m.PortalID=@PortalID AND ((@IsVisible=0 OR @IsVisible IS NULL) OR (m.[DisableLink]=0 AND m.IsVisible=@IsVisible)) 
 AND m.[Level]=P1.[Level] and  m.ParentID=P1.ParentID) AS [MinPageOrder] 
FROM #Temp AS P1 ORDER BY [newOrder]
DROP TABLE #Temp
DROP TABLE #TblPages
END





GO
