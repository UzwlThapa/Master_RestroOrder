SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[usp_ScheduleGetAll] 1,10
CREATE PROCEDURE [dbo].[usp_ScheduleGetAllActive]
@offset INT,
@limit INT
AS
BEGIN
DECLARE @RowTotal INT
SELECT @RowTotal= COUNT(*) 
  FROM [dbo].[Schedule] 
DECLARE @tbltemp TABLE
(
RowNumber INT IDENTITY(1,1),
ScheduleID INT,
ScheduleName NVARCHAR(200),
FullNameSpace NVARCHAR(200),
StartDate SMALLDATETIME,
EndDate SMALLDATETIME,
StartHour SMALLINT,
StartMin SMALLINT,
RepeatWeeks SMALLINT,
RepeatDays INT,
WeekOfMonth INT,
EveryHours INT,
EveryMin SMALLINT,
ObjectDependencies NVARCHAR(300),
RetryTimeLapse INT,
RetryFrequencyUnit INT,
AttachToEvent NVARCHAR(50),
CatchUpEnabled bit,
Servers NVARCHAR(250),
CreatedByUserID NVARCHAR(50),
CreatedOnDate datetime,
LAStModifiedbyUserID INT,
LAStModifiedDate datetime,
IsEnable BIT,
ScheduleHistoryID INT,
NextStart datetime,
HistoryStartDate SMALLDATETIME,
HistoryEndDate SMALLDATETIME,
RunningMode INT,
RowTotal INT
)
INSERT INTO @tbltemp
SELECT 
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
      ,s.[LAStModifiedbyUserID]
      ,s.[LAStModifiedDate]
,s.[IsEnable]
,
  MAX(v.ScheduleHistoryID)AS ScheduleHistoryID
      ,MAX(v.NextStart) AS NextStart
,MAX(v.StartDate) AS HistoryStartDate,
MAX(v.EndDate) AS HistoryEndDate,
s.[RunningMode],
@RowTotal
  FROM [dbo].[Schedule] s LEFT JOIN  [dbo].[ScheduleHistory] v ON s.ScheduleID=v.ScheduleID
WHERE s.IsEnable=1
 
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
      ,s.[LAStModifiedbyUserID]
      ,s.[LAStModifiedDate]
,s.[IsEnable]
,s.[RunningMode]

ORDER BY s.ScheduleID DESC
SELECT
RowTotal ,
ScheduleID ,
ScheduleName ,
FullNameSpace ,
StartDate ,
EndDate ,
StartHour ,
StartMin ,
RepeatWeeks ,
RepeatDays ,
WeekOfMonth ,
EveryHours ,
EveryMin ,
ObjectDependencies ,
RetryTimeLapse ,
RetryFrequencyUnit ,
AttachToEvent ,
CatchUpEnabled ,
Servers ,
CreatedByUserID ,
CreatedOnDate ,
LAStModifiedbyUserID ,
LAStModifiedDate,
IsEnable ,
ScheduleHistoryID ,
NextStart ,
HistoryStartDate ,
HistoryEndDate ,
RunningMode,
 RowNumber
FROM @tbltemp WHERE RowNumber >= @offset
AND RowNumber <= (@offset + @limit - 1)
END;





GO
