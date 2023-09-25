

CREATE TABLE [dbo].[RO_LoyaltyMembership](
	[MembershipID] [int] IDENTITY(1,1) NOT NULL,
	[Fname] [nvarchar](256) NULL,
	[Lname] [nvarchar](256) NULL,
	[Address] [nvarchar](256) NULL,
	[City] [nvarchar](256) NULL,
	[Country] [nvarchar](256) NULL,
	[TelHome] [nvarchar](256) NULL,
	[TelWork] [nvarchar](256) NULL,
	[TelMobile] [nvarchar](256) NULL,
	[Email] [nvarchar](256) NULL,
	[Occupation] [nvarchar](256) NULL,
	[Company] [nvarchar](256) NULL,
	[Birthday] [nvarchar](256) NULL,
	[Anniversary] [nvarchar](256) NULL,
	[CardNumber] [nvarchar](256) NULL,
	[DateOfIssue] [datetime] NULL CONSTRAINT [DF_RO_LoyaltyMembership_DateOfIssue]  DEFAULT (getdate()),
	[DateOfExpire] [datetime] NULL,
	[discount] [decimal](18, 2) NULL,
	[PAN] [nvarchar](250) NULL,
	[IsCustomer] [bit] NULL,
	[RemainingBalance] [decimal](18, 2) NULL CONSTRAINT [DF_RO_LoyaltyMembership_RemainingBalance]  DEFAULT ((0)),
	[UptoNowPaid] [decimal](18, 2) NULL CONSTRAINT [DF_RO_LoyaltyMembership_UptoNowPaid]  DEFAULT ((0)),
	[IsVat] [bit] NULL CONSTRAINT [DF_RO_LoyaltyMembership_IsVat]  DEFAULT ((0)),
 CONSTRAINT [PK_RO_LoyaltyMembership] PRIMARY KEY CLUSTERED 
(
	[MembershipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


