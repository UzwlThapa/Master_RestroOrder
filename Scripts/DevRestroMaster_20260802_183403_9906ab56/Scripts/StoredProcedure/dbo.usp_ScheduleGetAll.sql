SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ScheduleGetAll]
@offset INT,
@limit INT
AS
BEGIN
DECLARE @RowTotal INT
SELECT @RowTotal= count(*)   FROM [dbo].[Schedule] ;
WITH scheduleTmp AS
(
SELECT  @RowTotal AS RowTotal,*,ROW_NUMBER() OVER(ORDER BY ScheduleID DESC) AS RowNum
FROM
(SELECT s.[ScheduleID] AS ScheduleID
      ,s.[ScheduleName]
      ,s.[FullNamespace]
      ,s.[StartDate]
      ,s.[EndDate]
      ,s.[StartHour]
      ,s.[StartMin]
      ,s.[RepeatWeeks]
      ,s.[RepeatDays]
      ,s.[WeekOfMonth]
      ,s.[EveryHours]
      ,s.[EveryMin]
      ,s.[ObjectDependencies]
      ,s.[RetryTimeLapse]
      ,s.[RetryFrequencyUnit]
      ,s.[AttachToEvent]
      ,s.[CatchUpEnabled]
      ,s.[Servers]
 ,s.[ASsemblyFileName]
      ,s.[CreatedByUserID]
      ,s.[CreatedOnDate]
      ,s.[LAStModifiedbyUserID]
      ,s.[LAStModifiedDate]
,s.[IsEnable]
, MAX(v.ScheduleHistoryID) AS ScheduleHistoryID
 , (SELECT NextStart FROM [dbo].[ScheduleHistory]
          WHERE ScheduleHistoryID=MAX(v.ScheduleHistoryID))
         AS NextStart
,MAX(v.StartDate) AS HistoryStartDate,
MAX(v.EndDate) AS HistoryEndDate,
s.[RunningMode]
  FROM [dbo].[Schedule] s LEFT JOIN  [dbo].[ScheduleHistory] v ON s.ScheduleID=v.ScheduleID 

GROUP BY s.[ScheduleID]
      ,s.[ScheduleName]
      ,s.[FullNamespace]
      ,s.[StartDate]
      ,s.[EndDate]
      ,s.[StartHour]
      ,s.[StartMin]
      ,s.[RepeatWeeks]
      ,s.[RepeatDays]
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
  ,s.[ASsemblyFileName]
      ,s.[LAStModifiedbyUserID]
      ,s.[LAStModifiedDate]
 ,s.[IsEnable],s.[RunningMode] )DataTable

)

SELECT * from scheduleTmp WHERE RowNum>= @offset
AND RowNum <= (@offset + @limit - 1)
END;





GO
