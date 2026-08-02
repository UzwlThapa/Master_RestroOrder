SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DailyStockReport](
	[StockReportID] [int] IDENTITY(1,1) NOT NULL,
	[Period] [date] NULL,
	[ItemID] [int] NULL,
	[ItemName] [nvarchar](256) NULL,
	[OpeningBalance] [decimal](18, 2) NULL,
	[PurchaseBalance] [decimal](18, 2) NULL,
	[ConsumedBalance] [decimal](18, 2) NULL,
	[ClosingBalance] [decimal](18, 2) NULL,
	[Symbol] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[StockReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
