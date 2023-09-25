
CREATE TABLE [dbo].[ScheduleDate](
	[ScheduleID] [int] NOT NULL,
	[Schedule_Date] [smalldatetime] NOT NULL,
	[IsExecuted] [bit] NOT NULL,
 CONSTRAINT [PK_ScheduleDate] PRIMARY KEY CLUSTERED 
(
	[ScheduleID] ASC,
	[Schedule_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ScheduleDate] ADD  CONSTRAINT [DF_ScheduleDate_IsExecuted]  DEFAULT ((0)) FOR [IsExecuted]
GO

ALTER TABLE [dbo].[ScheduleDate]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleDate_Schedule] FOREIGN KEY([ScheduleID])
REFERENCES [dbo].[Schedule] ([ScheduleID])
GO

ALTER TABLE [dbo].[ScheduleDate] CHECK CONSTRAINT [FK_ScheduleDate_Schedule]
GO


