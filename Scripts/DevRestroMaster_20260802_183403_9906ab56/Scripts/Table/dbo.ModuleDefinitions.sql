SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModuleDefinitions](
	[ModuleDefID] [int] IDENTITY(1,1) NOT NULL,
	[FriendlyName] [nvarchar](128) NULL,
	[ModuleID] [int] NULL,
	[DefaultCacheTime] [int] NULL,
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
 CONSTRAINT [PK_ModuleDefinitions] PRIMARY KEY CLUSTERED 
(
	[ModuleDefID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ModuleDefinitions] ADD  CONSTRAINT [DF_ModuleDefinitions_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ModuleDefinitions] ADD  CONSTRAINT [DF_ModuleDefinitions_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[ModuleDefinitions] ADD  CONSTRAINT [DF_ModuleDefinitions_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO
ALTER TABLE [dbo].[ModuleDefinitions] ADD  CONSTRAINT [DF_ModuleDefinitions_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[ModuleDefinitions] ADD  CONSTRAINT [DF_ModuleDefinitions_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[ModuleDefinitions] ADD  CONSTRAINT [DF_ModuleDefinitions_PortalID]  DEFAULT ((1)) FOR [PortalID]
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
