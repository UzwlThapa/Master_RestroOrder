SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashboardSidebarGetDetails]
@SidebarItemID INT
AS 
BEGIN
 SELECT * from DashboardSidebar WHERE SidebarItemID=@SidebarItemID
END





GO
