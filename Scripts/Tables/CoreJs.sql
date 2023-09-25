

CREATE TABLE [dbo].[CoreJs](
	[ResourceID] [int] IDENTITY(1,1) NOT NULL,
	[LoadingMode] [int] NULL,
	[IsHandheld] [bit] NULL,
	[PathMode] [bit] NULL,
	[Path] [nvarchar](500) NULL,
	[IsCompress] [bit] NULL,
	[Position] [bit] NULL,
 CONSTRAINT [PK_CoreJs] PRIMARY KEY CLUSTERED 
(
	[ResourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


