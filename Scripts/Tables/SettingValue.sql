

CREATE TABLE [dbo].[SettingValue](
	[SettingValueID] [int] IDENTITY(1,1) NOT NULL,
	[SettingType] [nvarchar](100) NOT NULL,
	[SettingTypeID] [int] NOT NULL,
	[SettingKey] [nvarchar](256) NOT NULL,
	[SettingValue] [nvarchar](256) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_SettingValue_IsActive]  DEFAULT ((1)),
	[IsDeleted] [bit] NULL CONSTRAINT [DF_SettingValue_IsDeleted]  DEFAULT ((0)),
	[IsModified] [bit] NULL CONSTRAINT [DF_SettingValue_IsModified]  DEFAULT ((0)),
	[AddedOn] [datetime] NULL CONSTRAINT [DF_SettingValue_AddedOn]  DEFAULT (getdate()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_SettingValue_UpdatedOn]  DEFAULT (getdate()),
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NULL CONSTRAINT [DF_SettingValue_PortalID]  DEFAULT ((1)),
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
	[IsCacheable] [bit] NULL CONSTRAINT [DF_SettingValue_IsCacheable]  DEFAULT ((0)),
 CONSTRAINT [PK_SettingValue] PRIMARY KEY CLUSTERED 
(
	[SettingType] ASC,
	[SettingTypeID] ASC,
	[SettingKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


