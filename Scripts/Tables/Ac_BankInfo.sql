
CREATE TABLE [dbo].[Ac_BankInfo](
	[BankAccountID] [int] IDENTITY(1,1) NOT NULL,
	[FinancialAcID] [int] NULL,
	[PhoneNo] [nchar](10) NULL,
	[Branch] [nchar](10) NULL,
	[ContactPerson] [nchar](10) NULL,
	[IsFixed] [bit] NULL,
	[InterestRate] [decimal](18, 6) NULL,
	[OpenDate] [datetime] NULL,
	[MatureDate] [datetime] NULL,
	[MinimumBalance] [decimal](18, 2) NULL,
 CONSTRAINT [PK_Ac_BankInfo] PRIMARY KEY CLUSTERED 
(
	[BankAccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


