

CREATE TABLE [dbo].[Pages](
	[PageID] [int] IDENTITY(1,1) NOT NULL,
	[PageOrder] [int] NULL,
	[PageName] [nvarchar](100) NULL,
	[IsVisible] [bit] NULL,
	[ParentID] [int] NULL,
	[Level] [int] NULL,
	[IconFile] [nvarchar](100) NULL,
	[DisableLink] [bit] NULL,
	[Title] [nvarchar](200) NULL,
	[Description] [nvarchar](500) NULL,
	[KeyWords] [nvarchar](500) NULL,
	[Url] [nvarchar](255) NULL,
	[TabPath] [nvarchar](255) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[RefreshInterval] [decimal](16, 2) NULL,
	[PageHeadText] [nvarchar](500) NULL,
	[IsSecure] [bit] NOT NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL CONSTRAINT [DF_Pages_IsDeleted]  DEFAULT ((0)),
	[IsModified] [bit] NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
	[SEOName] [nvarchar](100) NULL,
	[IsShowInFooter] [bit] NULL,
	[IsRequiredPage] [bit] NULL CONSTRAINT [DF_Pages_IsRequiredPage]  DEFAULT ((0)),
	[DasboardGroup] [int] NULL CONSTRAINT [DF_Pages_DasboardGroup]  DEFAULT ((1)),
 CONSTRAINT [PK_Tabs] PRIMARY KEY CLUSTERED 
(
	[PageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Pages]  WITH CHECK ADD  CONSTRAINT [FK_Pages_Pages1] FOREIGN KEY([PageID])
REFERENCES [dbo].[Pages] ([PageID])
GO

ALTER TABLE [dbo].[Pages] CHECK CONSTRAINT [FK_Pages_Pages1]
GO


