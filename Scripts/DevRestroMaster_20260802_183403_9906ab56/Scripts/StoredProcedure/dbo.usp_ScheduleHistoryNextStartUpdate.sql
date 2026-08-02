SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <ROSHAN GHIMIRE>
-- Create date: <2011/08/26>
-- Description: <Description,,>

CREATE PROCEDURE [dbo].[usp_ScheduleHistoryNextStartUpdate] 
(
@ScheduleID INT ,
@ResultNextStart DATETIME OUTPUT
)
AS
BEGIN
 SET NOCOUNT ON;
 DECLARE @ScheduleHistoryID INT
 DECLARE @WeekDAY INT,@CurrentWeeknum INT, @LargeWeeknum INT,@NextDAY INT, @CurrentStartDAY INT
 SELECT @ScheduleHistoryID=MAX(ScheduleHistoryID) FROM dbo.ScheduleHistory WHERE ScheduleID=@ScheduleID
   
 DECLARE @RunningMode INT,@StartDate DATETIME,@NextStart DATETIME,@HistoryStartDate DATETIME,
    @StartHour INT,@StartMIN INT,@EveryHours INT,@EveryMIN INT,@RepeatDAYs INT, @RepeatWeek INT


 IF(@ScheduleHistoryID IS NOT NULL)
  BEGIN
   SELECT   
    @NextStart=h.[NextStart]   
    ,@RunningMode=s.RunningMode
    ,@EveryHours=s.EveryHours
    ,@EveryMIN=s.EveryMIN 
    ,@StartMIN=s.StartMIN
    ,@StartHour=s.StartHour
    ,@StartDate=s.StartDate
    ,@HistoryStartDate=h.StartDate
    ,@RepeatWeek=s.RepeatWeeks
    ,@RepeatDAYs=s.RepeatDAYs
     FROM [dbo].[ScheduleHistory] h INNER JOIN dbo.Schedule s
    ON s.ScheduleID=h.ScheduleID
    WHERE ScheduleHistoryID=@ScheduleHistoryID

   IF((@NextStart IS NULL OR @NextStart='') AND @RunningMode<>0)
    BEGIN
     SET @NextStart=DATEADD(MINute,@StartMIN,(DATEADD(hour,@StartHour,@StartDate)))
    END 
   
   SET @StartDate=DATEADD(MINute,@StartMIN,(DATEADD(hour,@StartHour,@StartDate)))
   IF(@StartDate>GETDATE())
    BEGIN
     SET @NextStart=@StartDate
    END
   
   ELSE
   BEGIN
   IF (@HistoryStartDate>@StartDate)
   SET @StartDate=DATEADD(MINute,@StartMIN,(DATEADD(hour,@StartHour,(DATEADD(dd, 0, DATEDIFF(dd, 0, @HistoryStartDate))))))
   --Hourly
   IF(@RunningMode=0)
    BEGIN
     SET @NextStart=DATEADD(MINute,@EveryMIN,(DATEADD(hour,@EveryHours,@StartDate)))
    END

   --Daily
   ELSE IF(@RunningMode=1)
    BEGIN
     SET @NextStart=DATEADD(DAY,@RepeatDAYs,@StartDate)
    END

   --Weekly
   ELSE IF(@RunningMode=2)
    BEGIN

     SET @CurrentWeeknum=DATEPART(weekDAY,@StartDate)+1
     SELECT  @LargeWeeknum =MAX(WeekDAYID) FROM ScheduleWeek WHERE ScheduleID=@ScheduleId

     IF @LargeWeeknum >0
      BEGIN
         IF @CurrentWeeknum>=@LargeWeeknum
        BEGIN   
           SELECT @WeekDAY=MIN(WeekDAYID) FROM ScheduleWeek WHERE ScheduleID=@ScheduleId
        END
       ELSE IF @CurrentWeeknum<@LargeWeeknum
        BEGIN
           SELECT @WeekDAY=MIN(WeekDAYID) FROM ScheduleWeek WHERE  
          WeekDAYID>@CurrentWeeknum AND ScheduleID=@ScheduleId
        END   
      END 

     SET @NextDAY=0
     SET @CurrentStartDAY=DATEPART(weekDAY,GETDATE())
      
     IF (@WeekDAY>@CurrentStartDAY)
      SET @NextDAY=@WeekDAY-@CurrentStartDAY
     ELSE 
      SET @NextDAY=7+@WeekDAY-@CurrentStartDAY

     SET @NextStart=DATEADD(DAY,@NextDAY,(DATEADD(MINute,@StartMIN,(DATEADD(hour,@StartHour,(DATEADD(dd, 0, 

     DATEDIFF(dd, 0, GETDATE()))))))))

    END

   --WeekNumber
   ELSE IF(@RunningMode=3)
    BEGIN
     SET @CurrentWeeknum=DATEPART(weekDAY,@StartDate)+1
     SELECT  @LargeWeeknum =MAX(WeekDAYID) FROM ScheduleWeek WHERE ScheduleID=@ScheduleId
     IF @LargeWeeknum >0
      BEGIN
       IF @CurrentWeeknum>=@LargeWeeknum
        BEGIN   
           SELECT @WeekDAY=MIN(WeekDAYID) FROM ScheduleWeek WHERE ScheduleID=@ScheduleId
        END
       ELSE IF @CurrentWeeknum<@LargeWeeknum
        BEGIN
           SELECT @WeekDAY=MIN(WeekDAYID) FROM ScheduleWeek WHERE  
          WeekDAYID>@CurrentWeeknum AND ScheduleID=@ScheduleId
        END 
      END 

     DECLARE @NextMonth INT
     SET @NextDAY=0
     SET @CurrentStartDAY=DATEPART(weekDAY,GETDATE())
     SET @NextMonth=DATEPART(month,GETDATE())+1

     IF(@WeekDAY>@CurrentStartDAY)
      SET @NextDAY=DATEPART(DAY,GETDATE())+@WeekDAY-@CurrentStartDAY
     ELSE
      BEGIN   
       SELECT @NextMonth=MIN(MonthID)  FROM ScheduleMonth WHERE MonthID>DATEPART(Month,@StartDate) AND ScheduleID=@ScheduleID                    
       SET @NextDAY=@RepeatWeek*7-7+@WeekDAY
      END

     SET @NextStart=CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + '/' + @NextMonth + '/' + @NextDAY AS DATETIME)
    END

   --CalENDar
   ELSE IF(@RunningMode=4)
    BEGIN
     SELECT @NextStart=MIN(Schedule_Date)  FROM ScheduleDate WHERE Schedule_Date>convert(DATETIME,@StartDate,101) AND ScheduleID=@ScheduleID
    END
   --Once
   ELSE IF(@RunningMode=5)
    BEGIN
     SELECT @NextStart=NULL
    END
  END
  END

 UPDATE ScheduleHistory
  SET NextStart=@NextStart  
  WHERE ScheduleHistoryID=@ScheduleHistoryID

SET @ResultNextStart=@NextStart
END;





GO
