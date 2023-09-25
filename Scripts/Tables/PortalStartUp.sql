

CREATE TABLE [dbo].[PortalStartUp](
	[PortalStartUpID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[EventLocationName] [nvarchar](50) NULL,
	[ControlUrl] [nvarchar](500) NULL,
	[IsAdmin] [bit] NULL,
	[IsControlUrl] [bit] NULL,
	[IsSystem] [bit] NOT NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[IsModified] [bit] NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedOn] [datetime] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_PortalStartUp] PRIMARY KEY CLUSTERED 
(
	[PortalStartUpID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PortalStartUp] ADD  CONSTRAINT [DF_PortalStartUp_IsSystem]  DEFAULT ((0)) FOR [IsSystem]
GO

ALTER TABLE [dbo].[PortalStartUp] ADD  CONSTRAINT [DF_PortalStartUp_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO


