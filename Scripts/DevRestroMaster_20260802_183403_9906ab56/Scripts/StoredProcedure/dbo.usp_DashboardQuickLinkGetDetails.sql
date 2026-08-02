SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashboardQuickLinkGetDetails]
 @QuickLinkItemID INT
AS
BEGIN
 select * FROM DashboardQuickLinks WHERE QuickLinkID=@QuickLinkItemID
END





GO
