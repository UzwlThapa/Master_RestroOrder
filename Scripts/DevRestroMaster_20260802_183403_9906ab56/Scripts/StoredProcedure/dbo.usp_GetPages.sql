SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[usp_GetPages] 1,0
CREATE PROCEDURE [dbo].[usp_GetPages] @PortalID INT
 ,@IsAdmin BIT = NULL
AS
--BEGIN 
IF (@IsAdmin = 0)
BEGIN
 SELECT *
  ,pp.PreviewCode
  ,Isnull((
    SELECT MAX([PageOrder])
    FROM [dbo].[Pages]
    WHERE [Level] = p.[Level]
     AND parentid = p.parentid
     AND portalid = @PortalID
    ), p.pageorder) AS [MaxPageOrder]
 FROM pages p
 INNER JOIN pagemenu pm ON p.pageid = pm.pageid
 INNER JOIN PagePreview pp ON pp.PageID = p.PageID
 WHERE pm.portalid = @PortalID
  AND pm.isadmin = @IsAdmin
 ORDER BY --p.pageid, 
  p.PageName
END
ELSE
BEGIN
 BEGIN
  SELECT *
   ,Isnull((
     SELECT MAX([PageOrder])
     FROM [dbo].[Pages]
     WHERE [Level] = p.[Level]
      AND parentid = p.parentid
      AND portalid = @PortalID
     ), p.pageorder) AS [MaxPageOrder]
  FROM pages p
  INNER JOIN pagemenu pm ON p.pageid = pm.pageid
  WHERE pm.portalid = @PortalID
   AND pm.isadmin = @IsAdmin
  ORDER BY --p.pageid, 
   p.PageName
 END
END





GO
