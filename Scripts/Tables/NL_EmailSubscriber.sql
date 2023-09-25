

CREATE TABLE [dbo].[NL_EmailSubscriber](
	[SubscriberID] [int] IDENTITY(1,1) NOT NULL,
	[SubscriberEmail] [nvarchar](128) NULL,
	[IsSubscribed] [bit] NULL,
	[ClientIP] [nvarchar](128) NULL,
	[AddedOn] [datetime] NULL,
	[AddedBy] [nvarchar](128) NULL,
	[UserModuleID] [int] NULL,
	[PortalID] [int] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_NL_Subscriber] PRIMARY KEY CLUSTERED 
(
	[SubscriberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


