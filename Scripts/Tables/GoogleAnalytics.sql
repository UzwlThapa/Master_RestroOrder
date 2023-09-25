

CREATE TABLE [dbo].[GoogleAnalytics](
	[GoogleAnalyticsID] [int] IDENTITY(1,1) NOT NULL,
	[GoogleJSCode] [nvarchar](1500) NULL,
	[IsActive] [bit] NULL,
	[IsModified] [bit] NULL,
	[AddedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[PortalID] [int] NULL,
	[AddedBy] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NULL,
 CONSTRAINT [PK_GoogleAnalytics] PRIMARY KEY CLUSTERED 
(
	[GoogleAnalyticsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[GoogleAnalytics] ADD  CONSTRAINT [DF_GoogleAnalytics_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[GoogleAnalytics] ADD  CONSTRAINT [DF_GoogleAnalytics_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO

ALTER TABLE [dbo].[GoogleAnalytics] ADD  CONSTRAINT [DF_GoogleAnalytics_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO

ALTER TABLE [dbo].[GoogleAnalytics] ADD  CONSTRAINT [DF_GoogleAnalytics_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
GO


