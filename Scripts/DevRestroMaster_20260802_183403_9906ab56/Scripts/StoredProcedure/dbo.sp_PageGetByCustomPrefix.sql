SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED BY: Dinesh Hona
--Modified BY: Dinesh Hona
--Modified DAte: 2010-04-13,2010-05-7,2010-07-19
CREATE PROCEDURE [dbo].[sp_PageGetByCustomPrefix]
 @prefix [nvarchar](10),
 @IsActive [bit],
 @IsDeleted [bit],
 @PortalID [int],
 @UserName [nvarchar](256),
 @IsVisible [bit],
 @IsRequiredPage bit
WITH EXECUTE AS CALLER
AS
BEGIN
select distinct dbo.pagepermission.PageID INTO #tblPages from dbo.pagepermission 
WHERE RoleID in (Select RoleId from dbo.aspnet_usersinroles INNER JOIN dbo.aspnet_users ON dbo.aspnet_usersinroles.UserId=dbo.aspnet_users.UserId WHERE dbo.aspnet_users.Username=@UserName) ;
with PageOrders([PageID]
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
      ,(dbo.fn_LevelPrefix(convert(int,ISnull(P1.[Level],0)),@prefix) + P1.[PageName]) AS [LevelPageName]
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
   ,CAST(P1.[PageOrder] as varchar(100)) as [newOrder]
 FROM [dbo].[Pages] AS P1 
 INNER JOIN #tblPages ON #tblPages.pageid=P1.PageID
 where (P1.IsDeleted=@IsDeleted OR @IsDeleted IS NULL) AND P1.PortalID=@PortalID AND (P1.IsRequiredPage=@IsRequiredPage OR @IsRequiredPage IS NULL) AND P1.ParentID=0 AND (P1.IsActive=@IsActive OR @IsActive IS NULL) AND (P1.IsVisible=@IsVisible OR @IsVisible IS NULL) AND P1.DisableLink=0
 UNION ALL
 SELECT P1.[PageID]
      ,P1.[PageOrder]
   ,P1.[PageName]
      ,(dbo.fn_LevelPrefix(convert(int,ISnull(P1.[Level],0)),@prefix) + P1.[PageName]) AS [LevelPageName]
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
   ,CAST([newOrder] as varchar(10))+'.'+ CAST(Right('00'+CAST(P1.[PageOrder] as varchar(2)),2) as varchar(89))  as [newOrder]
 FROM [dbo].[Pages] AS P1
 INNER JOIN #tblPages ON #tblPages.pageid=P1.PageID
  INNER JOIN PageOrders AS po
        ON po.[PageID] = p1.[ParentID]
 WHERE (P1.IsDeleted=@IsDeleted OR @IsDeleted IS NULL) AND P1.PortalID=@PortalID AND (P1.IsRequiredPage=@IsRequiredPage OR @IsRequiredPage IS NULL) AND P1.[Level]=1 AND (P1.IsActive=@IsActive OR @IsActive IS NULL) AND (P1.IsVisible=@IsVisible OR @IsVisible IS NULL) AND P1.DisableLink=0
 UNION ALL
 SELECT P1.[PageID]
      ,P1.[PageOrder]
   ,P1.[PageName]
      ,(dbo.fn_LevelPrefix(convert(int,ISnull(P1.[Level],0)),@prefix) + P1.[PageName]) AS [LevelPageName]
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
   ,CAST([newOrder] as varchar(10))+CAST(Right('00'+CAST(P1.[PageOrder] as varchar(2)),2) as varchar(90))  as [newOrder]
 FROM [dbo].[Pages] AS P1
 INNER JOIN #tblPages ON #tblPages.pageid=P1.PageID
  INNER JOIN PageOrders AS po
        ON po.[PageID] = p1.[ParentID]
 WHERE (P1.IsDeleted=@IsDeleted OR @IsDeleted IS NULL) AND P1.PortalID=@PortalID AND (P1.IsRequiredPage=@IsRequiredPage OR @IsRequiredPage IS NULL) AND P1.[Level]>1 AND (P1.IsActive=@IsActive OR @IsActive IS NULL) AND (P1.IsVisible=@IsVisible OR @IsVisible IS NULL)  AND P1.DisableLink=0
)
select [PageID]
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
   ,Cast([newOrder] as DECIMAL(38,10)) as [newOrder] INTO #TEMP from PageOrders
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
   ,(SELECT MAX([PageOrder]) FROM [dbo].[Pages] as m WHERE m.PageOrder<5000 AND (m.IsActive=@IsActive OR @IsActive IS NULL) AND m.IsDeleted=@IsDeleted AND m.PortalID=@PortalID AND ((@IsVisible=0 OR @IsVisible IS NULL) OR (m.[DisableLink]=0 AND m.IsVisible=@IsVisible)) 
AND m.[Level]=P1.[Level] and  m.ParentID=P1.ParentID) as [MaxPageOrder]
      ,(SELECT MIN([PageOrder]) FROM [dbo].[Pages] as m WHERE m.PageOrder<5000 AND (m.IsActive=@IsActive OR @IsActive IS NULL) AND m.IsDeleted=@IsDeleted AND m.PortalID=@PortalID AND ((@IsVisible=0 OR @IsVisible IS NULL) OR (m.[DisableLink]=0 AND m.IsVisible=@IsVisible)) 
AND m.[Level]=P1.[Level] and  m.ParentID=P1.ParentID) as [MinPageOrder] 
FROM #TEMP AS P1 ORDER BY [newOrder]
DROP TABLE #TEMP
DROP TABLE #tblPages
END





GO
