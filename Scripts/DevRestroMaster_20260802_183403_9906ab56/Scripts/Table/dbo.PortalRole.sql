SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortalRole](
	[PortalRoleID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[RoleID] [uniqueidentifier] NOT NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[IsModified] [bit] NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedOn] [datetime] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_PortalRole] PRIMARY KEY CLUSTERED 
(
	[PortalID] ASC,
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[PortalRole] ADD  CONSTRAINT [DF_Table_1_RoleId]  DEFAULT (newid()) FOR [RoleID]
GO
ALTER TABLE [dbo].[PortalRole] ADD  CONSTRAINT [DF_PortalRole_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
