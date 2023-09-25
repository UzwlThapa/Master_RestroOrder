

CREATE TABLE [dbo].[SessionTracker](
	[SessionTrackerID] [int] IDENTITY(1,1) NOT NULL,
	[SessionUserHostAddress] [nvarchar](500) NULL,
	[SessionUserAgent] [nvarchar](500) NULL,
	[SessionBrowser] [nvarchar](500) NULL,
	[SessionCrawler] [nvarchar](500) NULL,
	[SessionURL] [nvarchar](500) NULL,
	[SessionVisitCount] [int] NULL,
	[SessionOriginalReferrer] [nvarchar](500) NULL,
	[SessionOriginalURL] [nvarchar](500) NULL,
	[Start] [datetime] NULL,
	[End] [datetime] NULL,
	[Username] [nvarchar](256) NULL,
	[PortalID] [int] NULL,
	[SessionID] [nvarchar](50) NULL,
 CONSTRAINT [PK_SessionTracker] PRIMARY KEY CLUSTERED 
(
	[SessionTrackerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


