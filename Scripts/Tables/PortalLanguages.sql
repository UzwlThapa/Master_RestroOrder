

CREATE TABLE [dbo].[PortalLanguages](
	[PortalLanguageID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[LanguageID] [int] NOT NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedOn] [datetime] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
	[IsPublished] [bit] NOT NULL CONSTRAINT [DF_PortalLanguages_IsPublished]  DEFAULT ((0)),
 CONSTRAINT [PK_PortalLanguages] PRIMARY KEY CLUSTERED 
(
	[PortalLanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PortalLanguages]  WITH CHECK ADD  CONSTRAINT [FK_PortalLanguages_PortalLanguages] FOREIGN KEY([LanguageID])
REFERENCES [dbo].[Languages] ([LanguageID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[PortalLanguages] CHECK CONSTRAINT [FK_PortalLanguages_PortalLanguages]
GO


