SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PagePermission](
	[PagePermissionID] [int] IDENTITY(1,1) NOT NULL,
	[PageID] [int] NULL,
	[PermissionID] [int] NULL,
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
 CONSTRAINT [PK_TabPermission] PRIMARY KEY CLUSTERED 
(
	[PagePermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_PagePermission] ON [dbo].[PagePermission]
(
	[PageID] ASC,
	[PermissionID] ASC,
	[RoleID] ASC,
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PagePermission] ADD  CONSTRAINT [DF_TabPermission_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[PagePermission] ADD  CONSTRAINT [DF_TabPermission_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[PagePermission] ADD  CONSTRAINT [DF_TabPermission_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO
ALTER TABLE [dbo].[PagePermission] ADD  CONSTRAINT [DF_TabPermission_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[PagePermission] ADD  CONSTRAINT [DF_TabPermission_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[PagePermission] ADD  CONSTRAINT [DF_TabPermission_PortalID]  DEFAULT ((1)) FOR [PortalID]
GO
ALTER TABLE [dbo].[PagePermission]  WITH CHECK ADD  CONSTRAINT [FK_PagePermission_Pages] FOREIGN KEY([PageID])
REFERENCES [dbo].[Pages] ([PageID])
GO
ALTER TABLE [dbo].[PagePermission] CHECK CONSTRAINT [FK_PagePermission_Pages]
GO
ALTER TABLE [dbo].[PagePermission]  WITH CHECK ADD  CONSTRAINT [FK_PagePermission_Permission] FOREIGN KEY([PermissionID])
REFERENCES [dbo].[Permission] ([PermissionID])
GO
ALTER TABLE [dbo].[PagePermission] CHECK CONSTRAINT [FK_PagePermission_Permission]
GO
ALTER TABLE [dbo].[PagePermission]  WITH CHECK ADD  CONSTRAINT [FK_PagePermission_Portal] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO
ALTER TABLE [dbo].[PagePermission] CHECK CONSTRAINT [FK_PagePermission_Portal]
GO
ALTER TABLE [dbo].[PagePermission]  WITH CHECK ADD  CONSTRAINT [FK_PagePermission_Portal1] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO
ALTER TABLE [dbo].[PagePermission] CHECK CONSTRAINT [FK_PagePermission_Portal1]
GO
ALTER TABLE [dbo].[PagePermission]  WITH CHECK ADD  CONSTRAINT [FK_TabPermission_Portal] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO
ALTER TABLE [dbo].[PagePermission] CHECK CONSTRAINT [FK_TabPermission_Portal]
GO
