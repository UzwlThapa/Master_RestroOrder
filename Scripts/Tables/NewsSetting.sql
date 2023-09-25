

CREATE TABLE [dbo].[NewsSetting](
	[NewsSettingID] [int] IDENTITY(1,1) NOT NULL,
	[DateFormat] [nvarchar](50) NULL,
	[NewsWordsToShow] [int] NULL,
	[NewsDetailsPage] [nvarchar](250) NULL,
	[ViewAllNewsPage] [nvarchar](250) NULL,
	[UserModuleID] [int] NULL,
	[PortalID] [int] NULL,
	[IsDeleted] [bit] NULL CONSTRAINT [DF_NewsSetting_IsDeleted_1]  DEFAULT ((0)),
	[IsModified] [bit] NULL CONSTRAINT [DF_NewsSetting_IsModified_1]  DEFAULT ((0)),
	[AddedOn] [datetime] NULL CONSTRAINT [DF_NewsSetting_AddedOn_1]  DEFAULT (getdate()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_NewsSetting_UpdatedOn_1]  DEFAULT (getdate()),
	[DeletedOn] [datetime] NULL,
	[CultureCode] [nvarchar](100) NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_NewsSetting_1] PRIMARY KEY CLUSTERED 
(
	[NewsSettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


