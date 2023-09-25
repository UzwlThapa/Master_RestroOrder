

CREATE TABLE [dbo].[UserModulePermission](
	[UserModulePermissionID] [int] IDENTITY(1,1) NOT NULL,
	[UserModuleID] [int] NULL,
	[ModuleDefPermissionID] [int] NULL,
	[AllowAccess] [bit] NULL,
	[RoleID] [uniqueidentifier] NULL,
	[Username] [nvarchar](256) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_ModulePermission_IsActive]  DEFAULT ((1)),
	[IsDeleted] [bit] NULL CONSTRAINT [DF_ModulePermission_IsDeleted]  DEFAULT ((0)),
	[IsModified] [bit] NULL CONSTRAINT [DF_ModulePermission_IsModified]  DEFAULT ((0)),
	[AddedOn] [datetime] NULL CONSTRAINT [DF_ModulePermission_AddedOn]  DEFAULT (getdate()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_ModulePermission_UpdatedOn]  DEFAULT (getdate()),
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NULL CONSTRAINT [DF_ModulePermission_PortalID]  DEFAULT ((1)),
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_ModulePermission] PRIMARY KEY CLUSTERED 
(
	[UserModulePermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

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


