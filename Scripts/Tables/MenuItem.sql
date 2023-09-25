

CREATE TABLE [dbo].[MenuItem](
	[MenuItemID] [int] IDENTITY(1,1) NOT NULL,
	[MenuID] [int] NOT NULL,
	[LinkType] [nvarchar](50) NULL,
	[PageID] [nvarchar](50) NULL,
	[Title] [nvarchar](50) NULL,
	[LinkURL] [nvarchar](200) NULL,
	[ImageIcon] [nvarchar](100) NULL,
	[Caption] [nvarchar](200) NULL,
	[HtmlContent] [nvarchar](2000) NULL,
	[ParentID] [int] NULL,
	[MenuLevel] [nvarchar](50) NULL,
	[MenuOrder] [int] NULL,
	[SubText] [nvarchar](254) NULL,
	[IsVisible] [bit] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[IsModified] [bit] NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_MenuItem] PRIMARY KEY CLUSTERED 
(
	[MenuItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MenuItem]  WITH CHECK ADD  CONSTRAINT [FK_MenuItem_MenuItem] FOREIGN KEY([MenuItemID])
REFERENCES [dbo].[MenuItem] ([MenuItemID])
GO

ALTER TABLE [dbo].[MenuItem] CHECK CONSTRAINT [FK_MenuItem_MenuItem]
GO


