SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Packages](
	[PackageID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[ModuleID] [int] NULL,
	[Name] [nvarchar](128) NOT NULL,
	[FriendlyName] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](2000) NULL,
	[PackageType] [nvarchar](100) NOT NULL,
	[Version] [nvarchar](50) NOT NULL,
	[License] [ntext] NULL,
	[Manifest] [ntext] NULL,
	[Owner] [nvarchar](100) NULL,
	[Organization] [nvarchar](100) NULL,
	[Url] [nvarchar](250) NULL,
	[Email] [nvarchar](100) NULL,
	[ReleaseNotes] [ntext] NULL,
	[IsSystemPackage] [bit] NOT NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[IsModified] [bit] NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedOn] [datetime] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_Packages] PRIMARY KEY CLUSTERED 
(
	[PackageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[Packages] ADD  CONSTRAINT [DF_Packages_IsSystemPackage]  DEFAULT ((0)) FOR [IsSystemPackage]
GO
ALTER TABLE [dbo].[Packages] ADD  CONSTRAINT [DF_Packages_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Packages] ADD  CONSTRAINT [DF_Packages_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Packages] ADD  CONSTRAINT [DF_Packages_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO
ALTER TABLE [dbo].[Packages] ADD  CONSTRAINT [DF_Packages_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[Packages] ADD  CONSTRAINT [DF_Packages_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[Packages]  WITH CHECK ADD  CONSTRAINT [FK_Packages_Modules] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[Modules] ([ModuleID])
GO
ALTER TABLE [dbo].[Packages] CHECK CONSTRAINT [FK_Packages_Modules]
GO
ALTER TABLE [dbo].[Packages]  WITH CHECK ADD  CONSTRAINT [FK_Packages_Portal] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO
ALTER TABLE [dbo].[Packages] CHECK CONSTRAINT [FK_Packages_Portal]
GO
