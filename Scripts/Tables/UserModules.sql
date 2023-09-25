

CREATE TABLE [dbo].[UserModules](
	[UserModuleID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleDefID] [int] NULL,
	[UserModuleTitle] [nvarchar](256) NULL,
	[AllPages] [bit] NULL,
	[InheritViewPermissions] [bit] NULL,
	[Header] [ntext] NULL,
	[Footer] [ntext] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
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
	[SEOName] [nvarchar](100) NULL,
	[ShowInPages] [nvarchar](256) NULL,
	[IsHandheld] [bit] NULL CONSTRAINT [DF_UserModules_IsHandheld]  DEFAULT ((0)),
	[SuffixClass] [nvarchar](max) NULL,
	[HeaderText] [nvarchar](500) NULL,
	[ShowHeaderText] [bit] NULL,
	[IsInAdmin] [bit] NULL,
 CONSTRAINT [PK_Modules] PRIMARY KEY CLUSTERED 
(
	[UserModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[UserModules]  WITH CHECK ADD  CONSTRAINT [FK_Modules_ModuleDefinitions] FOREIGN KEY([ModuleDefID])
REFERENCES [dbo].[ModuleDefinitions] ([ModuleDefID])
GO

ALTER TABLE [dbo].[UserModules] CHECK CONSTRAINT [FK_Modules_ModuleDefinitions]
GO


