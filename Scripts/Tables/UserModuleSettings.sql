

CREATE TABLE [dbo].[UserModuleSettings](
	[UserModuleID] [int] NOT NULL,
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](2000) NULL,
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
 CONSTRAINT [PK_ModuleSettings] PRIMARY KEY CLUSTERED 
(
	[UserModuleID] ASC,
	[SettingName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[UserModuleSettings] ADD  CONSTRAINT [DF_ModuleSettings_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[UserModuleSettings] ADD  CONSTRAINT [DF_ModuleSettings_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[UserModuleSettings] ADD  CONSTRAINT [DF_ModuleSettings_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO

ALTER TABLE [dbo].[UserModuleSettings] ADD  CONSTRAINT [DF_ModuleSettings_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO

ALTER TABLE [dbo].[UserModuleSettings] ADD  CONSTRAINT [DF_ModuleSettings_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
GO

ALTER TABLE [dbo].[UserModuleSettings] ADD  CONSTRAINT [DF_ModuleSettings_PortalID]  DEFAULT ((1)) FOR [PortalID]
GO

ALTER TABLE [dbo].[UserModuleSettings]  WITH CHECK ADD  CONSTRAINT [FK_ModuleSettings_Portal] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO

ALTER TABLE [dbo].[UserModuleSettings] CHECK CONSTRAINT [FK_ModuleSettings_Portal]
GO

ALTER TABLE [dbo].[UserModuleSettings]  WITH CHECK ADD  CONSTRAINT [FK_ModuleSettings_UserModules] FOREIGN KEY([UserModuleID])
REFERENCES [dbo].[UserModules] ([UserModuleID])
GO

ALTER TABLE [dbo].[UserModuleSettings] CHECK CONSTRAINT [FK_ModuleSettings_UserModules]
GO


