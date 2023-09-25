

CREATE TABLE [dbo].[CacheSearch](
	[CacheID] [int] IDENTITY(1,1) NOT NULL,
	[SearchWord] [nvarchar](max) NULL,
	[PageName] [nvarchar](200) NULL,
	[UserModuleTitle] [nvarchar](200) NULL,
	[HTMLContent] [ntext] NULL,
	[URL] [nvarchar](200) NULL,
	[CultureName] [nvarchar](50) NULL,
	[UpdatedContentOn] [datetime] NULL,
	[UserModuleID] [int] NULL,
	[Counter] [int] NULL,
	[RowTotal] [int] NULL,
	[RowNumber] [int] NULL,
	[SearchedDate] [datetime] NULL,
	[PortalID] [int] NULL,
 CONSTRAINT [PK_CacheSearch_1] PRIMARY KEY CLUSTERED 
(
	[CacheID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


