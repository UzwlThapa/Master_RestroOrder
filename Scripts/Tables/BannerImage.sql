

CREATE TABLE [dbo].[BannerImage](
	[ImageID] [int] IDENTITY(1,1) NOT NULL,
	[BannerID] [int] NOT NULL,
	[UserModuleID] [int] NOT NULL,
	[ImagePath] [nvarchar](256) NULL,
	[Caption] [nvarchar](max) NULL,
	[LinkToImage] [nvarchar](256) NULL,
	[HTMLBodyText] [nvarchar](max) NULL,
	[NavigationImage] [nvarchar](256) NULL,
	[ReadButtonText] [nvarchar](256) NULL,
	[ReadMorePage] [nvarchar](256) NULL,
	[Description] [nvarchar](max) NULL,
	[PortalID] [int] NULL,
	[DisplayOrder] [int] NULL CONSTRAINT [DF_BannerImage_DisplayOrder]  DEFAULT ((0)),
	[CultureCode] [nvarchar](100) NULL,
 CONSTRAINT [PK_BannerImage] PRIMARY KEY CLUSTERED 
(
	[ImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


