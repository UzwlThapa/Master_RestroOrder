SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ScheduleRepeatOptionsDelete]
@ScheduleID INT
AS
BEGIN
DELETE FROM dbo.ScheduleDate WHERE ScheduleID=@ScheduleID
DELETE FROM dbo.ScheduleDay  WHERE ScheduleID=@ScheduleID
DELETE FROM dbo.ScheduleMonth  WHERE ScheduleID=@ScheduleID  
DELETE FROM dbo.ScheduleWeek  WHERE ScheduleID=@ScheduleID
END





GO
