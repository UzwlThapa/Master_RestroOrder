SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashboardQuickLinkDelete]
 @QuickLinkID INT 
AS
BEGIN
 SET NOCOUNT ON;
 DELETE FROM [dbo].[DashboardQuickLinks] WHERE QuickLinkID=@QuickLinkID
END





GO
