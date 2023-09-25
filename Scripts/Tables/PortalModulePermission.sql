

CREATE TABLE [dbo].[PortalModulePermission](
	[PortalModulePermissionID] [int] IDENTITY(1,1) NOT NULL,
	[PortalModuleID] [int] NOT NULL,
	[ModuleDefPermissionID] [int] NOT NULL,
	[AllowAccess] [bit] NOT NULL,
	[RoleID] [uniqueidentifier] NULL,
	[Username] [nvarchar](256) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_PortalModulePermission_IsActive]  DEFAULT ((1)),
	[IsDeleted] [bit] NULL CONSTRAINT [DF_PortalModulePermission_IsDeleted]  DEFAULT ((0)),
	[IsModified] [bit] NULL CONSTRAINT [DF_PortalModulePermission_IsModified]  DEFAULT ((0)),
	[AddedOn] [datetime] NULL CONSTRAINT [DF_PortalModulePermission_AddedOn]  DEFAULT (getdate()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_PortalModulePermission_UpdatedOn]  DEFAULT (getdate()),
	[DeletedOn] [datetime] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_PortalModulePermission] PRIMARY KEY CLUSTERED 
(
	[PortalModulePermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


