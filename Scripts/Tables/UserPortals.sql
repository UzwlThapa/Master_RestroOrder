
CREATE TABLE [dbo].[UserPortals](
	[UserPortalsID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](256) NULL,
	[PortalID] [int] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[IsModified] [bit] NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedOn] [datetime] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_UserPortals] PRIMARY KEY CLUSTERED 
(
	[UserPortalsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[UserPortals] ADD  CONSTRAINT [DF_UserPortals_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[UserPortals] ADD  CONSTRAINT [DF_UserPortals_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[UserPortals] ADD  CONSTRAINT [DF_UserPortals_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO

ALTER TABLE [dbo].[UserPortals] ADD  CONSTRAINT [DF_UserPortals_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO

ALTER TABLE [dbo].[UserPortals] ADD  CONSTRAINT [DF_UserPortals_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
GO

ALTER TABLE [dbo].[UserPortals]  WITH CHECK ADD  CONSTRAINT [FK_UserPortals_Portal] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO

ALTER TABLE [dbo].[UserPortals] CHECK CONSTRAINT [FK_UserPortals_Portal]
GO


