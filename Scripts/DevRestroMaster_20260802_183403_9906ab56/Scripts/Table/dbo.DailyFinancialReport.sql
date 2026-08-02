SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DailyFinancialReport](
	[FinancialID] [int] IDENTITY(1,1) NOT NULL,
	[Period] [date] NULL,
	[OpeningBalance] [decimal](18, 2) NULL,
	[Cash] [decimal](18, 2) NULL,
	[Cheque] [decimal](18, 2) NULL,
	[Card] [decimal](18, 2) NULL,
	[Credit] [decimal](18, 2) NULL,
	[eSewa] [decimal](18, 2) NULL,
	[FonePay] [decimal](18, 2) NULL,
	[TotalCashReceived] [decimal](18, 2) NULL,
	[SurplusDeficit] [decimal](18, 2) NULL,
	[CreditCollectedInCash] [decimal](18, 2) NULL,
	[CashInCounter] [decimal](18, 2) NULL,
	[CashSettlement] [decimal](18, 2) NULL,
	[ClosingBalance] [decimal](18, 2) NULL,
	[IsClosed] [bit] NULL,
	[ClosedTS] [datetime] NULL,
	[CreditCollectedIneSewa] [decimal](18, 2) NULL,
	[CreditCollectedInFonePay] [decimal](18, 2) NULL,
	[CreditCollectedInCard] [decimal](18, 2) NULL,
	[CreditCollectedInCheque] [decimal](18, 2) NULL,
	[AdvanceCollectedInCash] [decimal](18, 2) NULL,
	[AdvanceCollectedIneSewa] [decimal](18, 2) NULL,
	[AdvanceCollectedInFonePay] [decimal](18, 2) NULL,
	[AdvanceCollectedInCard] [decimal](18, 2) NULL,
	[AdvanceCollectedInCheque] [decimal](18, 2) NULL,
	[TotalSales] [decimal](18, 2) NULL,
	[TotalExpenses] [decimal](18, 2) NULL,
	[ExpensesRemark] [varchar](500) NULL,
	[CreditSettlement] [decimal](18, 2) NULL,
	[ReturnAmtCash] [decimal](18, 2) NULL,
	[ReturnAmtCard] [decimal](18, 2) NULL,
	[ReturnAmtCheque] [decimal](18, 2) NULL,
	[ReturnAmteSewa] [decimal](18, 2) NULL,
	[ReturnAmtFonePay] [decimal](18, 2) NULL,
 CONSTRAINT [PK__DailyFin__292681C0010A0A00] PRIMARY KEY CLUSTERED 
(
	[FinancialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [IX_DailyFinancialReport_IsClosed_FinancialID] ON [dbo].[DailyFinancialReport]
(
	[IsClosed] ASC,
	[FinancialID] ASC
)
INCLUDE([ClosedTS]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DailyFinancialReport] ADD  CONSTRAINT [DF_DailyFinancialReport_ClosedTS]  DEFAULT (getdate()) FOR [ClosedTS]
GO
