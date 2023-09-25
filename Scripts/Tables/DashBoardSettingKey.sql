

CREATE TABLE [dbo].[DashBoardSettingKey](
	[DashBoardSettingID] [int] NOT NULL,
	[SettingKey] [nvarchar](256) NOT NULL,
	[SettingValue] [nvarchar](256) NOT NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_DashBoardSettingKey_IsActive_1]  DEFAULT ((1)),
	[IsDeleted] [bit] NULL CONSTRAINT [DF_DashBoardSettingKey_IsDeleted_1]  DEFAULT ((0)),
	[IsModified] [bit] NULL CONSTRAINT [DF_DashBoardSettingKey_IsModified_1]  DEFAULT ((0)),
	[AddedOn] [datetime] NULL CONSTRAINT [DF_DashBoardSettingKey_AddedOn_1]  DEFAULT (getdate()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_DashBoardSettingKey_UpdatedOn_1]  DEFAULT (getdate()),
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NOT NULL CONSTRAINT [DF_DashBoardSettingKey_PortalID_1]  DEFAULT ((1)),
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_DashBoardSettingKey] PRIMARY KEY CLUSTERED 
(
	[SettingKey] ASC,
	[PortalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


