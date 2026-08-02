SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageBannerGetAllPagesOfSageFrame] 
@PortalID INT 
AS
BEGIN
 SELECT p.TabPath,p.SEOName AS PageName FROM Pages p INNER JOIN 
 PageMenu pm ON p.PageID=pm.PageID WHERE IsDeleted=0 AND (pm.IsAdmin=0 OR pm.IsAdmin IS NULL OR p.ParentID>0 )
 AND p.PortalID=@PortalID AND pm.IsAdmin=0
END





GO
