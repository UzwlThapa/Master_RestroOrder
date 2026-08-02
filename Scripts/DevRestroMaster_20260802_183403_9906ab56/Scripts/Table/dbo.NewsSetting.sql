SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsSetting](
	[NewsSettingID] [int] IDENTITY(1,1) NOT NULL,
	[DateFormat] [nvarchar](50) NULL,
	[NewsWordsToShow] [int] NULL,
	[NewsDetailsPage] [nvarchar](250) NULL,
	[ViewAllNewsPage] [nvarchar](250) NULL,
	[UserModuleID] [int] NULL,
	[PortalID] [int] NULL,
	[IsDeleted] [bit] NULL,
	[IsModified] [bit] NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedOn] [datetime] NULL,
	[CultureCode] [nvarchar](100) NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_NewsSetting_1] PRIMARY KEY CLUSTERED 
(
	[NewsSettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[NewsSetting] ADD  CONSTRAINT [DF_NewsSetting_IsDeleted_1]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[NewsSetting] ADD  CONSTRAINT [DF_NewsSetting_IsModified_1]  DEFAULT ((0)) FOR [IsModified]
GO
ALTER TABLE [dbo].[NewsSetting] ADD  CONSTRAINT [DF_NewsSetting_AddedOn_1]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[NewsSetting] ADD  CONSTRAINT [DF_NewsSetting_UpdatedOn_1]  DEFAULT (getdate()) FOR [UpdatedOn]
GO
