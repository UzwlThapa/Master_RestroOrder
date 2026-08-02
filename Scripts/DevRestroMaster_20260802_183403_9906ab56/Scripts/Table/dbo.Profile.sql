SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Profile](
	[ProfileID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[PropertyTypeID] [int] NOT NULL,
	[DataType] [nvarchar](15) NULL,
	[IsRequired] [bit] NULL,
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
 CONSTRAINT [PK_Profile] PRIMARY KEY CLUSTERED 
(
	[ProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_DisplayOrder]  DEFAULT ((1)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_PortalID]  DEFAULT ((1)) FOR [PortalID]
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
