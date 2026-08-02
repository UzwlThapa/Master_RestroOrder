SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_usermodulesgetpagemodules] 
(@IsAdmin BIT) 
AS
BEGIN
 SELECT
  p.PageName,
  um.UserModuleTitle,
  um.UserModuleId
 FROM
  PageModules pm
 INNER JOIN UserModules um ON pm.UserModuleid = um.UserModuleId
 INNER JOIN Pages p ON pm.PageId = p.PageId
 INNER JOIN PageMenu pmenu ON p.PageId = pmenu.PageId
 WHERE
  pmenu.IsAdmin = @IsAdmin
 AND (
  um.IsDeleted IS NULL
  OR um.IsDeleted = 0
 )
 GROUP BY
  p.PageName,
  um.UserModuleTitle,
  um.UserModuleId
 ORDER BY
  p.Pagename ASC
 END





GO
