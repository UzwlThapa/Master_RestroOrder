SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_SessionTrackerPageAdd]
--@SessionTrackerID INT,
@SessionID NVARCHAR(50),
@SessionTrackerPage NVARCHAR(500),
@SessionTrackerTime VARCHAR(8)
--@InsertedID INT OUTPUT
AS
INSERT INTO [dbo].[SessionTrackerPages]
   (
    [SessionID]
      ,[SessionTrackerPage]
      ,[SessionTrackerTime]
   )
  VALUES
   (
    @SessionID
      ,@SessionTrackerPage
      ,@SessionTrackerTime
   )




GO
