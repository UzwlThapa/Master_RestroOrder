SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LanguageSettingKey](
	[LanguageSettingID] [int] IDENTITY(1,1) NOT NULL,
	[SettingKey] [nvarchar](256) NOT NULL,
	[SettingValue] [nvarchar](256) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[IsModified] [bit] NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NOT NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_LanguageSettingKey] PRIMARY KEY CLUSTERED 
(
	[SettingKey] ASC,
	[PortalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[LanguageSettingKey] ADD  CONSTRAINT [DF_LanguageSettingKey_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[LanguageSettingKey] ADD  CONSTRAINT [DF_LanguageSettingKey_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[LanguageSettingKey] ADD  CONSTRAINT [DF_LanguageSettingKey_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO
ALTER TABLE [dbo].[LanguageSettingKey] ADD  CONSTRAINT [DF_LanguageSettingKey_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[LanguageSettingKey] ADD  CONSTRAINT [DF_LanguageSettingKey_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[LanguageSettingKey] ADD  CONSTRAINT [DF_LanguageSettingKey_PortalID]  DEFAULT ((1)) FOR [PortalID]
GO
