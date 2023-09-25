

CREATE TABLE [dbo].[PagePermission](
	[PagePermissionID] [int] IDENTITY(1,1) NOT NULL,
	[PageID] [int] NULL,
	[PermissionID] [int] NULL,
	[AllowAccess] [bit] NULL,
	[RoleID] [uniqueidentifier] NULL,
	[Username] [nvarchar](256) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_TabPermission_IsActive]  DEFAULT ((1)),
	[IsDeleted] [bit] NULL CONSTRAINT [DF_TabPermission_IsDeleted]  DEFAULT ((0)),
	[IsModified] [bit] NULL CONSTRAINT [DF_TabPermission_IsModified]  DEFAULT ((0)),
	[AddedOn] [datetime] NULL CONSTRAINT [DF_TabPermission_AddedOn]  DEFAULT (getdate()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_TabPermission_UpdatedOn]  DEFAULT (getdate()),
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NULL CONSTRAINT [DF_TabPermission_PortalID]  DEFAULT ((1)),
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_TabPermission] PRIMARY KEY CLUSTERED 
(
	[PagePermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

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


