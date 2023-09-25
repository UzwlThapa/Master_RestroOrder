
CREATE TABLE [dbo].[ScheduleMonth](
	[ScheduleID] [int] NOT NULL,
	[MonthID] [int] NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_ScheduleMonth] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ScheduleMonth]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleMonth_Schedule] FOREIGN KEY([ScheduleID])
REFERENCES [dbo].[Schedule] ([ScheduleID])
GO

ALTER TABLE [dbo].[ScheduleMonth] CHECK CONSTRAINT [FK_ScheduleMonth_Schedule]
GO


