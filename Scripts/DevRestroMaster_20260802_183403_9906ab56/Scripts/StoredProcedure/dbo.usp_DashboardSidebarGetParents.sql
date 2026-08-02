SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashboardSidebarGetParents]

(

@SidebarItemID INT

)

AS

BEGIN

 SELECT * FROM  DashboardSidebar WHERE( Depth=0 OR Depth=1) AND SidebarItemID!=@SidebarItemID

END





GO
