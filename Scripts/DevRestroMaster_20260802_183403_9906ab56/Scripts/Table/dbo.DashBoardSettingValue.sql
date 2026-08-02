SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DashBoardSettingValue](
	[DashBoardSettingValueID] [int] IDENTITY(1,1) NOT NULL,
	[UserModuleID] [int] NOT NULL,
	[SettingKey] [nvarchar](256) NOT NULL,
	[SettingValue] [nvarchar](256) NULL,
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
 CONSTRAINT [PK_DashBoardSettingValue] PRIMARY KEY CLUSTERED 
(
	[UserModuleID] ASC,
	[SettingKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[DashBoardSettingValue] ADD  CONSTRAINT [DF_DashBoardSettingValue_IsActive_1]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DashBoardSettingValue] ADD  CONSTRAINT [DF_DashBoardSettingValue_IsDeleted_1]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[DashBoardSettingValue] ADD  CONSTRAINT [DF_DashBoardSettingValue_IsModified_1]  DEFAULT ((0)) FOR [IsModified]
GO
ALTER TABLE [dbo].[DashBoardSettingValue] ADD  CONSTRAINT [DF_DashBoardSettingValue_AddedOn_1]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[DashBoardSettingValue] ADD  CONSTRAINT [DF_DashBoardSettingValue_UpdatedOn_1]  DEFAULT (getdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[DashBoardSettingValue] ADD  CONSTRAINT [DF_DashBoardSettingValue_PortalID_1]  DEFAULT ((1)) FOR [PortalID]
GO
