SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DanfeServiceState](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LastSyncTime] [datetime] NULL,
	[LastServerTime] [datetime] NULL,
	[TenantCode] [nvarchar](50) NULL,
	[DatabaseName] [nvarchar](128) NULL,
	[LastDailyRunUtc] [datetime2](7) NULL,
	[LastActivityCheckUtc] [datetime2](7) NULL,
	[LastBackupUtc] [datetime2](7) NULL,
	[LastLicenseSyncUtc] [datetime2](7) NULL,
	[LicenseValid] [bit] NOT NULL,
	[LicenseValidTill] [datetime2](7) NULL,
	[UpdatedAtUtc] [datetime2](7) NOT NULL,
	[ServiceVersion] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [IX_DanfeServiceState_Tenant] ON [dbo].[DanfeServiceState]
(
	[TenantCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DanfeServiceState] ADD  CONSTRAINT [DF_DanfeServiceState_LicenseValid]  DEFAULT ((0)) FOR [LicenseValid]
GO
ALTER TABLE [dbo].[DanfeServiceState] ADD  CONSTRAINT [DF_DanfeServiceState_UpdatedAtUtc]  DEFAULT (getutcdate()) FOR [UpdatedAtUtc]
GO
ALTER TABLE [dbo].[DanfeServiceState] ADD  CONSTRAINT [DF_DanfeServiceState_ServiceVersion]  DEFAULT (N'1.0.0') FOR [ServiceVersion]
GO
