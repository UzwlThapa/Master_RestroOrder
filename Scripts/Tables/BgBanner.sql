

CREATE TABLE [dbo].[BgBanner](
	[ImageID] [int] IDENTITY(1,1) NOT NULL,
	[ImageName] [nvarchar](250) NULL,
	[Culture] [nvarchar](50) NULL,
	[IsActive] [bit] NULL,
	[ImageOrder] [int] NULL,
	[ImageLink] [nvarchar](250) NULL,
	[PortalID] [int] NULL,
 CONSTRAINT [PK_BgBanner] PRIMARY KEY CLUSTERED 
(
	[ImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


