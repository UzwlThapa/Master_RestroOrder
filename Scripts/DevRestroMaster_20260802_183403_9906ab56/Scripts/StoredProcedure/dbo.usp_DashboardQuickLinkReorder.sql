SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashboardQuickLinkReorder]
(
 @QuickLinkID INT,
 @DisplayOrder INT
) 
AS
BEGIN
 SET NOCOUNT ON;
 UPDATE [dbo].[DashboardQuickLinks]
 SET DisplayOrder=@DisplayOrder 
 WHERE QuickLinkID=@QuickLinkID
END





GO
