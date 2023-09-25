

CREATE TABLE [dbo].[Ac_TempTransactionDetail](
	[TransactionDetailID] [int] IDENTITY(1,1) NOT NULL,
	[TransactionID] [int] NULL,
	[FinancialAcID] [int] NULL,
	[MemberShipID] [int] NULL,
	[ChequeNo] [varchar](50) NULL,
	[ChequeDate] [nvarchar](250) NULL,
	[Particulars] [nvarchar](250) NULL,
	[Debit] [money] NULL,
	[Credit] [money] NULL,
 CONSTRAINT [PK_Ac_TempTransactionDetail] PRIMARY KEY CLUSTERED 
(
	[TransactionDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


