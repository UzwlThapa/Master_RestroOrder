SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ScheduleDateAdd]
@ScheduleID INT,
@Dates NVARCHAR(50)
AS
BEGIN
INSERT INTO dbo.ScheduleDate(ScheduleID, Schedule_Date)
SELECT @ScheduleID, items FROM dbo.split(@Dates,',') 
END





GO
