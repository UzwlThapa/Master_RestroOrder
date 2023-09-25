

CREATE TABLE [dbo].[Logo](
	[LogoID] [int] IDENTITY(1,1) NOT NULL,
	[LogoText] [nvarchar](100) NULL,
	[LogoPath] [nvarchar](200) NULL,
	[UserModuleID] [int] NULL,
	[PortalID] [int] NULL,
	[Slogan] [nvarchar](500) NULL,
	[url] [nvarchar](200) NULL,
	[CultureCode] [nvarchar](100) NULL,
 CONSTRAINT [PK_Logo] PRIMARY KEY CLUSTERED 
(
	[LogoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


