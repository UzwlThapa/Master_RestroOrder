

CREATE TABLE [dbo].[MessageTemplateType](
	[MessageTemplateTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL CONSTRAINT [DF_MessageTemplateType_IsDeleted]  DEFAULT ((0)),
	[IsModified] [bit] NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_MessageTemplateType_UpdatedOn]  DEFAULT (getdate()),
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NULL CONSTRAINT [DF_MessageTemplateType_PortalID]  DEFAULT ((1)),
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_MessageTemplateType] PRIMARY KEY CLUSTERED 
(
	[MessageTemplateTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


