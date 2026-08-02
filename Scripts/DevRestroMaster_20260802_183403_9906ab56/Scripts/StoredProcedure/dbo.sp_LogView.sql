SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  
-- Create date: 2010-04-10
-- Description: HLog Viewer module
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_LogView] 
   @PortalID INT,
   @LogType NVARCHAR(256)   
AS
BEGIN
IF(@LogType='')
 BEGIN
  SELECT     dbo.LogType.[LogTypeID],dbo.LogType.[Name] AS LogTypeName, dbo.[Log].LogID, dbo.[Log].ClientIPAddress, dbo.[Log].AddedOn, dbo.[Log].Exception, dbo.[log].PageURL, dbo.Portal.[Name] AS PortalName 
   FROM         dbo.Portal INNER JOIN
        dbo.[Log] ON dbo.Portal.PortalID = dbo.[Log].PortalID INNER JOIN
        dbo.LogType ON dbo.[Log].LogTypeID = dbo.LogType.LogTypeID
        Where dbo.Portal.PortalID = @PortalID AND ([IsDeleted]=0 OR [IsDeleted] IS NULL) AND IsActive = 1 ORDER BY [dbo].[Log].AddedOn DESC
   END
  ELSE
   BEGIN
    SELECT     dbo.LogType.[LogTypeID],dbo.LogType.[Name] AS LogTypeName, dbo.[Log].LogID, dbo.[Log].ClientIPAddress, dbo.[Log].AddedOn, dbo.[Log].Exception, dbo.[log].PageURL, dbo.Portal.[Name] AS PortalName 
   FROM         dbo.Portal INNER JOIN
        dbo.[Log] ON dbo.Portal.PortalID = dbo.[Log].PortalID INNER JOIN
        dbo.LogType ON dbo.[Log].LogTypeID = dbo.LogType.LogTypeID
        Where dbo.Portal.PortalID = @PortalID AND dbo.LogType.[Name]=@LogType AND ([IsDeleted]=0 OR [IsDeleted] IS NULL) AND IsActive = 1 ORDER BY [dbo].[Log].AddedOn DESC 
   END
END





GO
