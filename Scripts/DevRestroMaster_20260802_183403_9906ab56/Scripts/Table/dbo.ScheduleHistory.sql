SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduleHistory](
	[ScheduleHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[ScheduleID] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[Status] [bit] NULL,
	[ReturnText] [ntext] NULL,
	[NextStart] [datetime] NULL,
	[Server] [varchar](150) NULL,
 CONSTRAINT [PK_ScheduleHistory] PRIMARY KEY CLUSTERED 
(
	[ScheduleHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[ScheduleHistory]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleHistory_Schedule] FOREIGN KEY([ScheduleID])
REFERENCES [dbo].[Schedule] ([ScheduleID])
GO
ALTER TABLE [dbo].[ScheduleHistory] CHECK CONSTRAINT [FK_ScheduleHistory_Schedule]
GO
