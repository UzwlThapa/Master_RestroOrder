SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ScheduleDeleteTask]
(
@ScheduleID INT
)
AS
BEGIN
SET NOCOUNT ON;
DELETE FROM ScheduleWeek WHERE  ScheduleID=@ScheduleID
DELETE FROM ScheduleDay WHERE  ScheduleID=@ScheduleID
DELETE FROM ScheduleDate WHERE  ScheduleID=@ScheduleID
DELETE FROM ScheduleMonth WHERE  ScheduleID=@ScheduleID
DELETE FROM ScheduleHistory WHERE  ScheduleID=@ScheduleID
DELETE FROM Schedule WHERE ScheduleID=@ScheduleID
END;





GO
