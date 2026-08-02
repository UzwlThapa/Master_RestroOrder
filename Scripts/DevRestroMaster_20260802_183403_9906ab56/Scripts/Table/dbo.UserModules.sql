SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	[IsHandheld] [bit] NULL,
	[SuffixClass] [nvarchar](max) NULL,
	[HeaderText] [nvarchar](500) NULL,
	[ShowHeaderText] [bit] NULL,
	[IsInAdmin] [bit] NULL,
 CONSTRAINT [PK_Modules] PRIMARY KEY CLUSTERED 
(
	[UserModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [ix_UserModules_ModuleDefID_NN] ON [dbo].[UserModules]
(
	[ModuleDefID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserModules] ADD  CONSTRAINT [DF_UserModules_IsHandheld]  DEFAULT ((0)) FOR [IsHandheld]
GO
ALTER TABLE [dbo].[UserModules]  WITH CHECK ADD  CONSTRAINT [FK_Modules_ModuleDefinitions] FOREIGN KEY([ModuleDefID])
REFERENCES [dbo].[ModuleDefinitions] ([ModuleDefID])
GO
ALTER TABLE [dbo].[UserModules] CHECK CONSTRAINT [FK_Modules_ModuleDefinitions]
GO
