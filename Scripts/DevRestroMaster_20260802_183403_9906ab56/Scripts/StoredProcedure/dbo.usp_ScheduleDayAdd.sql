SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ScheduleDayAdd]
@ScheduleID INT,
@DayIds  NVARCHAR(50)
AS
BEGIN
 INSERT INTO ScheduleDay(ScheduleID,DayID)
 SELECT @ScheduleID, items FROM dbo.split(@DayIds,',')
END





GO
