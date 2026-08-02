SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NL_MobileSubsciber](
	[MobSubscriberID] [int] IDENTITY(1,1) NOT NULL,
	[MobileNumber] [bigint] NULL,
	[IsSubscribed] [bit] NULL,
	[ClientIP] [nvarchar](128) NULL,
	[UserModuleID] [int] NULL,
	[PortalID] [int] NULL,
	[AddedOn] [datetime] NULL,
	[Addedby] [nvarchar](128) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_NL_MobileSubsciber] PRIMARY KEY CLUSTERED 
(
	[MobSubscriberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
