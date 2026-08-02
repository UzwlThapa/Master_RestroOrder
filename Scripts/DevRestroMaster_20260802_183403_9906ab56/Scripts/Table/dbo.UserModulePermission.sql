SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserModulePermission](
	[UserModulePermissionID] [int] IDENTITY(1,1) NOT NULL,
	[UserModuleID] [int] NULL,
	[ModuleDefPermissionID] [int] NULL,
	[AllowAccess] [bit] NULL,
	[RoleID] [uniqueidentifier] NULL,
	[Username] [nvarchar](256) NULL,
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
 CONSTRAINT [PK_ModulePermission] PRIMARY KEY CLUSTERED 
(
	[UserModulePermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserModulePermission] ON [dbo].[UserModulePermission]
(
	[ModuleDefPermissionID] ASC,
	[UserModuleID] ASC,
	[RoleID] ASC,
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserModulePermission] ADD  CONSTRAINT [DF_ModulePermission_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[UserModulePermission] ADD  CONSTRAINT [DF_ModulePermission_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[UserModulePermission] ADD  CONSTRAINT [DF_ModulePermission_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO
ALTER TABLE [dbo].[UserModulePermission] ADD  CONSTRAINT [DF_ModulePermission_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[UserModulePermission] ADD  CONSTRAINT [DF_ModulePermission_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[UserModulePermission] ADD  CONSTRAINT [DF_ModulePermission_PortalID]  DEFAULT ((1)) FOR [PortalID]
GO
ALTER TABLE [dbo].[UserModulePermission]  WITH CHECK ADD  CONSTRAINT [FK_ModulePermission_MainPermission] FOREIGN KEY([ModuleDefPermissionID])
REFERENCES [dbo].[ModuleDefPermission] ([ModuleDefPermissionID])
GO
ALTER TABLE [dbo].[UserModulePermission] CHECK CONSTRAINT [FK_ModulePermission_MainPermission]
GO
ALTER TABLE [dbo].[UserModulePermission]  WITH CHECK ADD  CONSTRAINT [FK_ModulePermission_Portal] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO
ALTER TABLE [dbo].[UserModulePermission] CHECK CONSTRAINT [FK_ModulePermission_Portal]
GO
ALTER TABLE [dbo].[UserModulePermission]  WITH CHECK ADD  CONSTRAINT [FK_UserModulePermission_Portal] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO
ALTER TABLE [dbo].[UserModulePermission] CHECK CONSTRAINT [FK_UserModulePermission_Portal]
GO
ALTER TABLE [dbo].[UserModulePermission]  WITH CHECK ADD  CONSTRAINT [FK_UserModulePermission_UserModules] FOREIGN KEY([UserModuleID])
REFERENCES [dbo].[UserModules] ([UserModuleID])
GO
ALTER TABLE [dbo].[UserModulePermission] CHECK CONSTRAINT [FK_UserModulePermission_UserModules]
GO
