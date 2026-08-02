SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROI_PurchaseStockTransaction](
	[PurchaseTranId] [int] IDENTITY(1,1) NOT NULL,
	[PurchaseDetailId] [int] NULL,
	[StoreId] [int] NULL,
	[ItemId] [int] NULL,
	[PurchaseQty] [decimal](18, 2) NULL,
	[PurchaseUnit] [int] NULL,
	[PurchaseRate] [decimal](18, 2) NULL,
	[PurchaseAmt] [decimal](18, 2) NULL,
	[AvailableQty] [decimal](18, 2) NULL,
	[TransactionDate] [datetime] NULL,
 CONSTRAINT [PK_ROI_PurchaseStockTransaction] PRIMARY KEY CLUSTERED 
(
	[PurchaseTranId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
