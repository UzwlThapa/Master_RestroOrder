

CREATE TABLE [dbo].[Template](
	[TemplateID] [int] IDENTITY(1,1) NOT NULL,
	[TemplateTitle] [nvarchar](256) NOT NULL,
	[PortalID] [int] NULL,
	[Author] [nvarchar](256) NULL,
	[Description] [nvarchar](500) NULL,
	[AuthorURL] [nvarchar](256) NULL,
	[AddedOn] [datetime] NULL,
	[AddedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_Template] PRIMARY KEY CLUSTERED 
(
	[TemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


