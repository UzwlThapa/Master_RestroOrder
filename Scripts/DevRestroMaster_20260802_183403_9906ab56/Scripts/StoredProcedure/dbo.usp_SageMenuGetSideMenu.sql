SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageMenuGetSideMenu] @PortalID    [INT], 
                                                @UserName    [NVARCHAR](256), 
                                                @MenuID      [INT], 
                                                @CultureCode NVARCHAR(10) 
AS 
  BEGIN 
      DECLARE @prefix [NVARCHAR](10) 
      DECLARE @IsActive [BIT] 
      DECLARE @IsDeleted [BIT] 
      DECLARE @IsVisible [BIT] 
      DECLARE @IsRequiredPage BIT 

      --DECLARE @PageID INT   
      SET @prefix='---' 
      SET @IsActive=NULL 
      SET @IsDeleted=0 
      SET @IsVisible=1 
      SET @IsRequiredPage=NULL 

      --Get Highest Parent Page 
      select * 
      Into   #tblTemp 
      from   MenuItem 
      Where  PortalID = @PortalID
             and MenuID = @MenuID 

      ----------------------------- 
      DECLARE @roleid NVARCHAR(100) 

      IF @UserName = 'anonymoususer' 
        BEGIN 
            SET @roleid = (SELECT [RoleId] 
                           FROM   dbo.aspnet_roles 
                           WHERE  loweredrolename = 'anonymous user') 
        END 
      ELSE 
        BEGIN 
            SET @roleid = (SELECT TOP(1) RoleId 
                           FROM   dbo.ASpnet_usersinroles 
                                  INNER JOIN dbo.ASpnet_users 
                                          ON 
                                  dbo.ASpnet_usersinroles.UserId = 
                                  dbo.ASpnet_users.UserId 
                           WHERE  dbo.ASpnet_users.Username = @userName) 
        END 

      SELECT distinct dbo.pagepermission.PageID 
      Into   #tblPages 
      FROM   dbo.pagepermission 
      WHERE  RoleID = @roleid 
             and ( dbo.pagepermission.userName = @userName 
                    or dbo.pagepermission.userName = '' ); 

      with t(menuitemid, PageID, ParentID,MenuOrder) 
           as (select menuitemid, 
                      pageid, 
                      parentid ,MenuOrder
               from   #tblTemp) select t1.PageID, t.MenuOrder AS [newOrder] ,
             case t1.ParentID 
               when 0 then t1.ParentID 
               else t.PageID 
             end                                 as ParentID, 
             t1.menulevel                        as [Level], 
             t1.Title, 
             p.[PageOrder],
             --p.[PageName], 
             ISNULL
        (
         (
          SELECT 
           lp.LocalPageName 
          FROM 
           LocalPage lp 
          WHERE 
            lp.PageID=p.PageID 
           AND lp.CultureCode=@CultureCode
         )
         ,p.PageName
        ) AS PageName,
             ( dbo.fn_LevelPrefix(convert(INT, ISNULL(p.[Level], 0)), @prefix) 
               + p.[PageName] )                  AS [LevelPageName], 
             p.[IsVisible], 
             p.[IconFile], 
             p.[DisableLink], 
             p.[Title], 
             p.[Description], 
             p.[KeyWords], 
             p.[Url], 
             p.[TabPath], 
             p.[StartDate], 
             p.[EndDate], 
             p.[RefreshINTerval], 
             p.[PageHeadText], 
             p.[IsSecure], 
             p.[IsActive], 
             p.[IsDeleted], 
             p.[IsModified], 
             p.[AddedOn], 
             p.[UpdatedOn], 
             p.[DeletedOn], 
             p.[PortalID], 
             p.[AddedBy], 
             p.[UpdatedBy], 
             p.[DeletedBy], 
             p.[SEOName]
      from   t 
             inner join #tblTemp t1 
                     on t1.parentid = t.menuitemid 
             inner join pages p 
                     on p.pageid = t1.pageid 
      union all 
      select t2.PageID, MenuOrder AS [newOrder] ,
             t2.ParentID, 
             t2.menulevel                         as [Level], 
             t2.Title, 
             p1.[PageOrder]
              , ISNULL
        (
         (
          SELECT 
           lp.LocalPageName 
          FROM 
           LocalPage lp 
          WHERE 
            lp.PageID=p1.PageID 
           AND lp.CultureCode=@CultureCode
         )
         ,p1.PageName
        ) AS PageName,
             ( dbo.fn_LevelPrefix(convert(INT, ISNULL(p1.[Level], 0)), @prefix) 
               + p1.[PageName] )                  AS [LevelPageName], 
             p1.[IsVisible], 
             p1.[IconFile], 
             p1.[DisableLink], 
             p1.[Title], 
             p1.[Description], 
             p1.[KeyWords], 
             p1.[Url], 
             p1.[TabPath], 
             p1.[StartDate], 
             p1.[EndDate], 
             p1.[RefreshINTerval], 
             p1.[PageHeadText], 
             p1.[IsSecure], 
             p1.[IsActive], 
             p1.[IsDeleted], 
             p1.[IsModified], 
             p1.[AddedOn], 
             p1.[UpdatedOn], 
             p1.[DeletedOn], 
             p1.[PortalID], 
             p1.[AddedBy], 
             p1.[UpdatedBy], 
             p1.[DeletedBy], 
             p1.[SEOName]
      from   #tblTemp t2 
             inner join pages p1 
                     on p1.pageid = t2.pageid 
      where  t2.parentid = 0 
             AND ( p1.IsDeleted = @IsDeleted 
                    OR @IsDeleted IS NULL ) 
             AND P1.PortalID = @PortalID 
             AND ( p1.IsRequiredPage = @IsRequiredPage 
                    OR @IsRequiredPage IS NULL ) 
             AND p1.ParentID >= 0 
             AND ( p1.IsActive = @IsActive 
                    OR @IsActive IS NULL ) 
             AND ( p1.IsVisible = @IsVisible 
                    OR @IsVisible IS NULL ) 
             AND p1.DisableLink = 0 
      ORDER  BY [newOrder]
      DROP TABLE #tblTemp 
      DROP TABLE #tblPages 
  END





GO
