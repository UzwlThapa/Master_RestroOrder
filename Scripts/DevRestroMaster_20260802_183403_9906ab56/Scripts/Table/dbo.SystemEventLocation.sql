SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemEventLocation](
	[EventLocationID] [int] IDENTITY(1,1) NOT NULL,
	[EventLocationName] [nvarchar](50) NULL,
	[IsActive] [bit] NULL,
	[AddedOn] [datetime] NULL,
 CONSTRAINT [PK_SystemEventLocation] PRIMARY KEY CLUSTERED 
(
	[EventLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[SystemEventLocation] ADD  CONSTRAINT [DF_SystemEventLocation_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SystemEventLocation] ADD  CONSTRAINT [DF_SystemEventLocation_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
