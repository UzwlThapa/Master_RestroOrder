SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ScheduleHistoryUpdate]
(
 @ScheduleID INT,
 @ScheduleHistoryID INT,
 @StartDate DATETIME,
 @EndDate DATETIME,
 @Status BIT,
 @ReturnText NTEXT,
 @NextStart DATETIME,
 @Server NVARCHAR(150)
)
AS
BEGIN
SET NOCOUNT ON;
UPDATE ScheduleHistory
SET ScheduleID=@ScheduleID,
  StartDate=@StartDate,
  EndDate=@EndDate,
  Status=@Status,
  ReturnText=@ReturnText,
  NextStart=@NextStart
WHERE ScheduleHistoryID=@ScheduleHistoryID
END;





GO
