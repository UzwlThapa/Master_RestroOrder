

CREATE TABLE [dbo].[HtmlText](
	[HTMLTextID] [int] IDENTITY(1,1) NOT NULL,
	[UserModuleID] [int] NOT NULL,
	[Content] [nvarchar](max) NULL,
	[CultureName] [nvarchar](256) NULL,
	[IsAllowedToComment] [bit] NULL,
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
 CONSTRAINT [PK_HtmlText] PRIMARY KEY CLUSTERED 
(
	[HTMLTextID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[HtmlText]  WITH CHECK ADD  CONSTRAINT [FK_HtmlText_HtmlText] FOREIGN KEY([HTMLTextID])
REFERENCES [dbo].[HtmlText] ([HTMLTextID])
GO

ALTER TABLE [dbo].[HtmlText] CHECK CONSTRAINT [FK_HtmlText_HtmlText]
GO

ALTER TABLE [dbo].[HtmlText]  WITH CHECK ADD  CONSTRAINT [FK_HtmlText_Portal] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO

ALTER TABLE [dbo].[HtmlText] CHECK CONSTRAINT [FK_HtmlText_Portal]
GO

ALTER TABLE [dbo].[HtmlText]  WITH CHECK ADD  CONSTRAINT [FK_HtmlText_UserModules] FOREIGN KEY([UserModuleID])
REFERENCES [dbo].[UserModules] ([UserModuleID])
GO

ALTER TABLE [dbo].[HtmlText] CHECK CONSTRAINT [FK_HtmlText_UserModules]
GO


