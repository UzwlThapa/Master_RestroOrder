SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortalModules](
	[PortalModuleID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[ModuleID] [int] NOT NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[IsModified] [bit] NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedOn] [datetime] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_PortalModules] PRIMARY KEY CLUSTERED 
(
	[PortalModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[PortalModules] ADD  CONSTRAINT [DF_PortalModules_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[PortalModules] ADD  CONSTRAINT [DF_PortalModules_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[PortalModules] ADD  CONSTRAINT [DF_PortalModules_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO
ALTER TABLE [dbo].[PortalModules] ADD  CONSTRAINT [DF_PortalModules_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[PortalModules] ADD  CONSTRAINT [DF_PortalModules_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
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
