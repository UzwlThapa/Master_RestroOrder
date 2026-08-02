SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ScheduleDateGetNextCalendarDate] 
@ScheduleID INT,
@CurrentCalendarDate NVARCHAR(10)
AS 
BEGIN
SELECT Min(Schedule_Date) AS ScheduleDate FROM ScheduleDate WHERE Schedule_Date>CONVERT(DATETIME,@CurrentCalendarDate,101) AND ScheduleID=@ScheduleID
END





GO
