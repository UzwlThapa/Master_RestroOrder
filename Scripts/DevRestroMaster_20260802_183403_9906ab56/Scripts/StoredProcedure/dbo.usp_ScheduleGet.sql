SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ScheduleGet]
@ScheduleID INT
AS
BEGIN
SELECT s.[ScheduleID],s.[ScheduleName],s.[FullNamespace],s.[StartDate],s.[EndDate],s.[StartHour],s.[StartMin],s.[RepeatWeeks]
      ,s.[RepeatDays],s.[WeekOfMonth],s.[EveryHours],s.[EveryMin] ,s.[ObjectDependencies],s.[RetryTimeLapse],s.[RetryFrequencyUnit]
      ,s.[AttachToEvent] ,s.[CatchUpEnabled],s.[Servers],s.[CreatedByUserID],s.[CreatedOnDate],s.[LastModifiedbyUserID],s.[LastModifiedDate]
   ,s.[IsEnable],s.[AssemblyFileName],RunningMode FROM [dbo].[Schedule] s 
WHERE s.ScheduleID=@ScheduleID
END;





GO
