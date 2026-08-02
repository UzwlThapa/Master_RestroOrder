SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashboardSidebarDelete]
@SidebarItemID INT
AS
BEGIN
 DELETE FROM [dbo].[DashboardSidebar] WHERE ParentID=@SidebarItemID
 DELETE FROM [dbo].[DashboardSidebar] WHERE SidebarItemID=@SidebarItemID
END





GO
