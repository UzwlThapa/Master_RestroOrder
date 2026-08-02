SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ScheduleHistoryRetrieve]
(
 @ScheduleID INT 
)
AS
BEGIN

DECLARE @ScheduleHistoryID INT
SELECT @ScheduleHistoryID=MAX(ScheduleHistoryID) FROM dbo.ScheduleHistory WHERE ScheduleID=@ScheduleID
  
IF(@ScheduleHistoryID IS NOT NULL)
BEGIN
 SELECT 
    h.[ScheduleHistoryID]
    ,h.[ScheduleID]      
    ,h.[StartDate]
    ,h.[EndDate]
    ,h.[Status]
    ,h.[ReturnText]
    ,h.[NextStart]
    ,h.[Server]
    ,s.RunningMode
   ,s.EveryHours
   ,s.EveryMin 
   ,s.StartMin
   ,s.StartHour
  ,s.StartDate
  ,s.RepeatWeeks
  ,s.RepeatDays
   FROM [dbo].[ScheduleHistory] h INNER JOIN dbo.Schedule s
  on s.ScheduleID=h.ScheduleID
 WHERE ScheduleHistoryID=@ScheduleHistoryID
END
END;





GO
