SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROI_SalesReturnStockTransaction](
	[SalesTranId] [int] IDENTITY(1,1) NOT NULL,
	[SalesDetailId] [int] NULL,
	[StoreId] [int] NULL,
	[ItemId] [int] NULL,
	[SalesReturnQty] [decimal](18, 2) NULL,
	[Unit] [int] NULL,
	[SalesReturnRate] [decimal](18, 2) NULL,
	[SalesReturnAmt] [decimal](18, 2) NULL,
	[TransactionDate] [datetime] NULL,
	[AvailableQty] [decimal](18, 2) NULL,
 CONSTRAINT [PK__ROI_Sale__B92123E6FF25F596] PRIMARY KEY CLUSTERED 
(
	[SalesTranId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
