SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_Discount](
	[SalesMasterId] [int] NULL,
	[DiscountValue] [decimal](12, 2) NULL,
	[IsFlatDis] [bit] NULL,
	[TotalDiscount] [decimal](12, 2) NULL,
	[BasicAmount] [decimal](18, 2) NULL,
	[SalesType] [varchar](30) NULL
) ON [PRIMARY]

GO
