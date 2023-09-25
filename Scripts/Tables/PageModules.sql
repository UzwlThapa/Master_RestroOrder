

CREATE TABLE [dbo].[PageModules](
	[PageModuleID] [int] IDENTITY(1,1) NOT NULL,
	[PageID] [int] NULL,
	[UserModuleID] [int] NULL,
	[PaneName] [nvarchar](50) NULL,
	[ModuleOrder] [int] NULL,
	[CacheTime] [int] NULL,
	[Alignment] [nvarchar](50) NULL,
	[Color] [nvarchar](20) NULL,
	[Border] [nvarchar](1) NULL,
	[IconFile] [nvarchar](100) NULL,
	[Visibility] [int] NULL,
	[DisplayTitle] [bit] NULL CONSTRAINT [DF_TabModule_DisplayTitle]  DEFAULT ((1)),
	[DisplayPrint] [bit] NULL CONSTRAINT [DF_TabModule_DisplayPrint]  DEFAULT ((1)),
	[IsActive] [bit] NULL CONSTRAINT [DF_TabModule_IsActive]  DEFAULT ((1)),
	[IsDeleted] [bit] NULL CONSTRAINT [DF_TabModule_IsDeleted]  DEFAULT ((0)),
	[IsModified] [bit] NULL CONSTRAINT [DF_TabModule_IsModified]  DEFAULT ((0)),
	[AddedOn] [datetime] NULL CONSTRAINT [DF_TabModule_AddedOn]  DEFAULT (getdate()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_TabModule_UpdatedOn]  DEFAULT (getdate()),
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NULL CONSTRAINT [DF_TabModule_PortalID]  DEFAULT ((1)),
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_TabModule] PRIMARY KEY CLUSTERED 
(
	[PageModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PageModules]  WITH CHECK ADD  CONSTRAINT [FK_PageModules_Pages] FOREIGN KEY([PageID])
REFERENCES [dbo].[Pages] ([PageID])
GO

ALTER TABLE [dbo].[PageModules] CHECK CONSTRAINT [FK_PageModules_Pages]
GO

ALTER TABLE [dbo].[PageModules]  WITH CHECK ADD  CONSTRAINT [FK_PageModules_UserModules] FOREIGN KEY([UserModuleID])
REFERENCES [dbo].[UserModules] ([UserModuleID])
GO

ALTER TABLE [dbo].[PageModules] CHECK CONSTRAINT [FK_PageModules_UserModules]
GO


