

CREATE TABLE [dbo].[SageMenuSettingkey](
	[SageMenuSettingKeyID] [int] IDENTITY(1,1) NOT NULL,
	[SettingKey] [nvarchar](256) NOT NULL,
	[SettingValue] [nvarchar](256) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_SageMenuSettingkey_IsActive]  DEFAULT ((1)),
	[IsDeleted] [bit] NULL CONSTRAINT [DF_SageMenuSettingkey_IsDeleted]  DEFAULT ((0)),
	[IsModified] [bit] NULL CONSTRAINT [DF_SageMenuSettingkey_IsModified]  DEFAULT ((0)),
	[AddedOn] [datetime] NULL CONSTRAINT [DF_SageMenuSettingkey_AddedOn]  DEFAULT (getdate()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_SageMenuSettingkey_UpdatedOn]  DEFAULT (getdate()),
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NOT NULL CONSTRAINT [DF_SageMenuSettingkey_PortalID]  DEFAULT ((1)),
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_SageMenuSettingkey] PRIMARY KEY CLUSTERED 
(
	[SettingKey] ASC,
	[PortalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


