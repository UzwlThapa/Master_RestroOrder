

CREATE TABLE [dbo].[DashboardQuickLinks](
	[DisplayName] [nvarchar](200) NULL,
	[URL] [nvarchar](250) NULL,
	[ImagePath] [nvarchar](250) NULL,
	[QuickLinkID] [int] IDENTITY(1,1) NOT NULL,
	[DisplayOrder] [int] NULL,
	[IsActive] [bit] NULL,
	[PageID] [int] NULL,
 CONSTRAINT [PK_DashboardQuickLinks] PRIMARY KEY CLUSTERED 
(
	[QuickLinkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


