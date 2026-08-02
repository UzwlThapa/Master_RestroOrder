SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ScheduleUpdate]
(
           @ScheduleName       VARCHAR(200),                                      
                                      @StartDate          SMALLDATETIME, 
                                      @EndDate            SMALLDATETIME, 
                                      @StartHour          SMALLINT, 
                                      @StartMin           SMALLINT, 
                                      @RepeatWeeks        SMALLINT, 
                                      @RepeatDays         INT, 
                                      @WeekOfMonth        INT, 
                                      @EveryHour         INT, 
                                      @EveryMin           SMALLINT, 
                                      @ObjectDependencies VARCHAR(300), 
                                      @RetryTimeLapse     INT, 
                                      @RetryFrequencyUnit VARCHAR(10), 
                                      @AttachToEvent      VARCHAR(50), 
                                      @CatchUpEnabled     BIT, 
                                      @IsEnable BIT,
                                      @Servers            VARCHAR(250),
           @ScheduleID    INT,
                                       @RunningMode INT
)
AS 
BEGIN
SET NOCOUNT ON;
UPDATE [dbo].[Schedule]
   SET [ScheduleName] = @ScheduleName,
      [StartDate] = @StartDate, 
      [EndDate] = @EndDate,
       RunningMode=@RunningMode,
IsEnable=@IsEnable,
      [StartHour] = @StartHour,
      [StartMin] = @StartMin,
      [RepeatWeeks] = @RepeatWeeks,
      [RepeatDays] = @RepeatDays,
      [WeekOfMonth] = @WeekOfMonth,
      [EveryHours] = @EveryHour,
      [EveryMin] = @EveryMin,
      [ObjectDependencies] = @ObjectDependencies,
      [RetryTimeLapse] = @RetryTimeLapse,
      [RetryFrequencyUnit] = @RetryFrequencyUnit,
      [AttachToEvent] = @AttachToEvent,
      [CatchUpEnabled] = @CatchUpEnabled,
      [Servers] = @Servers
     
 WHERE [ScheduleID]=@ScheduleID
END





GO
