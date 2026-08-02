SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SEOGetPages]
AS 
BEGIN
SELECT p.SEOName AS PageName,p.TabPath,pr.SEOName AS PortalName,p.PortalID,p.UpdatedOn,p.AddedOn FROM Pages p 
INNER JOIN PageMenu pm ON p.pageid=pm.pageid
INNER JOIN Portal pr ON pm.PortalID=pr.PortalID AND pm.isadmin=0
END





GO
