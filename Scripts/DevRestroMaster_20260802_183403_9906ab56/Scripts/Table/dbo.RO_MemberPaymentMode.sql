SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_MemberPaymentMode](
	[PaymentID] [int] IDENTITY(1,1) NOT NULL,
	[MemberPayId] [int] NULL,
	[VoucherNo] [nvarchar](256) NULL,
	[MemberID] [int] NULL,
	[PaymentModeID] [int] NULL,
	[ProviderID] [int] NULL,
	[TransactionNo] [nvarchar](256) NULL,
	[PayAmount] [decimal](18, 2) NULL,
	[TransactionID] [int] NULL,
	[SettlementAmount] [decimal](18, 2) NULL,
	[ReturnAmount] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
