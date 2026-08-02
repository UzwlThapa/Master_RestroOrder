SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SchedulesGetCurrent]
AS
BEGIN
SELECT 
s.[ScheduleID]
      ,s.[ScheduleName]
      ,s.[FullNamespace]
      ,s.[StartDate]
      ,s.[EndDate]
      ,s.[StartHour]
      ,s.[StartMin]
      ,s.[RepeatWeeks]
      ,s.[RepeatDAYs]
      ,s.[WeekOfMonth]
      ,s.[EveryHours]
      ,s.[EveryMin]
      ,s.[ObjectDependencies]
      ,s.[RetryTimeLapse]
      ,s.[RetryFrequencyUnit]
      ,s.[AttachToEvent]
      ,s.[CatchUpEnabled]
      ,s.[Servers]
      ,s.[CreatedByUserID]
      ,s.[CreatedOnDate]
      ,s.[LAStModifiedbyUserID]
      ,s.[LAStModifiedDate]
,s.RunningMode
,s.[IsEnable]
,
  MAX(v.ScheduleHistoryID)AS ScheduleHistoryID
      ,MAX(v.NextStart) AS NextStart
,MAX(v.StartDate) AS HistoryStartDate,
MAX(v.EndDate) AS HistoryEndDate
  FROM [dbo].[Schedule] s LEFT JOIN  [dbo].[ScheduleHistory] v ON s.ScheduleID=v.ScheduleID
 WHERE  s.[ScheduleID] IN(
 SELECT ss.[ScheduleID]
 FROM Schedule ss 
  INNER JOIN ScheduleHistory h ON ss.ScheduleId = h.ScheduleId
 WHERE ss.RunningMode = 0
  AND GETDATE() BETWEEN DATEADD(Hour, ss.StartHour, DATEADD(minute, ss.StartMin, ss.StartDate)) AND COALESCE(ss.EndDate,'12/12/2090') 
  AND (h.NextStart IS NULL OR DATEDIFF(minute, h.NextStart, GETDATE()) >= (EveryHours*60) + EveryMin)

UNION ALL
 
 SELECT ss.[ScheduleID]
 FROM Schedule ss 
  INNER JOIN ScheduleHistory h ON ss.ScheduleId = h.ScheduleId
 WHERE ss.RunningMode  = 1
  AND GETDATE() BETWEEN ss.StartDate AND COALESCE(ss.EndDate,'12/12/2078') 
  AND (h.EndDate IS NULL OR   ss.RepeatDAYs<DATEDIFF(DAY, h.EndDate, GETDATE()))
  AND (ss.StartHour*60) + ss.StartMin = (DATEPART(hour,GETDATE())*60) + DATEPART(minute,GETDATE())
 
 UNION ALL
 
 SELECT ss.[ScheduleID]
 FROM Schedule ss 
  INNER JOIN ScheduleHistory h ON ss.ScheduleId = h.ScheduleId
  INNER JOIN ScheduleWeek w ON w.ScheduleId = h.ScheduleId
 WHERE ss.RunningMode=2
  AND GETDATE() BETWEEN ss.StartDate AND COALESCE(ss.EndDate,'12/12/2078') 
  AND DATEPART (weekDAY , GETDATE()) = w.WeekDAYId
  AND ((ss.StartHour*60) + ss.StartMin) <= (DATEPART(hour,GETDATE())*60) + DATEPART(minute,GETDATE()) 
  AND (h.NextStart IS NULL OR DATEDIFF(DAY,h.NextStart, GETDATE()) > 0) --weekly
 
 UNION ALL
 
 
 SELECT ss.[ScheduleID]
 FROM Schedule ss 
  INNER JOIN ScheduleHistory h ON ss.ScheduleId = h.ScheduleId
  INNER JOIN ScheduleWeek w ON w.ScheduleId = h.ScheduleId
  INNER JOIN ScheduleMonth m ON m.ScheduleId = h.ScheduleId
 WHERE ss.RunningMode =3
  AND GETDATE() BETWEEN s.StartDate AND COALESCE(s.EndDate,'12/12/2078') 
  AND w.WeekDAYId = DATEPART (weekDAY , GETDATE())
  AND m.MonthId = DATEPART (month , GETDATE())
  AND ss.WeekOfMonth = (DATEPART(ww,GETDATE())) + 1 - DATEPART(ww,DATEADD(dd,-(DATEPART(dd,GETDATE())-1),GETDATE()))
  AND ((ss.StartHour*60) + ss.StartMin) <= (DATEPART(hour,GETDATE())*60) + DATEPART(minute,GETDATE()) 
  AND (h.NextStart IS NULL OR DATEDIFF(DAY, h.NextStart, GETDATE()) > 0) -- weeknumber
 UNION ALL
 
 SELECT ss.[ScheduleID]
 FROM Schedule ss 
  INNER JOIN ScheduleHistory h ON ss.ScheduleId = h.ScheduleId
  INNER JOIN ScheduleDate m ON m.ScheduleId = h.ScheduleId
  
 WHERE ss.RunningMode =4
  AND GETDATE() BETWEEN ss.StartDate AND COALESCE(ss.EndDate,'12/12/2078') 
  AND DATEADD(hh, 12, DATEDIFF(D, 0, GETDATE())) = m.Schedule_Date
        AND m.IsExecuted=0
     AND ((ss.StartHour*60) + ss.StartMin) <= (DATEPART(hour,GETDATE())*60) + DATEPART(minute,GETDATE()) 
  AND (h.NextStart IS NULL OR DATEDIFF(DAY,h.NextStart, GETDATE()) > 0) -- calendar
 
 UNION
 
 SELECT ss.[ScheduleID]
 FROM Schedule ss 
  INNER JOIN ScheduleHistory h ON ss.ScheduleId = h.ScheduleId
 WHERE ss.RunningMode= 5
  AND GETDATE() >=ss.StartDate  
  AND ((ss.StartHour*60) + ss.StartMin) <= (DATEPART(hour,GETDATE())*60) + DATEPART(minute,GETDATE()) 
  AND (h.NextStart IS NULL)  -- run once

)
GROUP BY s.[ScheduleID]
      ,s.[ScheduleName]
      ,s.[FullNamespace]
      ,s.[StartDate]
      ,s.[EndDate]
      ,s.[StartHour]
      ,s.[StartMin]
      ,s.[RepeatWeeks]
      ,s.[RepeatDAYs]
      ,s.[WeekOfMonth]
      ,s.[EveryHours]
      ,s.[EveryMin]
      ,s.[ObjectDependencies]
      ,s.[RetryTimeLapse]
      ,s.[RetryFrequencyUnit]
      ,s.[AttachToEvent]
      ,s.[CatchUpEnabled]
      ,s.[Servers]
      ,s.[CreatedByUserID]
      ,s.[CreatedOnDate]
      ,s.[LAStModifiedbyUserID]
      ,s.[LAStModifiedDate]
,s.[IsEnable]
,s.RunningMode

END;





GO
