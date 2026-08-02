SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SettingValue](
	[SettingValueID] [int] IDENTITY(1,1) NOT NULL,
	[SettingType] [nvarchar](100) NOT NULL,
	[SettingTypeID] [int] NOT NULL,
	[SettingKey] [nvarchar](256) NOT NULL,
	[SettingValue] [nvarchar](256) NULL,
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
	[IsCacheable] [bit] NULL,
 CONSTRAINT [PK_SettingValue] PRIMARY KEY CLUSTERED 
(
	[SettingType] ASC,
	[SettingTypeID] ASC,
	[SettingKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [IX_SettingValue_NN] ON [dbo].[SettingValue]
(
	[SettingTypeID] ASC,
	[SettingKey] ASC,
	[SettingType] ASC
)
INCLUDE([SettingValue]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SettingValue] ADD  CONSTRAINT [DF_SettingValue_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SettingValue] ADD  CONSTRAINT [DF_SettingValue_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[SettingValue] ADD  CONSTRAINT [DF_SettingValue_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO
ALTER TABLE [dbo].[SettingValue] ADD  CONSTRAINT [DF_SettingValue_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[SettingValue] ADD  CONSTRAINT [DF_SettingValue_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[SettingValue] ADD  CONSTRAINT [DF_SettingValue_PortalID]  DEFAULT ((1)) FOR [PortalID]
GO
ALTER TABLE [dbo].[SettingValue] ADD  CONSTRAINT [DF_SettingValue_IsCacheable]  DEFAULT ((0)) FOR [IsCacheable]
GO
