

CREATE TABLE [dbo].[ModuleDefPermission](
	[ModuleDefPermissionID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleDefID] [int] NULL,
	[PermissionID] [int] NULL,
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
 CONSTRAINT [PK_MainModulePermission] PRIMARY KEY CLUSTERED 
(
	[ModuleDefPermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ModuleDefPermission]  WITH CHECK ADD  CONSTRAINT [FK_MainModulePermission_Portal] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO

ALTER TABLE [dbo].[ModuleDefPermission] CHECK CONSTRAINT [FK_MainModulePermission_Portal]
GO

ALTER TABLE [dbo].[ModuleDefPermission]  WITH CHECK ADD  CONSTRAINT [FK_MainPermission_ModuleDefinitions] FOREIGN KEY([ModuleDefID])
REFERENCES [dbo].[ModuleDefinitions] ([ModuleDefID])
GO

ALTER TABLE [dbo].[ModuleDefPermission] CHECK CONSTRAINT [FK_MainPermission_ModuleDefinitions]
GO

ALTER TABLE [dbo].[ModuleDefPermission]  WITH CHECK ADD  CONSTRAINT [FK_ModuleDefinitions_Permission] FOREIGN KEY([PermissionID])
REFERENCES [dbo].[Permission] ([PermissionID])
GO

ALTER TABLE [dbo].[ModuleDefPermission] CHECK CONSTRAINT [FK_ModuleDefinitions_Permission]
GO


