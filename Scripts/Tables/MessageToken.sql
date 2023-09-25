

CREATE TABLE [dbo].[MessageToken](
	[MessageTokenID] [int] IDENTITY(1,1) NOT NULL,
	[MessageTokenKey] [nvarchar](100) NULL,
	[MessageTokenName] [nvarchar](100) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_MessageToken_IsActive]  DEFAULT ((1)),
	[IsDeleted] [bit] NULL CONSTRAINT [DF_MessageToken_IsDeleted]  DEFAULT ((0)),
	[IsModified] [bit] NULL CONSTRAINT [DF_MessageToken_IsModified]  DEFAULT ((0)),
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_MessageToken] PRIMARY KEY CLUSTERED 
(
	[MessageTokenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


