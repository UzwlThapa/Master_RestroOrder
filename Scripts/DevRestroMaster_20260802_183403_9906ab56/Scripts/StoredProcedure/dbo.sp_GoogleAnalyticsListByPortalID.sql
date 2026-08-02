SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GoogleAnalyticsListByPortalID]
 @PortalID INT
AS
SELECT
 [GoogleAnalyticsID],
 [GoogleJSCode],
 [IsActive],
 [IsModified],
 [AddedOn],
 [UpdatedOn],
 [PortalID],
 [AddedBy],
 [UpdatedBy]
FROM [dbo].[GoogleAnalytics]
WHERE
 PortalID = @PortalID





GO
