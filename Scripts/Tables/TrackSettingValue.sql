

CREATE TABLE [dbo].[TrackSettingValue](
	[TrackSettingValueID] [int] IDENTITY(1,1) NOT NULL,
	[UserModuleID] [int] NOT NULL,
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
 CONSTRAINT [PK_TrackSettingValue] PRIMARY KEY CLUSTERED 
(
	[UserModuleID] ASC,
	[SettingKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TrackSettingValue] ADD  CONSTRAINT [DF_TrackSettingValue_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[TrackSettingValue] ADD  CONSTRAINT [DF_TrackSettingValue_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[TrackSettingValue] ADD  CONSTRAINT [DF_TrackSettingValue_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO

ALTER TABLE [dbo].[TrackSettingValue] ADD  CONSTRAINT [DF_TrackSettingValue_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO

ALTER TABLE [dbo].[TrackSettingValue] ADD  CONSTRAINT [DF_TrackSettingValue_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
GO

ALTER TABLE [dbo].[TrackSettingValue] ADD  CONSTRAINT [DF_TrackSettingValue_PortalID]  DEFAULT ((1)) FOR [PortalID]
GO


