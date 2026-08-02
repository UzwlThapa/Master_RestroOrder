SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SchedulerAddJob] (@ScheduleName       VARCHAR(200), 
                                      @FullNamespace      VARCHAR(200), 
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
                                      @Servers            VARCHAR(250),                                     
                                      @IsEnable bit,
                                      @ScheduleID int output,
                                      @RunningMode int,
                                      @AssemblyFileName varchar(150)
                                      ) 
AS 
  BEGIN 
      SET NOCOUNT ON; 
      INSERT INTO [dbo].[Schedule] 
                  ([ScheduleName], 
                   [FullNamespace], 
                   [StartDate], 
                   [EndDate], 
                   [StartHour], 
                   [StartMin], 
                   [RepeatWeeks], 
                   [RepeatDays], 
                   [WeekOfMonth], 
                   [EveryHours], 
                   [EveryMin], 
                   [ObjectDependencies], 
                   [RetryTimeLapse], 
                   [RetryFrequencyUnit], 
                   [AttachToEvent], 
                   [CatchUpEnabled], 
                   [Servers], 
                  
                   [IsEnable], 
                   [CreatedOnDate],
                   [RunningMode],
                   [AssemblyFileName]) 
      VALUES      ( @ScheduleName, 
                    @FullNamespace, 
                    @StartDate, 
                    @EndDate, 
                    @StartHour, 
                    @StartMin, 
                    @RepeatWeeks, 
                    @RepeatDays, 
                    @WeekOfMonth, 
                    @EveryHour, 
                    @EveryMin, 
                    @ObjectDependencies, 
                    @RetryTimeLapse, 
                    @RetryFrequencyUnit, 
                    @AttachToEvent, 
                    @CatchUpEnabled, 
                    @Servers,                    
                    @IsEnable, 
                    GETDATE(),
                    @RunningMode,
                     @AssemblyFileName) 
      SET @ScheduleID=@@IDENTITY
  END





GO
