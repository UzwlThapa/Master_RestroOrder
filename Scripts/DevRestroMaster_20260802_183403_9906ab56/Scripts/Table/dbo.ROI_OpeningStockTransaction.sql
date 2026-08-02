SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROI_OpeningStockTransaction](
	[OpeningTranId] [int] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NULL,
	[ItemId] [int] NULL,
	[OpeningQty] [decimal](18, 2) NULL,
	[OpeningUnit] [int] NULL,
	[OpeningRate] [decimal](18, 2) NULL,
	[OpeningAmt] [decimal](18, 2) NULL,
	[AvailableQty] [decimal](18, 2) NULL,
	[TransactionDate] [datetime] NULL,
 CONSTRAINT [PK__ROI_Open__78ADA8BDE4FBF688] PRIMARY KEY CLUSTERED 
(
	[OpeningTranId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
