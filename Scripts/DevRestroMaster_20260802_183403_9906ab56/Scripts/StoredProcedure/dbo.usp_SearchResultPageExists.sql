SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SearchResultPageExists] 
(
@PortalID INT,
@PageName NVARCHAR(250)
)
AS
BEGIN
SELECT COUNT(PageName) FROM Pages p INNER JOIN PageMenu pm ON p.PageID=pm.PageID WHERE p.PortalID=@PortalID AND p.SEOName=@PageName
AND pm.IsAdmin=0
END





GO
