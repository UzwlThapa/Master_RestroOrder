

CREATE TABLE [dbo].[LocalModuleTitle](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserModule] [nvarchar](500) NULL,
	[UserModuleID] [int] NULL,
	[LocalModuleTitle] [nvarchar](500) NULL,
	[CultureCode] [nvarchar](100) NULL,
 CONSTRAINT [PK_LocalModuleTitle] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


