SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNet_SqlCacheTablesForChangeNotification](
	[tableName] [nvarchar](450) NOT NULL,
	[notificationCreated] [datetime] NOT NULL,
	[changeId] [int] NOT NULL,
 CONSTRAINT [PK__AspNet_SqlCacheT__6E2152BE] PRIMARY KEY CLUSTERED 
(
	[tableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[AspNet_SqlCacheTablesForChangeNotification] ADD  CONSTRAINT [DF__AspNet_Sq__notif__6F1576F7]  DEFAULT (getdate()) FOR [notificationCreated]
GO
ALTER TABLE [dbo].[AspNet_SqlCacheTablesForChangeNotification] ADD  CONSTRAINT [DF__AspNet_Sq__chang__70099B30]  DEFAULT ((0)) FOR [changeId]
GO
