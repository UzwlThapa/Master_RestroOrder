

CREATE TABLE [dbo].[Ac_Setting](
	[SettingID] [int] IDENTITY(1,1) NOT NULL,
	[IsEntryVerrificationRequired] [bit] NULL,
	[IsActive] [bit] NOT NULL,
	[AddedBy] [nvarchar](256) NULL,
	[AddedOn] [datetime] NOT NULL,
	[IsUpdated] [bit] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[IsArchived] [bit] NULL,
	[ArchivedOn] [datetime] NULL,
	[ArchivedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_Ac_Setting] PRIMARY KEY CLUSTERED 
(
	[SettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Ac_Setting] ADD  CONSTRAINT [DF_Ac_Setting_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO

ALTER TABLE [dbo].[Ac_Setting] ADD  CONSTRAINT [DF_Ac_Setting_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO

ALTER TABLE [dbo].[Ac_Setting] ADD  CONSTRAINT [DF_Ac_Setting_IsUpdated]  DEFAULT ((0)) FOR [IsUpdated]
GO

ALTER TABLE [dbo].[Ac_Setting] ADD  CONSTRAINT [DF_Ac_Setting_IsArchived]  DEFAULT ((0)) FOR [IsArchived]
GO


