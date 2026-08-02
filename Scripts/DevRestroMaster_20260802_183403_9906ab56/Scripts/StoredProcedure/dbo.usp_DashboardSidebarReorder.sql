SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashboardSidebarReorder]
(
 @SidebarItemID INT,
 @DisplayOrder  INT
) 
AS
BEGIN
SET NOCOUNT ON;
 UPDATE [dbo].[DashboardSidebar]
  SET DisplayOrder=@DisplayOrder 
  WHERE SidebarItemID=@SidebarItemID
END





GO
