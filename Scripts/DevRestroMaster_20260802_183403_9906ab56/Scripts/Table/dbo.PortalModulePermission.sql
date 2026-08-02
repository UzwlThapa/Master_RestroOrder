SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortalModulePermission](
	[PortalModulePermissionID] [int] IDENTITY(1,1) NOT NULL,
	[PortalModuleID] [int] NOT NULL,
	[ModuleDefPermissionID] [int] NOT NULL,
	[AllowAccess] [bit] NOT NULL,
	[RoleID] [uniqueidentifier] NULL,
	[Username] [nvarchar](256) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[IsModified] [bit] NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedOn] [datetime] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_PortalModulePermission] PRIMARY KEY CLUSTERED 
(
	[PortalModulePermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[PortalModulePermission] ADD  CONSTRAINT [DF_PortalModulePermission_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[PortalModulePermission] ADD  CONSTRAINT [DF_PortalModulePermission_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[PortalModulePermission] ADD  CONSTRAINT [DF_PortalModulePermission_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO
ALTER TABLE [dbo].[PortalModulePermission] ADD  CONSTRAINT [DF_PortalModulePermission_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[PortalModulePermission] ADD  CONSTRAINT [DF_PortalModulePermission_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
GO
