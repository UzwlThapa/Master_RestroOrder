SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Modules](
	[ModuleID] [int] IDENTITY(1,1) NOT NULL,
	[FriendlyName] [nvarchar](128) NULL,
	[Description] [nvarchar](2000) NULL,
	[Version] [nvarchar](8) NULL,
	[IsPremium] [bit] NULL,
	[IsAdmin] [bit] NULL,
	[IsRequired] [bit] NULL,
	[BusinessControllerClass] [nvarchar](200) NULL,
	[FolderName] [nvarchar](128) NULL,
	[ModuleName] [nvarchar](128) NULL,
	[SupportedFeatures] [int] NULL,
	[CompatibleVersions] [nvarchar](500) NULL,
	[Dependencies] [nvarchar](400) NULL,
	[Permissions] [nvarchar](400) NULL,
	[PackageID] [int] NULL,
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
 CONSTRAINT [PK_DesktopModule] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Modules]  WITH CHECK ADD  CONSTRAINT [FK_DesktopModule_Portal] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO
ALTER TABLE [dbo].[Modules] CHECK CONSTRAINT [FK_DesktopModule_Portal]
GO
