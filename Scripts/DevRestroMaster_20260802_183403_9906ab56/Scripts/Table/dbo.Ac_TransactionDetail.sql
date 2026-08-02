SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ac_TransactionDetail](
	[TransactionDetailID] [int] IDENTITY(1,1) NOT NULL,
	[TransactionID] [int] NULL,
	[FinancialAcID] [int] NULL,
	[MemberShipID] [int] NULL,
	[ChequeNo] [varchar](50) NULL,
	[ChequeDate] [nvarchar](250) NULL,
	[Particulars] [nvarchar](250) NULL,
	[Debit] [money] NULL,
	[Credit] [money] NULL,
 CONSTRAINT [PK_Ac_TransactionDetail] PRIMARY KEY CLUSTERED 
(
	[TransactionDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
