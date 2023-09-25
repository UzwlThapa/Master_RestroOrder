

CREATE TABLE [dbo].[Schedule](
	[ScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[ScheduleName] [varchar](200) NULL,
	[FullNamespace] [varchar](200) NULL,
	[StartDate] [smalldatetime] NULL,
	[EndDate] [smalldatetime] NULL,
	[StartHour] [smallint] NULL,
	[StartMin] [smallint] NULL,
	[RepeatWeeks] [smallint] NULL,
	[RepeatDays] [int] NULL,
	[WeekOfMonth] [int] NULL,
	[EveryHours] [int] NULL,
	[EveryMin] [smallint] NULL,
	[ObjectDependencies] [varchar](300) NULL,
	[RetryTimeLapse] [int] NULL,
	[RetryFrequencyUnit] [int] NULL,
	[AttachToEvent] [varchar](50) NULL,
	[CatchUpEnabled] [bit] NULL,
	[Servers] [varchar](250) NULL,
	[CreatedByUserID] [varchar](250) NULL,
	[CreatedOnDate] [datetime] NULL,
	[LastModifiedbyUserID] [int] NULL,
	[LastModifiedDate] [datetime] NULL,
	[IsEnable] [bit] NOT NULL,
	[RunningMode] [int] NOT NULL,
	[AssemblyFileName] [varchar](150) NULL,
 CONSTRAINT [PK_Schedule] PRIMARY KEY CLUSTERED 
(
	[ScheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Schedule] ADD  CONSTRAINT [DF_Schedule_IsEnable]  DEFAULT ((0)) FOR [IsEnable]
GO


