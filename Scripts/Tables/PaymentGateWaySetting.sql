

CREATE TABLE [dbo].[PaymentGateWaySetting](
	[UserModuleID] [int] NOT NULL,
	[PortalID] [int] NOT NULL,
	[Culture] [nvarchar](100) NULL,
	[PaymentID] [int] IDENTITY(1,1) NOT NULL,
	[SettingValue] [nvarchar](max) NOT NULL,
	[AddedBy] [nvarchar](256) NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_PaymentGateWaySetting] PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


