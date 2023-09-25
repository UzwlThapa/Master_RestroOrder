

CREATE TABLE [dbo].[NL_NewsLetter](
	[NewsLetterID] [int] IDENTITY(1,1) NOT NULL,
	[Subject] [nvarchar](128) NULL,
	[Body] [nvarchar](max) NULL,
	[IsSubscribed] [bit] NULL,
	[UserModuleID] [int] NULL,
	[PortalID] [int] NULL,
	[AddedOn] [datetime] NULL,
	[AddedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_NL_NewsLetter] PRIMARY KEY CLUSTERED 
(
	[NewsLetterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


