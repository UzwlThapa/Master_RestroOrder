

CREATE TABLE [dbo].[DashboardSidebar](
	[DisplayName] [nvarchar](250) NULL,
	[Depth] [int] NULL,
	[ImagePath] [nvarchar](250) NULL,
	[URL] [nvarchar](250) NULL,
	[ParentID] [int] NULL,
	[IsActive] [bit] NULL,
	[SidebarItemID] [int] IDENTITY(1,1) NOT NULL,
	[DisplayOrder] [int] NULL,
	[PageID] [int] NULL,
 CONSTRAINT [PK_DashboardSidebar] PRIMARY KEY CLUSTERED 
(
	[SidebarItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


