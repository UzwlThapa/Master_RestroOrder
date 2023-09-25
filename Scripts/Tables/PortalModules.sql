

CREATE TABLE [dbo].[PortalModules](
	[PortalModuleID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[ModuleID] [int] NOT NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_PortalModules_IsActive]  DEFAULT ((1)),
	[IsDeleted] [bit] NULL CONSTRAINT [DF_PortalModules_IsDeleted]  DEFAULT ((0)),
	[IsModified] [bit] NULL CONSTRAINT [DF_PortalModules_IsModified]  DEFAULT ((0)),
	[AddedOn] [datetime] NULL CONSTRAINT [DF_PortalModules_AddedOn]  DEFAULT (getdate()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_PortalModules_UpdatedOn]  DEFAULT (getdate()),
	[DeletedOn] [datetime] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_PortalModules] PRIMARY KEY CLUSTERED 
(
	[PortalModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PortalModules]  WITH CHECK ADD  CONSTRAINT [FK_PortalModules_Modules] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[Modules] ([ModuleID])
GO

ALTER TABLE [dbo].[PortalModules] CHECK CONSTRAINT [FK_PortalModules_Modules]
GO

ALTER TABLE [dbo].[PortalModules]  WITH CHECK ADD  CONSTRAINT [FK_PortalModules_Portal] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO

ALTER TABLE [dbo].[PortalModules] CHECK CONSTRAINT [FK_PortalModules_Portal]
GO


