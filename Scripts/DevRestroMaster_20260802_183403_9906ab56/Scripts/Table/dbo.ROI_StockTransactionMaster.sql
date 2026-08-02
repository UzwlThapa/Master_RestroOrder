SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROI_StockTransactionMaster](
	[StockTranMasterId] [int] IDENTITY(1,1) NOT NULL,
	[OpeningTranId] [int] NULL,
	[PurchaseTranId] [int] NULL,
	[SalesTranId] [int] NULL,
	[PurchaseReturnTranId] [int] NULL,
	[AdjustTranId] [int] NULL,
	[CompTranId] [int] NULL,
	[IssueTranId] [int] NULL,
	[StoreId] [int] NULL,
	[ItemId] [int] NULL,
	[AvailableQty] [decimal](18, 2) NULL,
	[Rate] [decimal](18, 2) NULL,
	[ItemBalance] [decimal](18, 2) NULL,
	[ItemBalUnitId] [int] NULL,
	[ItemValue] [decimal](18, 2) NULL,
	[TransactionDate] [datetime] NULL,
	[SalesReturnId] [int] NULL,
 CONSTRAINT [PK__ROI_Stoc__70F3B40D5B4000AD] PRIMARY KEY CLUSTERED 
(
	[StockTranMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [IX_StockTransaction_ItemId] ON [dbo].[ROI_StockTransactionMaster]
(
	[ItemId] ASC,
	[StockTranMasterId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_StockTransactionMaster_ItemId_Desc] ON [dbo].[ROI_StockTransactionMaster]
(
	[ItemId] ASC,
	[StockTranMasterId] DESC
)
INCLUDE([ItemBalance],[ItemValue]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
