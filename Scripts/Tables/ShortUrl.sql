

CREATE TABLE [dbo].[ShortUrl](
	[ShortUrlID] [uniqueidentifier] NOT NULL,
	[ShortUrlKey] [nvarchar](10) NULL,
	[ShortUrlValue] [nvarchar](1000) NULL,
	[AddedOn] [datetime] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_ShortUrl] PRIMARY KEY CLUSTERED 
(
	[ShortUrlID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


