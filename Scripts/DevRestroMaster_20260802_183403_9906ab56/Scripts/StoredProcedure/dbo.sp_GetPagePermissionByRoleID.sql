SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetPagePermissionByRoleID]
@PortalID INT,
@RoleID uniqueidentifier
AS
BEGIN

DECLARE @RoleName NVARCHAR(50)
SELECT @RoleName=RoleName FROM dbo.aspnet_Roles WHERE RoleID=@RoleID

;WITH CTE(PageID, PortalID, PageName,ParentID,PageOrder,PageLevel)
as
(
SELECT   P.PageID,
				  P.PortalID,
				  P.PageName,
				  p.ParentID,
				  Row_Number() over (order by p.PageName)*100000,
				  0
	FROM Pages p
	WHERE p.ParentID = 0
	--and (P.PortalID = @PortalID)
	union all 
	SELECT   P.PageID,
				  P.PortalID,
				  P.PageName,
				  p.ParentID,
				  cte.PageOrder + Row_Number() over (order by p.PageName)*10000,
				  cte.PageLevel+1
	FROM Pages p 
	INNER JOIN cte
            ON cte.PageID = p.ParentId
	union all 
	SELECT   P.PageID,
				  P.PortalID,
				  P.PageName,
				  p.ParentID,
				  cte.PageOrder + Row_Number() over (order by p.PageName)*1000,
				  cte.PageLevel+1
	FROM Pages p 
	INNER JOIN cte
            ON cte.PageID = p.ParentId
	where p.Level = 2
	union all 
	SELECT   P.PageID,
				  P.PortalID,
				  P.PageName,
				  p.ParentID,
				  cte.PageOrder + Row_Number() over (order by p.PageName)*100,
				  cte.PageLevel+1
	FROM Pages p 
	INNER JOIN cte
            ON cte.PageID = p.ParentId
	where p.Level = 3
	union all 
	SELECT   P.PageID,
				  P.PortalID,
				  P.PageName,
				  p.ParentID,
				  cte.PageOrder + Row_Number() over (order by p.PageName)*10,
				  cte.PageLevel+1
	FROM Pages p 
	INNER JOIN cte
            ON cte.PageID = p.ParentId
	where p.Level = 4
	union all 
	SELECT   P.PageID,
				  P.PortalID,
				  P.PageName,
				  p.ParentID,
				  cte.PageOrder + Row_Number() over (order by p.PageName)*1,
				  cte.PageLevel+1
	FROM Pages p 
	INNER JOIN cte
            ON cte.PageID = p.ParentId
	where p.Level = 5
)

select p.PageID,
PermissionID = STUFF((SELECT ',' + convert(varchar(30), PermissionID) FROM PagePermission pp WHERE pp.RoleID = @RoleID AND pp.PageID=p.PageID  FOR XML PATH('')), 1, 1, ''),
pp.AllowAccess,
@RoleID as RoleID,
p.PortalID,
pp.Username,
pp.IsActive,
pp.AddedBy,
@RoleName as RoleName,
dbo.fn_LevelPrefix(p.PageLevel,'--')+p.PageName PageName
FROM CTE p
left JOIN PagePermission pp
	ON pp.PageID = p.PageID AND pp.RoleID = @RoleID and pp.PermissionID=1
WHERE P.PortalID = @PortalID
ORDER BY PageOrder

END

GO
