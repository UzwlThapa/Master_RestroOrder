

CREATE TABLE [dbo].[LoginLog](
	[LoginLogID] [int] IDENTITY(1,1) NOT NULL,
	[ClientIPAddress] [nvarchar](30) NULL,
	[ConnectionStart] [datetime] NULL,
	[ConnectionEnd] [datetime] NULL,
	[Username] [nvarchar](256) NULL,
 CONSTRAINT [PK_LoginLog] PRIMARY KEY CLUSTERED 
(
	[LoginLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


