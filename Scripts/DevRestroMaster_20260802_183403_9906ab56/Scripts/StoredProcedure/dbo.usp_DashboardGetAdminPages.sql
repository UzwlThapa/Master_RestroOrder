SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashboardGetAdminPages]
(
@PortalID INT
)
AS
BEGIN
 SELECT distinct p.PageID,p.PageName,p.TabPath FROM PageMenu pm
 INNER JOIN Pages p ON pm.PageID=p.PageID WHERE IsAdmin=1
 AND p.PortalID=@PortalID OR p.PortalID=-1 AND (IsDeleted=0 OR IsDeleted IS NULL)
END





GO
