SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TempPurchaseDetail](
	[TempPurchaseDetailID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NULL,
	[Quantity] [decimal](18, 4) NULL
) ON [PRIMARY]

GO
