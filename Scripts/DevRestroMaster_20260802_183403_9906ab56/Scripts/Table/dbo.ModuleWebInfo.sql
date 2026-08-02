SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModuleWebInfo](
	[ModuleID] [int] NOT NULL,
	[ModuleName] [nvarchar](128) NULL,
	[ReleaseDate] [datetime] NULL,
	[Version] [nvarchar](8) NULL,
	[DownloadUrl] [nvarchar](200) NULL,
	[Description] [nvarchar](2000) NULL,
	[AddedOn] [datetime] NULL,
 CONSTRAINT [PK_ModuleWebInfo] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
