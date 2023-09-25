

CREATE TABLE [dbo].[ModuleDefinitions](
	[ModuleDefID] [int] IDENTITY(1,1) NOT NULL,
	[FriendlyName] [nvarchar](128) NULL,
	[ModuleID] [int] NULL,
	[DefaultCacheTime] [int] NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_ModuleDefinitions_IsActive]  DEFAULT ((1)),
	[IsDeleted] [bit] NULL CONSTRAINT [DF_ModuleDefinitions_IsDeleted]  DEFAULT ((0)),
	[IsModified] [bit] NULL CONSTRAINT [DF_ModuleDefinitions_IsModified]  DEFAULT ((0)),
	[AddedOn] [datetime] NULL CONSTRAINT [DF_ModuleDefinitions_AddedOn]  DEFAULT (getdate()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_ModuleDefinitions_UpdatedOn]  DEFAULT (getdate()),
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NULL CONSTRAINT [DF_ModuleDefinitions_PortalID]  DEFAULT ((1)),
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_ModuleDefinitions] PRIMARY KEY CLUSTERED 
(
	[ModuleDefID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ModuleDefinitions]  WITH CHECK ADD  CONSTRAINT [FK_ModuleDefinitions_Modules] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[Modules] ([ModuleID])
GO

ALTER TABLE [dbo].[ModuleDefinitions] CHECK CONSTRAINT [FK_ModuleDefinitions_Modules]
GO

ALTER TABLE [dbo].[ModuleDefinitions]  WITH CHECK ADD  CONSTRAINT [FK_ModuleDefinitions_Portal] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO

ALTER TABLE [dbo].[ModuleDefinitions] CHECK CONSTRAINT [FK_ModuleDefinitions_Portal]
GO


