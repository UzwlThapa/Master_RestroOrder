

CREATE TABLE [dbo].[MessageTemplate](
	[MessageTemplateID] [int] IDENTITY(1,1) NOT NULL,
	[MessageTemplateTypeID] [int] NOT NULL,
	[Subject] [nvarchar](200) NOT NULL,
	[Body] [ntext] NOT NULL,
	[MailFrom] [nvarchar](100) NOT NULL,
	[Culture] [nvarchar](256) NULL,
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
 CONSTRAINT [PK_MessageTemplate] PRIMARY KEY CLUSTERED 
(
	[MessageTemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


