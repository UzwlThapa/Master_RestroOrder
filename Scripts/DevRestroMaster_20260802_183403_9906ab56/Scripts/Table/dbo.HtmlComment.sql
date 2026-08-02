SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HtmlComment](
	[HTMLCommentID] [int] IDENTITY(1,1) NOT NULL,
	[HTMLTextID] [int] NOT NULL,
	[Comment] [ntext] NOT NULL,
	[IsApproved] [bit] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[IsModified] [bit] NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedOn] [datetime] NULL,
	[ApprovedOn] [datetime] NULL,
	[PortalID] [int] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
	[ApprovedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_HTMLComment] PRIMARY KEY CLUSTERED 
(
	[HTMLCommentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[HtmlComment] ADD  CONSTRAINT [DF_HtmlComment_IsApproved]  DEFAULT ((0)) FOR [IsApproved]
GO
ALTER TABLE [dbo].[HtmlComment] ADD  CONSTRAINT [DF_HtmlComment_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[HtmlComment] ADD  CONSTRAINT [DF_HtmlComment_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[HtmlComment]  WITH CHECK ADD  CONSTRAINT [FK_HTMLComment_Portal] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO
ALTER TABLE [dbo].[HtmlComment] CHECK CONSTRAINT [FK_HTMLComment_Portal]
GO
