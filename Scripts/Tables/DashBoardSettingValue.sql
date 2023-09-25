

CREATE TABLE [dbo].[DashBoardSettingValue](
	[DashBoardSettingValueID] [int] IDENTITY(1,1) NOT NULL,
	[UserModuleID] [int] NOT NULL,
	[SettingKey] [nvarchar](256) NOT NULL,
	[SettingValue] [nvarchar](256) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_DashBoardSettingValue_IsActive_1]  DEFAULT ((1)),
	[IsDeleted] [bit] NULL CONSTRAINT [DF_DashBoardSettingValue_IsDeleted_1]  DEFAULT ((0)),
	[IsModified] [bit] NULL CONSTRAINT [DF_DashBoardSettingValue_IsModified_1]  DEFAULT ((0)),
	[AddedOn] [datetime] NULL CONSTRAINT [DF_DashBoardSettingValue_AddedOn_1]  DEFAULT (getdate()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_DashBoardSettingValue_UpdatedOn_1]  DEFAULT (getdate()),
	[DeletedOn] [datetime] NULL,
	[PortalID] [int] NULL CONSTRAINT [DF_DashBoardSettingValue_PortalID_1]  DEFAULT ((1)),
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[DeletedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_DashBoardSettingValue] PRIMARY KEY CLUSTERED 
(
	[UserModuleID] ASC,
	[SettingKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


