SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_DashBoardView] @PageSEOName NVARCHAR(256),
                                         @UserName    [NVARCHAR](256),
                                         @PortalID    INT
AS
  BEGIN
      DECLARE @RoleId UNIQUEIDENTIFIER
SET @RoleId=(
      --changed by sushil
      select Top 1 ar.RoleId from aspnet_Roles ar inner join
   aspnet_UsersInRoles ur on ar.RoleId=ur.RoleId
   inner join PortalUser pu on pu.UserID=ur.UserId
     where Username=@UserName and PortalID=@PortalID --and (ar.RoleName='Super User' or ar.RoleName='site admin')
      )

      DECLARE @roleName NVARCHAR(256)

      SET @roleName=(SELECT rolename
                     FROM   aspnet_roles
                     WHERE  roleid = @RoleId)

      DECLARE @PortalSEOName   NVARCHAR(200),
              @IsParentPortal  BIT,
              @UseFriendlyUrls NVARCHAR(256),
              @PortalPrefix    NVARCHAR(200)

      SELECT @PortalSEOName = Ltrim(Rtrim(seoname)),
             @IsParentPortal = isparent
      FROM   dbo.portal
      WHERE  portalid = @PortalID

      SET @PortalPrefix=''

      IF( NOT( @IsParentPortal = 1 ) )
        BEGIN
            SET @PortalPrefix='/portal/' + @PortalSEOName
        END

      DECLARE @IsInRole INT

      SELECT @IsInRole = dbo.Fn_isuserinrole(@UserName, 'Super User', @PortalID)

      IF @IsInRole = 1
          OR @roleName = 'Super User'
        BEGIN
            SELECT P1.pageid,
                   P1.pageorder,
                   P1.pagename,
                   P1.isvisible,
                   P1.parentid,
                   P1.[level],
                   P1.iconfile,
                   P1.title,
                   P1.[description],
                   P1.keywords,
                   '~' + @PortalPrefix + P1.tabpath AS Url,
                   P1.tabpath,
				   p1.DasboardGroup
            FROM   [dbo].[pages] AS P1
                   INNER JOIN [dbo].[pages] AS P2
                           ON P1.parentid = P2.pageid
            WHERE  P2.seoname = @PageSEOName
                   AND ( ( P1.[isdeleted] = 0
                            OR P1.[isdeleted] IS NULL )
                         AND ( P1.portalid = @PortalID
                                OR P1.portalid = -1 )
                         AND P1.isvisible = 1 )
            UNION
            SELECT P1.pageid,
                   P1.pageorder,
                   P1.pagename,
                   P1.isvisible,
                   P1.parentid,
                   P1.[level],
                   P1.iconfile,
                   P1.title,
                   P1.[description],
                   P1.keywords,
                   '~' + @PortalPrefix + P1.tabpath AS Url,
                   P1.tabpath,
				   p1.DasboardGroup
            FROM   [dbo].[pages] AS P1
                   INNER JOIN [dbo].[pages] AS P2
                           ON P1.parentid = P2.pageid
            WHERE  P2.seoname = 'super-user'
                   AND ( ( P1.[isdeleted] = 0
                            OR P1.[isdeleted] IS NULL )
                         AND ( P1.portalid = @PortalID
                                OR P1.portalid = -1 )
                         AND P1.isvisible = 1 )
            ORDER  BY p1.pageorder
        END
      ELSE
        BEGIN
            SELECT DISTINCT P1.pageid,
                   P1.pageorder,
                   P1.pagename,
                   P1.isvisible,
                   P1.parentid,
                   P1.[level],
                   P1.iconfile,
                   P1.title,
                   P1.[description],
                   P1.keywords,
                   '~' + @PortalPrefix + P1.tabpath AS Url,
                   P1.tabpath,
				   p1.DasboardGroup
            FROM   [dbo].[pages] AS P1
                   INNER JOIN [dbo].[pages] AS P2
                           ON P1.parentid = P2.pageid
                   INNER JOIN dbo.pagepermission pp
                           ON P1.pageid = pp.pageid
              AND pp.roleid = @RoleId
                              AND permissionid = 1
            WHERE  P2.seoname = @PageSEOName
                   AND ( ( P1.[isdeleted] = 0
                            OR P1.[isdeleted] IS NULL )
                         AND ( P1.portalid = @PortalID
                                OR P1.portalid = -1 )
                         AND P1.isvisible = 1 )
            ORDER  BY P1.pageorder
        END
  END






GO
