SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ro_flatandPerDiscount](
	[pfdId] [int] IDENTITY(1,1) NOT NULL,
	[SalesMasterId] [int] NULL,
	[kotdis] [varchar](128) NULL,
	[bardis] [varchar](128) NULL,
	[isflatdis] [bit] NULL,
	[isLoyalty] [bit] NULL,
	[loyaltydis] [varchar](128) NULL,
	[roomdis] [varchar](128) NULL,
	[bakerydis] [varchar](128) NULL,
	[pizzadis] [varchar](128) NULL,
	[kotAmt] [int] NULL,
	[barAmt] [int] NULL,
	[roomAmt] [int] NULL,
	[bakeryAmt] [int] NULL,
	[pizzaAmt] [int] NULL,
	[tradingAmt] [int] NULL,
	[tradingDis] [decimal](15, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[pfdId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ro_flatandPerDiscount] ADD  CONSTRAINT [DF_ro_flatandPerDiscount_kotdis]  DEFAULT ((0)) FOR [kotdis]
GO
ALTER TABLE [dbo].[ro_flatandPerDiscount] ADD  CONSTRAINT [DF_ro_flatandPerDiscount_bardis]  DEFAULT ((0)) FOR [bardis]
GO
ALTER TABLE [dbo].[ro_flatandPerDiscount] ADD  CONSTRAINT [DF_ro_flatandPerDiscount_loyaltydis]  DEFAULT ((0)) FOR [loyaltydis]
GO
ALTER TABLE [dbo].[ro_flatandPerDiscount] ADD  CONSTRAINT [DF_ro_flatandPerDiscount_roomdis]  DEFAULT ((0)) FOR [roomdis]
GO
