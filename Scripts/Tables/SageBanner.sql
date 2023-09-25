
CREATE TABLE [dbo].[SageBanner](
	[BannerID] [int] IDENTITY(1,1) NOT NULL,
	[BannerName] [nvarchar](max) NULL,
	[BannerDescription] [nvarchar](max) NULL,
	[UserModuleID] [int] NULL,
	[PortalID] [int] NULL,
	[CultureCode] [nvarchar](100) NULL,
 CONSTRAINT [PK_SageBanner] PRIMARY KEY CLUSTERED 
(
	[BannerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


