SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_SessionTrackerUpdateUsername]
 --@SessionTrackerID INT,
 @SessionID NVARCHAR(50),
 @UserName NVARCHAR(256),
 @PortalID INT
AS 
UPDATE 
 [dbo].[SessionTracker] 
SET 
 [Username]=@UserName,
 PortalID=@PortalID 
WHERE 
 --SessionTrackerID=@SessionTrackerID
 SessionID=@SessionID




GO
