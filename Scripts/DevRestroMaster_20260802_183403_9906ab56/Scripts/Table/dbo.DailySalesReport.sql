SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DailySalesReport](
	[SalesReportID] [int] IDENTITY(1,1) NOT NULL,
	[Period] [date] NULL,
	[BillNo] [nvarchar](256) NULL,
	[BillTime] [time](0) NULL,
	[BasicAmount] [decimal](18, 2) NULL,
	[VAT] [decimal](18, 2) NULL,
	[TotalDiscount] [decimal](18, 2) NULL,
	[ServiceCharge] [decimal](18, 2) NULL,
	[NetAmount] [decimal](18, 2) NULL,
	[TenderAmount] [decimal](18, 2) NULL,
	[ReturnAmount] [decimal](18, 2) NULL,
	[ReceivedAmount] [decimal](18, 2) NULL,
	[PaymentMode] [nvarchar](256) NULL,
	[ChequeAmount] [decimal](18, 2) NULL,
	[CardAmount] [decimal](18, 2) NULL,
	[CreditAmount] [decimal](18, 2) NULL,
	[Customer] [varchar](200) NULL,
 CONSTRAINT [PK__DailySal__ED7CE8A60A93743A] PRIMARY KEY CLUSTERED 
(
	[SalesReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
