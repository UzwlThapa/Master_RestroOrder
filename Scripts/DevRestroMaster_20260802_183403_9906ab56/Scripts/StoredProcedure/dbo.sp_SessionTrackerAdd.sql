SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_SessionTrackerAdd]
@SessionUserHostAddress NVARCHAR(500),
@SessionUserAgent NVARCHAR(500),
@SessionBrowser NVARCHAR(500),
@SessionCrawler NVARCHAR(500),
@SessionURL NVARCHAR(500),
@SessionVisitCount INT,
@SessionOriginalReferrer NVARCHAR(500),
@SessionOriginalURL NVARCHAR(500),
@UserName NVARCHAR(256),
@PortalID INT,
@SessionID NVARCHAR(50)
--@InsertedID INT OUTPUT

AS
INSERT INTO [dbo].[SessionTracker]
   (
    [SessionUserHostAddress]
      ,[SessionUserAgent]
      ,[SessionBrowser]
      ,[SessionCrawler]
      ,[SessionURL]
      ,[SessionVisitCount]
      ,[SessionOriginalReferrer]
      ,[SessionOriginalURL]
      ,[Start]
      ,[Username]
      ,[PortalID]
      ,[SessionID]
   )
     VALUES
   (
    @SessionUserHostAddress,
    @SessionUserAgent,
    @SessionBrowser,
    @SessionCrawler,
    @SessionURL,
    @SessionVisitCount,
    @SessionOriginalReferrer,
    @SessionOriginalURL,
    GETDATE(),
    @UserName,
    @PortalID,
    @SessionID
   )





GO
