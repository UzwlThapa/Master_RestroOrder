

CREATE TABLE [dbo].[ProfileValue](
	[ProfileValueID] [int] IDENTITY(1,1) NOT NULL,
	[ProfileID] [int] NULL,
	[Name] [nvarchar](100) NULL,
	[DisplayOrder] [int] NULL,
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
 CONSTRAINT [PK_ProfileValue] PRIMARY KEY CLUSTERED 
(
	[ProfileValueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ProfileValue] ADD  CONSTRAINT [DF_ProfileValue_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[ProfileValue] ADD  CONSTRAINT [DF_ProfileValue_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[ProfileValue] ADD  CONSTRAINT [DF_ProfileValue_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO

ALTER TABLE [dbo].[ProfileValue] ADD  CONSTRAINT [DF_ProfileValue_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO

ALTER TABLE [dbo].[ProfileValue] ADD  CONSTRAINT [DF_ProfileValue_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
GO

ALTER TABLE [dbo].[ProfileValue] ADD  CONSTRAINT [DF_ProfileValue_PortalID]  DEFAULT ((1)) FOR [PortalID]
GO

ALTER TABLE [dbo].[ProfileValue]  WITH CHECK ADD  CONSTRAINT [FK_ProfileValue_Portal] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO

ALTER TABLE [dbo].[ProfileValue] CHECK CONSTRAINT [FK_ProfileValue_Portal]
GO

ALTER TABLE [dbo].[ProfileValue]  WITH CHECK ADD  CONSTRAINT [FK_ProfileValue_Profile] FOREIGN KEY([ProfileID])
REFERENCES [dbo].[Profile] ([ProfileID])
GO

ALTER TABLE [dbo].[ProfileValue] CHECK CONSTRAINT [FK_ProfileValue_Profile]
GO


