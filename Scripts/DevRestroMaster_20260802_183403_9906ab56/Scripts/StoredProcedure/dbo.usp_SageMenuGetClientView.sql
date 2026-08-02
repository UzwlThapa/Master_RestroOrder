SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageMenuGetClientView] 
 
  --   @prefix [nvarchar](10), 
 -- @IsDeleted [bit],
  @PortalID [int]
  --,
 -- @UserName [nvarchar](256),
  --   @CultureCode nVARCHAR(20)
 
AS
BEGIN
 SELECT p.PageID,PageOrder,ParentID,
  [Level],SEOName,TabPath,IsVisible
  ,ShowInMenu,IconFile,
  PageName as LevelPageName,
  ISNULL((SELECT MAX([PageOrder]) FROM [dbo].[Pages]  WHERE [Level]=p.[Level] AND ParentID=p.ParentID AND PortalID=@PortalID )
  ,p.PageOrder) AS [MaxPageOrder]
 FROM dbo.Pages p 
   INNER JOIN dbo.PageMenu pm ON p.PageID=pm.PageID 
 WHERE pm.PortalID=@PortalID AND pm.IsAdmin=0 ORDER BY p.PageID,p.PageOrder
END





GO
