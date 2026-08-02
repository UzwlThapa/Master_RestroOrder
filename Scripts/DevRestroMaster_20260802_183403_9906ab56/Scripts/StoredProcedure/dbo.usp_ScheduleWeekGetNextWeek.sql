SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ScheduleWeekGetNextWeek]
@ScheduleId INT,
@CurrentWeeknum INT

AS 
BEGIN
DECLARE @LargeWeeknum INT
SELECT  @LargeWeeknum =MAX(WeekDayID) FROM ScheduleWeek WHERE ScheduleID=@ScheduleId

IF @LargeWeeknum >0
BEGIN
   if @CurrentWeeknum>=@LargeWeeknum
  BEGIN   
   SELECT MIN(WeekDayID) AS weekDay FROM ScheduleWeek WHERE ScheduleID=@ScheduleId
   END
   ELSE IF @CurrentWeeknum<@LargeWeeknum
   BEGIN
          SELECT MIN(WeekDayID) AS weekDay FROM ScheduleWeek WHERE  WeekDayID>@CurrentWeeknum AND 
                ScheduleID=@ScheduleId
   END
END 
END





GO
