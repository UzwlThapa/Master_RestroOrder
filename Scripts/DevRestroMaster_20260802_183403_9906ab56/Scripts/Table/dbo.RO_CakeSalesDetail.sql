SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_CakeSalesDetail](
	[SalesDetailId] [int] IDENTITY(1,1) NOT NULL,
	[SalesMasterId] [int] NULL,
	[ItemId] [int] NULL,
	[ItemName] [nvarchar](256) NULL,
	[Quantity] [float] NULL,
	[Rate] [decimal](18, 2) NULL,
	[Amount] [decimal](18, 2) NULL,
	[NetAmount] [decimal](18, 2) NULL,
	[CostCenterId] [int] NULL,
	[SalesType] [nvarchar](20) NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[RO_CakeSalesDetail]  WITH CHECK ADD  CONSTRAINT [FK_CakeSalesMaster_CakeSalesDetail] FOREIGN KEY([SalesMasterId])
REFERENCES [dbo].[RO_CakeSalesMaster] ([SalesMasterId])
GO
ALTER TABLE [dbo].[RO_CakeSalesDetail] CHECK CONSTRAINT [FK_CakeSalesMaster_CakeSalesDetail]
GO
