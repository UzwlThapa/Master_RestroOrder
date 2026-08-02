SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashBoardPageModuleStatistics] --1,0
(
 @PortalID INT,
 @IsAdmin BIT=NULL
)
AS
BEGIN
 DECLARE @Tbltemp TABLE ( 
    [Users] NVARCHAR(256), 
    cnt     INT 
   ) 

 INSERT INTO @Tbltemp 
 SELECT 'AnonymousUser', 
     COUNT(*) 
   FROM   SessionTracker 
   WHERE  username = 'anonymoususer' 
   AND [end] IS NULL 
 UNION ALL 
 SELECT 'LoginUser', 
     COUNT(*) 
   FROM   SessionTracker 
   WHERE  username NOT IN ( 'anonymoususer' ) 
   AND [end] IS NULL
 UNION ALL 
 SELECT 'PageCount', 
    count(*)
    FROM   Pages p 
        INNER JOIN pagemenu pm 
       ON p.pageid = pm.pageid 
    WHERE  pm.portalid = @PortalID 
        AND pm.isadmin = 0   
 AND (p.IsDeleted=0 OR p.IsDeleted IS NULL)
      and p.IsVisible=1        
 UNION ALL 
 SELECT 'UserCount', 
   Count(*) from [dbo].[vw_portalusers]
    WHERE portalid=@portalid or UserId in (SELECT au.UserId  FROM PortalUser P1 INNER JOIN aspnet_usersinroles au
ON P1.UserID=AU.UserId INNER JOIN aspnet_roles AR ON AR.RoleId=AU.RoleId AND AR.RoleName='Super User' AND p1.IsActive=1 AND (p1.IsDeleted =0 OR p1.ISDeleted IS NULL ))
     
 SELECT * 
 FROM  (SELECT cnt, [Users]     
   FROM   @Tbltemp)p PIVOT ( MAX(cnt) FOR [Users]
    IN ([AnonymousUser],[LoginUser],[PageCount],[UserCount]) ) AS pivottable 
END





GO
