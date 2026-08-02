SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_Sales_View](
	[OrderMasterId] [int] NULL,
	[salesMasterId] [int] NOT NULL,
	[BillDate] [varchar](120) NULL,
	[InvoiceNo] [int] NULL,
	[billNo] [varchar](151) NULL,
	[BillCustomer] [nvarchar](max) NULL,
	[LoyalCustomer] [nvarchar](513) NULL,
	[Waiter] [varchar](128) NULL,
	[Table] [varchar](128) NOT NULL,
	[TableId] [int] NULL,
	[Room] [nvarchar](50) NOT NULL,
	[SubTotal] [decimal](19, 2) NULL,
	[TotalDiscount] [decimal](18, 2) NULL,
	[BasicAmount] [decimal](18, 2) NULL,
	[ServiceCharge] [decimal](18, 2) NOT NULL,
	[Vat] [decimal](18, 2) NOT NULL,
	[NetAmount] [decimal](18, 2) NULL,
	[ProviderID] [int] NULL,
	[ProviderName] [nvarchar](128) NULL,
	[PaymentModeID] [nvarchar](max) NULL,
	[PaymentMode] [varchar](10) NULL,
	[PayAmount] [decimal](18, 2) NULL,
	[SurplusDeficit] [decimal](38, 2) NULL,
	[Cashier] [nvarchar](256) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
