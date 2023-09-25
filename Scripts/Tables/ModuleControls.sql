

CREATE TABLE [dbo].[ModuleControls](
	[ModuleControlID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleDefID] [int] NULL,
	[ControlKey] [nvarchar](50) NULL,
	[ControlTitle] [nvarchar](50) NULL,
	[ControlSrc] [nvarchar](256) NULL,
	[IconFile] [nvarchar](100) NULL,
	[ControlType] [int] NULL,
	[DisplayOrder] [int] NULL,
	[HelpUrl] [nvarchar](200) NULL,
	[SupportsPartialRendering] [bit] NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_ModuleControls_IsActive]  DEFAULT ((1)),
	[IsDeleted] [bit] NULL CONSTRAINT [DF_ModuleControls_IsDeleted]  DEFAULT ((0)),
	[IsModified] [bit] NULL CONSTRAINT [DF_ModuleControls_IsModified]  DEFAULT ((0)),
	[AddedOn] [datetime] NULL CONSTRAINT [DF_ModuleControls_AddedOn]  DEFAULT (getdate()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_ModuleControls_UpdatedOn]  DEFAULT (getdate()),
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NULL CONSTRAINT [DF_ModuleControls_PortalID]  DEFAULT ((1)),
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_ModuleControls] PRIMARY KEY CLUSTERED 
(
	[ModuleControlID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ModuleControls]  WITH CHECK ADD  CONSTRAINT [FK_ModuleControls_ModuleDefinitions] FOREIGN KEY([ModuleDefID])
REFERENCES [dbo].[ModuleDefinitions] ([ModuleDefID])
GO

ALTER TABLE [dbo].[ModuleControls] CHECK CONSTRAINT [FK_ModuleControls_ModuleDefinitions]
GO

ALTER TABLE [dbo].[ModuleControls]  WITH CHECK ADD  CONSTRAINT [FK_ModuleControls_Portal] FOREIGN KEY([PortalID])
REFERENCES [dbo].[Portal] ([PortalID])
GO

ALTER TABLE [dbo].[ModuleControls] CHECK CONSTRAINT [FK_ModuleControls_Portal]
GO


