

CREATE TABLE [dbo].[SystemEventLocation](
	[EventLocationID] [int] IDENTITY(1,1) NOT NULL,
	[EventLocationName] [nvarchar](50) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_SystemEventLocation_IsActive]  DEFAULT ((1)),
	[AddedOn] [datetime] NULL CONSTRAINT [DF_SystemEventLocation_AddedOn]  DEFAULT (getdate()),
 CONSTRAINT [PK_SystemEventLocation] PRIMARY KEY CLUSTERED 
(
	[EventLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


