SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MessageTemplateTypeToken](
	[MessageTemplateTypeTokenID] [int] IDENTITY(1,1) NOT NULL,
	[MessageTemplateTypeID] [int] NOT NULL,
	[MessageTokenID] [int] NOT NULL,
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
 CONSTRAINT [PK_MessageTemplateTypeToken] PRIMARY KEY CLUSTERED 
(
	[MessageTemplateTypeID] ASC,
	[MessageTokenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[MessageTemplateTypeToken] ADD  CONSTRAINT [DF_MessageTemplateTypeToken_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[MessageTemplateTypeToken] ADD  CONSTRAINT [DF_MessageTemplateTypeToken_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[MessageTemplateTypeToken] ADD  CONSTRAINT [DF_MessageTemplateTypeToken_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO
ALTER TABLE [dbo].[MessageTemplateTypeToken]  WITH CHECK ADD  CONSTRAINT [FK_MessageTemplateTypeToken_MessageTemplateType] FOREIGN KEY([MessageTemplateTypeID])
REFERENCES [dbo].[MessageTemplateType] ([MessageTemplateTypeID])
GO
ALTER TABLE [dbo].[MessageTemplateTypeToken] CHECK CONSTRAINT [FK_MessageTemplateTypeToken_MessageTemplateType]
GO
ALTER TABLE [dbo].[MessageTemplateTypeToken]  WITH CHECK ADD  CONSTRAINT [FK_MessageTemplateTypeToken_MessageToken] FOREIGN KEY([MessageTokenID])
REFERENCES [dbo].[MessageToken] ([MessageTokenID])
GO
ALTER TABLE [dbo].[MessageTemplateTypeToken] CHECK CONSTRAINT [FK_MessageTemplateTypeToken_MessageToken]
GO
