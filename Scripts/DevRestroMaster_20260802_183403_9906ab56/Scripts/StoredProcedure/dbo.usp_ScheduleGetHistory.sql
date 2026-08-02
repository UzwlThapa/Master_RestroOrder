SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ScheduleGetHistory] 
@ScheduleID INT,
@offset INT,
@limit INT
AS
BEGIN
SELECT * FROM(
SELECT row_number() OVER(ORDER BY s.[ScheduleID] DESC) AS rowNum, 
s.[ScheduleID]
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
      ,s.[LastModifiedbyUserID]
      ,s.[LastModifiedDate]
,s.[IsEnable]
,v.Status,v.[Server],
  v.ScheduleHistoryID AS ScheduleHistoryID
      ,v.NextStart AS NextStart
,v.StartDate AS HistoryStartDate,
v.EndDate AS HistoryEndDate
, v.ReturnText,DATEDIFF(millisecond,v.StartDate,v.EndDate) AS Duration

  FROM [dbo].[Schedule] s LEFT JOIN [dbo].[ScheduleHistory] v ON s.ScheduleID=v.ScheduleID
 WHERE v.ScheduleID=@ScheduleID
) AS t
WHERE
 rowNum>= @offset
AND rowNum <= (@offset + @limit - 1)
END;





GO
