SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ScheduleWeekAdd]
@ScheduleID INT,
@Weeks NVARCHAR(50)
AS
BEGIN
 INSERT INTO dbo.ScheduleWeek(ScheduleID, WeekDayID)          
 SELECT @ScheduleID, items FROM dbo.split(@Weeks,',')
END





GO
