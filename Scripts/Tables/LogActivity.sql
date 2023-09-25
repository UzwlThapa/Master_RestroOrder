

CREATE TABLE [dbo].[LogActivity](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[Action] [nvarchar](max) NULL,
	[ActivityUserName] [nvarchar](150) NULL,
	[LogDateTime] [datetime] NULL,
	[PortalID] [int] NULL,
	[UserModuleID] [int] NULL,
	[ID] [int] NULL,
 CONSTRAINT [PK_LogActivity] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


