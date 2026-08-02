SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROI_ComplementryStockTransaction](
	[CompTranId] [int] IDENTITY(1,1) NOT NULL,
	[ComplementryDetailId] [int] NULL,
	[StoreId] [int] NULL,
	[ItemId] [int] NULL,
	[CompQty] [decimal](18, 2) NULL,
	[CompUnit] [int] NULL,
	[CompAmt] [decimal](18, 2) NULL,
	[TransactionDate] [datetime] NULL,
 CONSTRAINT [PK__ROI_Comp__345D45BE73EEEA67] PRIMARY KEY CLUSTERED 
(
	[CompTranId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
