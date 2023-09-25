

CREATE TABLE [dbo].[Profile](
	[ProfileID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[PropertyTypeID] [int] NOT NULL,
	[DataType] [nvarchar](15) NULL,
	[IsRequired] [bit] NULL,
	[DisplayOrder] [int] NULL CONSTRAINT [DF_Profile_DisplayOrder]  DEFAULT ((1)),
	[IsActive] [bit] NULL CONSTRAINT [DF_Profile_IsActive]  DEFAULT ((1)),
	[IsDeleted] [bit] NULL CONSTRAINT [DF_Profile_IsDeleted]  DEFAULT ((0)),
	[IsModified] [bit] NULL CONSTRAINT [DF_Profile_IsModified]  DEFAULT ((0)),
	[AddedOn] [datetime] NULL CONSTRAINT [DF_Profile_AddedOn]  DEFAULT (getdate()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_Profile_UpdatedOn]  DEFAULT (getdate()),
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NULL CONSTRAINT [DF_Profile_PortalID]  DEFAULT ((1)),
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_Profile] PRIMARY KEY CLUSTERED 
(
	[ProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Profile]  WITH CHECK ADD  CONSTRAINT [FK_Profile_Portal] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO

ALTER TABLE [dbo].[Profile] CHECK CONSTRAINT [FK_Profile_Portal]
GO

ALTER TABLE [dbo].[Profile]  WITH CHECK ADD  CONSTRAINT [FK_Profile_PropertyType] FOREIGN KEY([PropertyTypeID])
REFERENCES [dbo].[PropertyType] ([PropertyTypeID])
GO

ALTER TABLE [dbo].[Profile] CHECK CONSTRAINT [FK_Profile_PropertyType]
GO


