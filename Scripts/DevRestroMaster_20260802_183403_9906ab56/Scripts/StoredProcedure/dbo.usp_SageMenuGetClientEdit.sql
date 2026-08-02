SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageMenuGetClientEdit] 
AS
BEGIN
    DECLARE @prefix [NVARCHAR](10)
 DECLARE @IsActive [BIT]
 DECLARE @IsDeleted [BIT]
 DECLARE @PortalID [INT]
 DECLARE @UserName [NVARCHAR](256)
 DECLARE @IsVisible [BIT]
 DECLARE @IsRequiredPage BIT
 SET @prefix='---'
 SET @IsActive=null
 SET @IsDeleted=0
 SET @PortalID=1
 SET @UserName='superuser'
 SET @IsVisible=1
 SET @IsRequiredPage=NULL
SELECT DISTINCT dbo.pagepermission.PageID INTO #tblPages FROM dbo.pagepermission 
WHERE RoleID IN (SELECT RoleId FROM dbo.aspnet_usersinroles INNER JOIN dbo.aspnet_users ON dbo.aspnet_usersinroles.UserId=dbo.aspnet_users.UserId
     WHERE dbo.aspnet_users.Username=@UserName) ;
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
 INNER JOIN PageMenu pm on P1.PageID=pm.PageID
 WHERE (P1.IsDeleted=@IsDeleted OR @IsDeleted IS NULL) AND P1.PortalID=@PortalID AND (P1.IsRequiredPage=@IsRequiredPage OR @IsRequiredPage IS NULL) 
   AND P1.ParentID=0 AND (P1.IsActive=@IsActive OR @IsActive IS NULL) AND (P1.IsVisible=@IsVisible OR @IsVisible IS NULL) AND P1.DisableLink=0
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
   ,CAST([newOrder] AS VARCHAR(10))+'.'+ CAST(RIGHT('00'+CAST(P1.[PageOrder] AS VARCHAR(2)),2) AS VARCHAR(89))  AS [newOrder]
  ,pm.ShowInMenu
 FROM [dbo].[Pages] AS P1
 INNER JOIN #tblPages ON #tblPages.pageid=P1.PageID
  INNER JOIN PageOrders AS po
        ON po.[PageID] = p1.[ParentID]
 INNER JOIN PageMenu pm on P1.PageID=pm.PageID
 WHERE (P1.IsDeleted=@IsDeleted OR @IsDeleted IS NULL) AND P1.PortalID=@PortalID AND (P1.IsRequiredPage=@IsRequiredPage OR @IsRequiredPage IS NULL) 
  AND P1.[Level]=1 AND (P1.IsActive=@IsActive OR @IsActive IS NULL) AND (P1.IsVisible=@IsVisible OR @IsVisible IS NULL) AND P1.DisableLink=0
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
  ,pm.ShowInMenu
 FROM [dbo].[Pages] AS P1
 INNER JOIN #tblPages ON #tblPages.pageid=P1.PageID
  INNER JOIN PageOrders AS po
        ON po.[PageID] = p1.[ParentID]
INNER JOIN PageMenu pm ON P1.PageID=pm.PageID
 WHERE (P1.IsDeleted=@IsDeleted OR @IsDeleted IS NULL) AND P1.PortalID=@PortalID AND (P1.IsRequiredPage=@IsRequiredPage OR @IsRequiredPage IS NULL) 
  AND P1.[Level]>1 AND (P1.IsActive=@IsActive OR @IsActive IS NULL) AND (P1.IsVisible=@IsVisible OR @IsVisible IS NULL)  AND P1.DisableLink=0
)
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
   ,Cast([newOrder] AS DECIMAL(38,10)) AS [newOrder],[ShowInMenu] INTO #TEMP FROM PageOrders
 
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
      ,[SEOName]
  ,[ShowInMenu]
   ,(SELECT MAX([PageOrder]) FROM [dbo].[Pages] AS m WHERE m.PageOrder<5000 AND (m.IsActive=@IsActive OR @IsActive IS NULL) AND m.IsDeleted=@IsDeleted 
  AND m.PortalID=@PortalID AND ((@IsVisible=0 OR @IsVisible IS NULL) OR (m.[DisableLink]=0 AND m.IsVisible=@IsVisible)) 
  AND m.[Level]=P1.[Level] and  m.ParentID=P1.ParentID) as [MaxPageOrder]
      ,(SELECT MIN([PageOrder]) FROM [dbo].[Pages] AS m WHERE m.PageOrder<5000 AND (m.IsActive=@IsActive OR @IsActive IS NULL) AND m.IsDeleted=@IsDeleted 
  AND m.PortalID=@PortalID AND ((@IsVisible=0 OR @IsVisible IS NULL) OR (m.[DisableLink]=0 AND m.IsVisible=@IsVisible)) 
  AND m.[Level]=P1.[Level] and  m.ParentID=P1.ParentID) as [MinPageOrder] 

  FROM #TEMP AS P1 ORDER BY [newOrder]
DROP TABLE #TEMP
DROP TABLE #tblPages
END





GO
