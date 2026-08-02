SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_SessionTrackerUpdateEND]
--@SessionTrackerID INT,
@SessionID NVARCHAR(50),
@PortalID INT
AS 
UPDATE 
 [dbo].[SessionTracker] 
SET 
 [END]=GETDATE(),
 PortalID=@PortalID 
WHERE 
 --SessionTrackerID=@SessionTrackerID
 SessionID=@SessionID




GO
