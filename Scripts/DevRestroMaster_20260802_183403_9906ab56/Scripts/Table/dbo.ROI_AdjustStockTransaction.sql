SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROI_AdjustStockTransaction](
	[AdjTranId] [int] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NULL,
	[ItemId] [int] NULL,
	[AdjQty] [decimal](18, 2) NULL,
	[AdjUnit] [int] NULL,
	[AdjRate] [decimal](18, 2) NULL,
	[AdjAmt] [decimal](18, 2) NULL,
	[AvailableQty] [decimal](18, 2) NULL,
	[TransactionDate] [datetime] NULL,
 CONSTRAINT [PK__ROI_Adju__B8AB038EBD8418C9] PRIMARY KEY CLUSTERED 
(
	[AdjTranId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
